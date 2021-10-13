<%@ WebHandler Language="C#" Class="Default_AdminHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;

public class Default_AdminHandler : IHttpHandler, System.Web.SessionState.IReadOnlySessionState
{

    public void ProcessRequest(HttpContext context)
    {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "GetDataCount":
                sSql = @"select 
                        (select count(*)
                        from tbl_plan_data_detail 
                        where isnull(plan_audit_date,'') != '') as '已核可',
                        (select count(*)
                        from tbl_plan_data_detail 
                        where plan_status = '施工中') as '施工中',
                        (select count(*)
                        from tbl_plan_data_detail 
                        where plan_status = '已完工') as '已完工',
                        (select count(*)
                        from tbl_plan_data_detail 
                        where isnull(plan_start_work_date,'') = '' and isnull(plan_finish_work_date,'') = '') as '未開工',
                        (select count(*)
                        from tbl_plan_data_detail 
                        where isnull(plan_start_work_date,'') != '' and isnull(plan_finish_work_date,'') = '') as '未完工',
                        (select count(*)
                        from tbl_reserve_data 
                        where isnull(reserve_engineer,'') != '') as '諮詢已處置',
                        (select count(*)
                        from tbl_reserve_data 
                        where isnull(reserve_engineer,'') = '') as '諮詢未處置',
                        (select count(*)
                        from tbl_qaandmessage_data 
                        where isnull(row_recovery_procflag,'1') = '0') as '問答已處置',
                        (select count(*)
                        from tbl_qaandmessage_data 
                        where isnull(row_recovery_procflag,'1') = '1') as '問答未處置',
                        (select count(plan_upload_id)
                        from tbl_plan_upload_data ) as '完成上傳數'";
                dt = sf.QueryData(sSql, null);
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