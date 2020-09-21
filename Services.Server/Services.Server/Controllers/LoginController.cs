using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
namespace Services.Server.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LoginController : ControllerBase
    {
        private readonly AppSettings appSettings;
        private readonly ILogger<LoginController> _logger;

        public LoginController(ILogger<LoginController> logger, IOptions<AppSettings> options)
        {
            _logger = logger;
            appSettings = options.Value;
        }

        public object Post(LoginRequest req)
        {
            try
            {
                if (appSettings == null || string.IsNullOrWhiteSpace(appSettings.Secret) || string.IsNullOrWhiteSpace(appSettings.Clients))
                    return new Response() { IsSuccess = false, FatalError = "err appsettings null" };
                var clients = appSettings.Clients.Split(',');
                if (req == null || string.IsNullOrWhiteSpace(req.SysName) || !clients.Contains(req.SysName))
                    return new Response() { IsSuccess = false, FatalError = "err Sysname"+req.SysName+"" + clients.Contains(req.SysName).ToString()};

                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.UTF8.GetBytes(appSettings.Secret);
                var tokenDescriptor = new SecurityTokenDescriptor()
                {
                    Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name,req.SysName)
                }),
                    Expires = DateTime.UtcNow.AddDays(7),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                };
                var token = tokenHandler.CreateToken(tokenDescriptor);
                return new Response() { IsSuccess = true, Data = tokenHandler.WriteToken(token) };
            }
            catch(Exception ex)
            {
                _logger.LogError(ex, "Login");
                return new Response() { IsSuccess = false, FatalError = ex.Message, StackTrace = ex.StackTrace };
            }
        }
    }
}
