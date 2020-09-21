using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Services.Server
{
    public class AppSettings
    {
        public string Secret { get; set; }
        public string Clients { get; set; }
    }
    public class LoginRequest
    {
        [Required]
        public string SysName { get; set; }
    }
    public class Response
    {
        [Required]
        public bool IsSuccess { get; set; }
        public IEnumerable<SpParam> OutputParams { get; set; }
        public object Data { get; set; }
        public string FatalError { get; set; }
        public string StackTrace { get; set; }
    }
    public class SpParam
    {
        public string Name { get; set; }
        public int DbType { get; set; }
        public object Value { get; set; }
        public int Direction { get; set; }
    }
    public class QueryRequest
    {
        [Required]
        public string DbName { get; set; }
        [Required]
        public string SPName { get; set; }
        public int Timeout { get; set; }
        public IEnumerable<SpParam> Parameters { get; set; }
    }
}
