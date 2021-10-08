<%@ WebHandler Language="C#" Class="PlanUserViewHandler" %>

using System;
using System.Web;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using Newtonsoft.Json;
using System.Collections.Generic;

public class PlanUserViewHandler : IHttpHandler, System.Web.SessionState.IReadOnlySessionState
{

    public void ProcessRequest(HttpContext context)
    {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sPlanID = (context.Request.Form["plan_id"] != null) ? context.Request.Form["plan_id"] : context.Request["plan_id"];

        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "getPlanData":
                sSql = @"select plan_case_no,plan_name,plan_audit_date,
                        case when isnull(plan_start_work_date,'') = '' and  isnull(plan_finish_work_date,'') = '' then '待開工' 
		                         when isnull(plan_start_work_date,'') != '' and  isnull(plan_finish_work_date,'') = '' then '施工中' 
		                         when isnull(plan_start_work_date,'') != '' and  isnull(plan_finish_work_date,'') != '' then '已完工' 
                         end as plan_status,
                         case when CONVERT(char(10),CONVERT(DATETIME, plan_start_work_expiration_date, 102),126) = '1900-01-01' then '' else CONVERT(char(10),CONVERT(DATETIME, plan_start_work_expiration_date, 102),126) end as plan_start_work_expiration_date,
                        case when DATEDIFF(day, getdate(), plan_start_work_expiration_date) < 0 then 0 else DATEDIFF(day, getdate(), plan_start_work_expiration_date) end as plan_start_work_expiration_Remaining_days,
                        case when CONVERT(char(10),CONVERT(DATETIME, plan_finish_work_expiration_date, 102),126) = '1900-01-01' then '' else CONVERT(char(10),CONVERT(DATETIME, plan_finish_work_expiration_date, 102),126) end as plan_finish_work_expiration_date,
                        case when DATEDIFF(day, getdate(), plan_finish_work_expiration_date) < 0 then 0 else DATEDIFF(day, getdate(), plan_finish_work_expiration_date) end as plan_finish_work_expiration_Remaining_days
                        from tbl_plan_data_detail 
                        where plan_id=@sPlanID";
                Dparameter.Add("@sPlanID", sPlanID);
                dt = sf.QueryData(sSql, Dparameter);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
        }
    }


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}