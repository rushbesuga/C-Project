<%@ WebHandler Language="C#" Class="CommonHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;

public class CommonHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sDate = (context.Request.Form["NowDate"] != null) ? context.Request.Form["NowDate"] : context.Request["NowDate"];
        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        switch (sType)
        {
            case "GetTownoption":
                sSql = @"select town_id,town_name
                            from tbl_town";
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}