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
        string sPlanStatus = (context.Request.Form["plan_status"] != null) ? context.Request.Form["plan_status"] : context.Request["plan_status"];
        string sPlanStartWorkExtendDate1st = (context.Request.Form["plan_start_work_entend_date_1st"] != null) ? context.Request.Form["plan_start_work_entend_date_1st"] : context.Request["plan_start_work_entend_date_1st"];
        string sPlanStartWorkExtendDate2nd = (context.Request.Form["plan_start_work_entend_date_2nd"] != null) ? context.Request.Form["plan_start_work_entend_date_2nd"] : context.Request["plan_start_work_entend_date_2nd"];
        string sPlanStartWorkExpirationDate = (context.Request.Form["plan_start_work_expiration_date"] != null) ? context.Request.Form["plan_start_work_expiration_date"] : context.Request["plan_start_work_expiration_date"];
        string sPlanStartWorkDate = (context.Request.Form["plan_start_work_date"] != null) ? context.Request.Form["plan_start_work_date"] : context.Request["plan_work_date"];
        string sPlanFinishWorkExtendDate1st = (context.Request.Form["plan_finish_work_extend_date_1st"] != null) ? context.Request.Form["plan_finish_work_extend_date_1st"] : context.Request["plan_finish_work_extend_date_1st"];
        string sPlanFinishWorkExtendDate2nd = (context.Request.Form["plan_finish_work_extend_date_2nd"] != null) ? context.Request.Form["plan_finish_work_extend_date_2nd"] : context.Request["plan_finish_work_extend_date_2nd"];
        string sPlanFinishWorkExpirationDate = (context.Request.Form["plan_finish_work_expiration_date"] != null) ? context.Request.Form["plan_finish_work_expiration_date"] : context.Request["plan_finish_work_expiration_date"];
        string sPlanFinishWorkDate = (context.Request.Form["plan_finish_work_date"] != null) ? context.Request.Form["plan_finish_work_date"] : context.Request["plan_finish_work_date"];
        string sBaseDate = (context.Request.Form["base_date"] != null) ? context.Request.Form["base_date"] : context.Request["base_date"];
        string sAddDays = (context.Request.Form["add_days"] != null) ? context.Request.Form["add_days"] : context.Request["add_days"];
        string sAddMonth = (context.Request.Form["add_month"] != null) ? context.Request.Form["add_month"] : context.Request["add_month"];
        string sExpirationDate = (context.Request.Form["expiration_date"] != null) ? context.Request.Form["expiration_date"] : context.Request["expiration_date"];
        string sHowDays = (context.Request.Form["how_days"] != null) ? context.Request.Form["how_days"] : context.Request["how_days"];
        string sPlanUndertaker = (context.Request.Form["plan_undertaker"] != null) ? context.Request.Form["plan_undertaker"] : context.Request["plan_undertaker"];

        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "LoadData":
                sSql = @"select * from tbl_plan_data_detail where plan_id=@sPlanID";
                Dparameter.Add("@sPlanID", sPlanID);
                dt = sf.QueryData(sSql, Dparameter);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "CalStartWorkExpirationDate":
                sBaseDate = (Convert.ToDateTime(sBaseDate).AddYears(1)).ToString("yyyy-MM-dd");
                JSONresult = JsonConvert.SerializeObject(sBaseDate);
                context.Response.Write(JSONresult);
                break;
            case "CalDaysDate":
                int iAddDays = Convert.ToInt32(sAddDays);
                sBaseDate = (Convert.ToDateTime(sBaseDate).AddDays(iAddDays)).ToString("yyyy-MM-dd");
                JSONresult = JsonConvert.SerializeObject(sBaseDate);
                context.Response.Write(JSONresult);
                break;
            case "CalAddMonth":
                int iAddMonth = Convert.ToInt32(sAddMonth);
                sBaseDate = (Convert.ToDateTime(sBaseDate).AddMonths(iAddMonth)).ToString("yyyy-MM-dd");
                JSONresult = JsonConvert.SerializeObject(sBaseDate);
                context.Response.Write(JSONresult);
                break;
            case "CheckCanExtend":
                string sResult = "false";
                DateTime dt1 = Convert.ToDateTime(sExpirationDate);
                DateTime dt2 = Convert.ToDateTime(DateTime.Now);
                TimeSpan ts = dt1 - dt2;
                if (ts.Days <= Convert.ToInt32(sHowDays))
                    sResult = "true";
                JSONresult = JsonConvert.SerializeObject(sResult);
                context.Response.Write(JSONresult);
                break;
            case "SavePlan":
                if (sAction == "add")
                {
                    sSql = @"insert into tbl_plan_data_detail (plan_case_no,plan_name,plan_audit_date,plan_status,plan_start_work_extend_date_1st,plan_start_work_extend_date_2nd,plan_start_work_expiration_date,plan_start_work_date,plan_finish_work_extend_date_1st,plan_finish_work_extend_date_2nd,plan_finish_work_expiration_date,plan_finish_work_date,update_time,plan_undertaker)
                            values(@sPlanCaseNo,@sPlanName,@sPlanAuditDate,@sPlanStatus,@sPlanStartWorkExtendDate1st,@sPlanStartWorkExtendDate2nd,@sPlanStartWorkExpirationDate,@sPlanStartWorkDate,@sPlanFinishWorkExtendDate1st,@sPlanFinishWorkExtendDate2nd,@sPlanFinishWorkExpirationDate,@sPlanFinishWorkDate,getdate(),@sPlanUndertaker)";
                }
                else if (sAction == "edit")
                {
                    sSql = @"update tbl_plan_data_detail set plan_case_no=@sPlanCaseNo,plan_name=@sPlanName,plan_audit_date=@sPlanAuditDate,plan_status=@sPlanStatus,plan_start_work_extend_date_1st=@sPlanStartWorkExtendDate1st,plan_start_work_extend_date_2nd=@sPlanStartWorkExtendDate2nd,plan_start_work_date=@sPlanStartWorkDate,plan_start_work_expiration_date=@sPlanStartWorkExpirationDate,plan_finish_work_extend_date_1st=@sPlanFinishWorkExtendDate1st,plan_finish_work_extend_date_2nd=@sPlanFinishWorkExtendDate2nd,plan_finish_work_expiration_date=@sPlanFinishWorkExpirationDate,plan_finish_work_date=@sPlanFinishWorkDate,update_time=getdate(),plan_undertaker = @sPlanUndertaker
                            where plan_id = @sPlanID";
                    Dparameter.Add("@sPlanID", sPlanID);
                }
                Dparameter.Add("@sPlanCaseNo", sPlanCaseNo);
                Dparameter.Add("@sPlanName", sPlanName);
                Dparameter.Add("@sPlanAuditDate", sPlanAuditDate);
                Dparameter.Add("@sPlanStatus", sPlanStatus);
                Dparameter.Add("@sPlanStartWorkExtendDate1st", sPlanStartWorkExtendDate1st);
                Dparameter.Add("@sPlanStartWorkExtendDate2nd", sPlanStartWorkExtendDate2nd);
                Dparameter.Add("@sPlanStartWorkExpirationDate", sPlanStartWorkExpirationDate);
                Dparameter.Add("@sPlanStartWorkDate", sPlanStartWorkDate);
                Dparameter.Add("@sPlanFinishWorkExtendDate1st", sPlanFinishWorkExtendDate1st);
                Dparameter.Add("@sPlanFinishWorkExtendDate2nd", sPlanFinishWorkExtendDate2nd);
                Dparameter.Add("@sPlanFinishWorkExpirationDate", sPlanFinishWorkExpirationDate);
                Dparameter.Add("@sPlanFinishWorkDate", sPlanFinishWorkDate);
                Dparameter.Add("@sPlanUndertaker", sPlanUndertaker);
                dt = sf.QueryData(sSql, Dparameter);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "DelPlanData":
                sSql = @"delete from tbl_plan_data_detail where plan_id = @sPlanID";
                Dparameter.Add("@sPlanID", sPlanID);
                sResult = sf.ModifyData(sSql, Dparameter);
                JSONresult = JsonConvert.SerializeObject(sResult);
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