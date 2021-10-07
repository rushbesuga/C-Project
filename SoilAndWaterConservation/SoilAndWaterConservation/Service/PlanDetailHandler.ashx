<%@ WebHandler Language="C#" Class="PlanDetailHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;

public class PlanDetailHandler : IHttpHandler, System.Web.SessionState.IReadOnlySessionState {

    public void ProcessRequest (HttpContext context) {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sAction = (context.Request.Form["action"] != null) ? context.Request.Form["action"] : context.Request["action"];
        string sPlanID = (context.Request.Form["plan_id"] != null) ? context.Request.Form["plan_id"] : context.Request["plan_id"];
        string sPlanCaseNo = (context.Request.Form["plan_case_no"] != null) ? context.Request.Form["plan_case_no"] : context.Request["plan_case_no"];
        string sPlanName = (context.Request.Form["plan_name"] != null) ? context.Request.Form["plan_name"] : context.Request["plan_name"];
        string sPlanAuditDate = (context.Request.Form["plan_audit_date"] != null) ? context.Request.Form["plan_audit_date"] : context.Request["plan_audit_date"];
        string sPlanStartWorkExtendDate1st = (context.Request.Form["plan_start_work_entend_1st"] != null) ? context.Request.Form["plan_start_work_entend_1st"] : context.Request["plan_start_work_entend_1st"];
        string sPlanStartWorkExtendDate2nd = (context.Request.Form["plan_start_work_entend_2nd"] != null) ? context.Request.Form["plan_start_work_entend_2nd"] : context.Request["plan_start_work_entend_2nd"];
        string sPlanStartWorkDate = (context.Request.Form["plan_start_work_date"] != null) ? context.Request.Form["plan_start_work_date"] : context.Request["plan_work_date"];
        string sPlanFinishWorkExtendDate1st = (context.Request.Form["plan_finish_work_extend_date_1st"] != null) ? context.Request.Form["plan_finish_work_extend_date_1st"] : context.Request["plan_finish_work_extend_date_1st"];
        string sPlanFinishWorkExtendDate2nd = (context.Request.Form["plan_finish_work_extend_date_2nd"] != null) ? context.Request.Form["plan_finish_work_extend_date_2nd"] : context.Request["plan_finish_work_extend_date_2nd"];
        string sPlanFinishWorkDate = (context.Request.Form["plan_finish_work_date"] != null) ? context.Request.Form["plan_finish_work_date"] : context.Request["plan_finish_work_date"];

        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "SavePlan":
                if (sAction == "add")
                {
                    sSql = @"insert into tbl_plan_data_detail (plan_case_no,plan_name,plan_audit_date,plan_start_work_extend_date_1st,plan_start_work_extend_date_2nd,plan_start_work_date,plan_finish_work_extend_date_1st,plan_finish_work_extend_date_2nd,plan_finish_work_date,update_time)
                            values(@sPlanCaseNo,@sPlanName,@sPlanAuditDate,@sPlanStartWorkExtendDate1st,@sPlanStartWorkExtendDate2nd,@sPlanStartWorkDate,@sPlanFinishWorkExtendDate1st,@sPlanFinishWorkExtendDate2nd,@sPlanFinishWorkDate,getdate())";
                }
                else if (sAction == "edit")
                {
                    sSql = @"update tbl_plan_data_detail set plan_case_no=@sPlanCaseNo,plan_name=@sPlanName,plan_audit_date=@sPlanAuditDate,plan_start_work_extend_date_1st=@sPlanStartWorkExtendDate1st,plan_start_work_extend_date_2nd=@sPlanStartWorkExtendDate2nd,plan_start_work_date=@sPlanStartWorkDate,plan_finish_work_extend_date_1st=@sPlanFinishWorkExtendDate1st,plan_finish_work_extend_date_2nd=@sPlanFinishWorkExtendDate2nd,plan_finish_work_date=@sPlanFinishWorkDate,update_time=getdate()
                            where plan_id = @sPlanID";
                    Dparameter.Add("@sPlanID", sPlanID);
                }
                Dparameter.Add("@sPlanCaseNo", sPlanCaseNo);
                Dparameter.Add("@sPlanName", sPlanName);
                Dparameter.Add("@sPlanAuditDate", sPlanAuditDate);
                Dparameter.Add("@sPlanStartWorkExtendDate1st", sPlanStartWorkExtendDate1st);
                Dparameter.Add("@sPlanStartWorkExtendDate2nd", sPlanStartWorkExtendDate2nd);
                Dparameter.Add("@sPlanStartWorkDate", sPlanStartWorkDate);
                Dparameter.Add("@sPlanFinishWorkExtendDate1st", sPlanFinishWorkExtendDate1st);
                Dparameter.Add("@sPlanFinishWorkExtendDate2nd", sPlanFinishWorkExtendDate2nd);
                Dparameter.Add("@sPlanFinishWorkDate", sPlanFinishWorkDate);
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