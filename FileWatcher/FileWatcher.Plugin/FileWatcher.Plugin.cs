using FileWatcher.Contract;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http.Headers;

namespace FileWatcher.Plugin
{
  public  class FileWatcher : IFileWatchPlugin
    {
        public void Exceute(string host, string absPath, string relPath, WatcherChangeTypes type)
        {
            Task.Run(() => MwExec(host, absPath, relPath, type)).Wait();
        }

        private async Task MwExec(string host, string absPath, string relPath, WatcherChangeTypes type)
        {
            string token = null;
            token = await MwLogin();
            if (string.IsNullOrWhiteSpace(token))
                return;

            var ps = Enumerable.Repeat(new { Name = default(string), Value = default(string), DbType = default(int), Direction = default(int) }, 0).ToList();
            ps.Add(new { Name = "Host", Value = host, DbType = default(int), Direction = default(int) });
            ps.Add(new { Name = "AbsPath", Value = absPath, DbType = default(int), Direction = default(int) });
            ps.Add(new { Name = "WorkPath", Value = relPath, DbType = default(int), Direction = default(int) });
            ps.Add(new { Name = "Type", Value = type.ToString(), DbType = default(int), Direction = default(int) });

            var req = new { DbName = "JEPUN_IMS", SPName = "MW_FileWatch", Timeout = 600, Parameters = ps };

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                var tmp = await client.PostAsync("http://rd11:5123/exec", new StringContent(JsonConvert.SerializeObject(req), Encoding.UTF8, "application/json"));
                if (tmp != null)
                {
                    var jsonResult = await tmp.Content.ReadAsStringAsync();
                    //handle middleware response here
                }
            }
        }

        private async Task<string> MwLogin()
        {
            var req = new { SysName = "JepunIMS" };
            using (var client = new HttpClient())
            {
                var tmp = await client.PostAsync("http://rd11:5123/login", new StringContent(JsonConvert.SerializeObject(req), Encoding.UTF8, "application/json"));
                if (tmp != null)
                {
                    var resp = await tmp.Content.ReadAsStringAsync();
                    JObject rep = JObject.Parse(resp);
                    if (rep["isSuccess"].Value<bool>() && !string.IsNullOrWhiteSpace(rep["data"].Value<string>()))
                        return rep["data"].Value<string>().Trim();
                }
            }
            return null;
        }
    }
}
