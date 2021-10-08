<%@ WebHandler Language="C#" Class="PlanManageHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;

public class PlanManageHandler : IHttpHandler, System.Web.SessionState.IReadOnlySessionState {

    public void ProcessRequest (HttpContext context) {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sKeyword = (context.Request.Form["Keyword"] != null) ? context.Request.Form["Keyword"] : context.Request["Keyword"];
        string sChoosePlanStatustItem = (context.Request.Form["ChoosePlanStatustItem"] != null) ? context.Request.Form["ChoosePlanStatustItem"] : context.Request["ChoosePlanStatustItem"];
        string sDateType = (context.Request.Form["DateType"] != null) ? context.Request.Form["DateType"] : context.Request["DateType"];
        string sStartDate = (context.Request.Form["StartDate"] != null) ? context.Request.Form["StartDate"] : context.Request["StartDate"];
        string sEndDate = (context.Request.Form["EndDate"] != null) ? context.Request.Form["EndDate"] : context.Request["EndDate"];
        string sDays = (context.Request.Form["Days"] != null) ? context.Request.Form["Days"] : context.Request["Days"];
        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "QuickQuery":
                sSql = @"select plan_id,
                            plan_case_no,
                            plan_name,
                            plan_audit_date,
                            plan_status,
                            case when isnull(plan_start_work_extend_date_2nd,'') != '' then plan_start_work_extend_date_2nd 
                            else case when isnull(plan_start_work_extend_date_1st,'') != '' then plan_start_work_extend_date_1st end end as plan_start_work_extend_date,
                            plan_start_work_extend_date_2nd,
                            plan_start_work_expiration_date,
                            plan_start_work_date,
                            case when isnull(plan_finish_work_extend_date_2nd,'') != '' then plan_finish_work_extend_date_2nd 
                            else case when isnull(plan_finish_work_extend_date_1st,'') != '' then plan_finish_work_extend_date_1st end end as plan_finish_work_extend_date,
                            plan_finish_work_expiration_date,
                            plan_finish_work_date,
                            update_user,
                            update_time
                            from tbl_plan_data_detail";
                sSql += @" where ((plan_start_work_expiration_date <= CONVERT(char(10),DATEADD(day, " + sDays + @", CONVERT(char(10), GetDate(),126)),126) and plan_status='已核定') and (plan_start_work_expiration_date >= CONVERT(char(10), GetDate(),126) and plan_status='已核定'))
                            or ((plan_finish_work_expiration_date <= CONVERT(char(10),DATEADD(day, " + sDays + ", CONVERT(char(10), GetDate(),126)),126) and plan_status='施工中') and (plan_finish_work_expiration_date >= CONVERT(char(10), GetDate(),126) and plan_status='施工中'))";
                    
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;

            case "GetPlanDetailData":
                sSql = @"select plan_id,
                            plan_case_no,
                            plan_name,
                            plan_audit_date,
                            plan_status,
                            case when isnull(plan_start_work_extend_date_2nd,'') != '' then plan_start_work_extend_date_2nd 
                            else case when isnull(plan_start_work_extend_date_1st,'') != '' then plan_start_work_extend_date_1st end end as plan_start_work_extend_date,
                            plan_start_work_extend_date_2nd,
                            plan_start_work_expiration_date,
                            plan_start_work_date,
                            case when isnull(plan_finish_work_extend_date_2nd,'') != '' then plan_finish_work_extend_date_2nd 
                            else case when isnull(plan_finish_work_extend_date_1st,'') != '' then plan_finish_work_extend_date_1st end end as plan_finish_work_extend_date,
                            plan_finish_work_expiration_date,
                            plan_finish_work_date,
                            update_user,
                            update_time
                            from tbl_plan_data_detail
                            where (plan_case_no like '%"+sKeyword+@"%' or plan_name like '%"+sKeyword+@"%')
                            ";
                if (!String.IsNullOrEmpty(sChoosePlanStatustItem))
                {
                    string[] aStatus = sChoosePlanStatustItem.Split('|');
                    string sWhereStatus = "";
                    if (sChoosePlanStatustItem != "")
                    {
                        for (int i = 0; i < aStatus.Length; i++)
                        {
                            if (i != aStatus.Length - 1)
                                sWhereStatus += "'" + aStatus[i] + "',";
                            else
                                sWhereStatus += "'" + aStatus[i] + "'";
                        }
                        sSql += " and plan_status in (" + sWhereStatus + ")";
                    }
                }
                if (sStartDate != "" && sEndDate != "")
                {
                    sSql += " and "+sDateType+" >='" + sStartDate + "' and "+sDateType+" <='" + sEndDate + "'";
                }

                sSql += " order by plan_audit_date";
                dt = sf.QueryData(sSql, Dparameter);
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