using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// SqlFactory 的摘要描述
/// </summary>
public class SqlFactory
{
    string sConnection = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["MSSQL"].ConnectionString;

    public void InsertLoginLog(string sUserID)
    {
        string sSql = @"INSERT tbl_login_record (user_id)
             VALUES (@user_id);";
        Dictionary<string, string> DParameter = new Dictionary<string, string>();
        DParameter.Add("@user_id", sUserID);
        ModifyData(sSql, DParameter);
    }

    public DataTable QueryData(string SqlComment,Dictionary<string,string> Parameter)
    {
        SqlConnection conn = new SqlConnection(sConnection);
        SqlCommand cmmd = new SqlCommand(SqlComment, conn);
        conn.Open();
        if (Parameter != null && Parameter.Count > 0 )
        {
            foreach (KeyValuePair<string, string> kvp in Parameter)
            {
                cmmd.Parameters.AddWithValue(kvp.Key, kvp.Value);
            }
        }
        SqlDataReader dr = cmmd.ExecuteReader();
        DataTable dt = new DataTable();
        dt.Load(dr);
        dr.Close();
        cmmd.Dispose();
        conn.Close();
        return dt;
    }

    public string ModifyData(string SqlComment, Dictionary<string, string> Parameter)
    {
        SqlConnection conn = new SqlConnection(sConnection);
        SqlCommand cmmd = new SqlCommand(SqlComment, conn);
        conn.Open();
        if (Parameter.Count > 0)
        {
            foreach (KeyValuePair<string, string> kvp in Parameter)
            {
                cmmd.Parameters.AddWithValue(kvp.Key, kvp.Value);
            }
        }
        var firstColumn = cmmd.ExecuteScalar();
        string result = "";
        if (firstColumn != null)
        {
            result = firstColumn.ToString();
        }
        cmmd.Dispose();
        conn.Close();
        return result;
    }
}