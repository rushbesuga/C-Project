using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Stockstrategy.Model;
using System.Data;
using System.Collections;

namespace Stockstrategy
{
    internal class DBStock
    {
        string connectionString = "Server=ALLEN\\SQLEXPRESS;Database=master;User Id=sa;Password=1qaz2wsx;";

        public DataTable GetStockInfos()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataTable dataTable = new DataTable();
                try
                {

                    string  sqlQuery = " exec Get_Stock_Month ";

                    connection.Open();
                    using (SqlDataAdapter adapter = new SqlDataAdapter(sqlQuery, connection))
                    {
                        adapter.Fill(dataTable);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                }
                return dataTable;
            }
        }
        public DataTable GetStockInfos(string stock_id)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                DataTable dataTable = new DataTable();
                try
                {

                    string sqlQuery = " exec Get_Stock_Month_K  "+ stock_id;

                    connection.Open();
                    using (SqlDataAdapter adapter = new SqlDataAdapter(sqlQuery, connection))
                    {
                        adapter.Fill(dataTable);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                }
                return dataTable;
            }
        }
    }
}
