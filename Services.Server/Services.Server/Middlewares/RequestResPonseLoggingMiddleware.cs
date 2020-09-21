using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using System.IO;
using System.Reflection;
using System.Text;

namespace Services.Server
{
    public class RequestResPonseLoggingMiddleware
    {
        private readonly RequestDelegate _next;

        public RequestResPonseLoggingMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {

            var request = await FormatRequest(context.Request);

            var workDir = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Logs");
            await WriteLog(request, Path.Combine(workDir, $"{DateTime.Now.ToString("yyyyMMdd")}-mw-request.txt"));
            var originalBodyStream = context.Response.Body;
            using (var responseBody = new MemoryStream())
            {
                context.Response.Body = responseBody;
                await _next(context);

                var response = await FormatResponse(context.Request, context.Response);

                await WriteLog(response, Path.Combine(workDir, $"{DateTime.Now.ToString("yyyyMMdd")}-mw-response.txt"));

                await responseBody.CopyToAsync(originalBodyStream);
            }
        }

        private async Task<string> FormatRequest(HttpRequest request)
        {
            request.EnableBuffering();

            var buffer = new byte[Convert.ToInt32(request.ContentLength)];

            await request.Body.ReadAsync(buffer, 0, buffer.Length);

            var bodyAsText = Encoding.UTF8.GetString(buffer);

            request.Body.Seek(0, SeekOrigin.Begin);

            return $"{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}|{request.HttpContext.Connection.RemoteIpAddress.MapToIPv4().ToString()}|{request.Scheme}|{request.Method}|{request.Path.Value}|{request.QueryString}|{bodyAsText}";
        }

        private async Task<string> FormatResponse(HttpRequest request, HttpResponse response)
        {
            response.Body.Seek(0, SeekOrigin.Begin);

            string bodyAsText = await new StreamReader(response.Body).ReadToEndAsync();

            response.Body.Seek(0, SeekOrigin.Begin);

            if (response.StatusCode == 200)
                bodyAsText = string.Empty;

            return $"{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}|{response.HttpContext.Connection.RemoteIpAddress.MapToIPv4().ToString()}|{request.Scheme}|{request.Method}|{request.Path.Value}|{request.QueryString}|{response.StatusCode}|{bodyAsText}";
        }

        private async Task WriteLog(string message, string file)
        {
            var path = Path.GetDirectoryName(file);
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);

            using (FileStream fs = File.Open(file, FileMode.OpenOrCreate))
            {
                fs.Seek(0, SeekOrigin.End);
                await fs.WriteAsync(Encoding.UTF8.GetBytes(message.Replace("\r\n", "").Replace("\n", "") + Environment.NewLine));
            }
        }
    }
}
