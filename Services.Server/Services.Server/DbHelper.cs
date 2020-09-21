using System.Data.Common;
using Microsoft.Extensions.Configuration;
namespace Services.Server
{
    public class DbHelper
    {
        const string DefaultProvider = "System.Data.SqlClient";

        public static DbConnection Conn(IConfiguration config, string name)
        {
            var factory = DbProviderFactories.GetFactory(DefaultProvider);
            var conn = factory.CreateConnection();
            conn.ConnectionString = config.GetConnectionString(name);
            return conn;
        }
    }
}
