using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Text.Json;
using System.Data;

namespace Services.Server.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class QueryController : ControllerBase
    {
        private readonly ILogger<QueryController> _logger;
        private readonly IConfiguration _config;

        public QueryController(ILogger<QueryController> logger, IConfiguration config)
        {
            _logger = logger;
            _config = config;
        }
        [HttpPost]
        public async Task<object> Post(QueryRequest req)
        {
            try
            {
                var arg = new DynamicParameters();
                foreach (SpParam sp in req.Parameters)
                {
                    var type = DbType.String;
                    Enum.TryParse(sp.DbType.ToString(), out type);
                    var direction = default(ParameterDirection);
                    Enum.TryParse(sp.Direction.ToString(), out direction);
                    arg.Add(sp.Name, JsonElementToObject((JsonElement)sp.Value), type, direction);
                }
                var data = new List<IEnumerable<dynamic>>();
                _logger.LogInformation(req.DbName);
                using (var conn = DbHelper.Conn(_config, req.DbName))
                {
                    if (req.Timeout == 0)
                        req.Timeout = 600;
                    await conn.OpenAsync();
                    using (var reader = await conn.QueryMultipleAsync(req.SPName, arg, null, req.Timeout, CommandType.StoredProcedure))
                    {
                        try
                        {
                            while (!reader.IsConsumed)
                                data.Add(await reader.ReadAsync());
                        }
                        catch (Exception ex)
                        {
                            if (ex.Message.Trim() != "No columns were selected")
                                throw;
                        }
                    }
                }
                var oParams = new List<SpParam>();
                foreach (var p in req.Parameters)
                {
                    var direction = default(ParameterDirection);
                    Enum.TryParse(p.Direction.ToString(),out direction);

                    switch (direction)
                    {
                        case ParameterDirection.Output:
                        case ParameterDirection.InputOutput:
                            oParams.Add(new SpParam() { Name = p.Name, Value = arg.Get<dynamic>(p.Name), DbType = p.DbType, Direction = (int)direction });
                            break;
                    }
                }
                bool isSuccess = true;
                var oSpSuccess = oParams.FirstOrDefault(op => op.Name.Trim().ToUpper() == "ISSUCCESS");
                if (oSpSuccess != null && oSpSuccess.Value != null)
                    bool.TryParse(oSpSuccess.Value.ToString().Trim(), out isSuccess);

                return new Response()
                {
                    IsSuccess = isSuccess,
                    OutputParams = oParams.ToArray(),
                    Data = data
                };
            }
            
            catch (Exception ex)
            {
                _logger.LogError(ex,"Query");
                return new Response() { IsSuccess = false, FatalError = ex.Message, StackTrace = ex.StackTrace };
            }
        }
        object JsonElementToObject(JsonElement el)
        {
            var options = new JsonSerializerOptions();
            options.Converters.Add(new ObjectConverter());
            return JsonSerializer.Deserialize<dynamic>(el.GetRawText(), options);
        }
    }
}
