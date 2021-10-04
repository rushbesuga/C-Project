<%@ WebHandler Language="C#" Class="QAandMessageBoardHandler" %>

using System;
using System.Web;

using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;
public class QAandMessageBoardHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sFilter = (context.Request.Form["Filter"] != null) ? context.Request.Form["Filter"] : context.Request["Filter"];
        string sid = (context.Request.Form["id"] != null) ? context.Request.Form["id"] : context.Request["id"];
        string srecoveryname = (context.Request.Form["recoveryname"]!=null)?context.Request.Form["recoveryname"] : context.Request["recoveryname"];
        string srecoverytitle = (context.Request.Form["recoverytitle"]!=null)?context.Request.Form["recoverytitle"] : context.Request["recoverytitle"];
        string srecoverycontent = (context.Request.Form["recoverycontent"]!=null)?context.Request.Form["recoverycontent"] : context.Request["recoverycontent"];
        string sonpublic = (context.Request.Form["public"]!=null)?context.Request.Form["public"] : context.Request["public"];
        string sprocflage = (context.Request.Form["procflage"]!=null)?context.Request.Form["procflage"] : context.Request["procflage"];
        string sdate = (context.Request.Form["date"]!=null)?context.Request.Form["date"] : context.Request["date"];
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string sSql = "";
        string JSONresult = "";
        switch (sType)
        {
            case "tbl_qaandmessage_data":
                sSql = @"select * from tbl_qaandmessage_data order by row_id";
                JSONresult = "";
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "tbl_qaandmessage_data_Filter":
                sSql = @"select * from tbl_qaandmessage_data where row_content like '%" + sFilter + "%'  order by row_id";
                JSONresult = "";
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "tbl_qaandmessage_maintenance_data":
                sSql = @"select row_id,row_createtime,row_title,row_name, case when ISNULL(row_recovery_public,'1') ='0' then '公開' else '不公開' end  as row_recovery_punlic
, case when   ISNULL(row_recovery_procflag,'1') ='1' then '未處理' else '已處理' end as row_recovery_procflag
                from tbl_qaandmessage_data order by row_id";
                //,' <input type=""button"" style="" value=""編輯"" onclick=""location.href=''RecoveryQA.aspx?id='+cast(row_id as VARCHAR)+'""' as click

                JSONresult = "";
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "tbl_qaandmessage_maintenance_data_filter":
                sSql = @"select row_id,row_createtime,row_title,row_name, case when ISNULL(row_recovery_public,'1') ='0' then '公開' else '不公開' end  as row_recovery_punlic
, case when   ISNULL(row_recovery_procflag,'1') ='1' then '未處理' else '已處理' end as row_recovery_procflag
                from tbl_qaandmessage_data ";
                if (!string.IsNullOrEmpty(sFilter))
                {
                    sSql += @"
                where  row_content  like '%" + sFilter + "%' and  cast(row_createtime as date)='" + sdate + "'order by row_id";
                }
                else
                {
                    sSql += @"where cast(row_createtime as date)='" + sdate + "' order by row_id";
                }

                JSONresult = "";
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "tbl_qaandmessage_maintenance_Details":
                sSql = @"select row_id,row_title,row_name,row_gender,row_phone,row_email,row_content,
                         row_createtime,row_recovery_time,row_recovery_name,row_recovery_title,row_recovery_content,isnull(row_recovery_public,'1') as row_recovery_public,isnull(row_recovery_procflag,'0') as row_recovery_procflag
                         from tbl_qaandmessage_data where row_id=" + sid;
                JSONresult = "";
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "save_recovery_data":
                sSql=@"update tbl_qaandmessage_data 
                          set row_recovery_time =getdate(), row_recovery_name=@srecoveryname, row_recovery_title=@srecoverytitle,
                              row_recovery_content=@srecoverycontent,row_recovery_public=@sonpublic , row_recovery_procflag=@sprocflage
                            where row_id=@id
                        ";
                Dictionary<string,string> dbparams = new Dictionary<string, string>();
                dbparams.Add("srecoveryname",srecoveryname);
                dbparams.Add("srecoverytitle",srecoverytitle);
                dbparams.Add("srecoverycontent",srecoverycontent);
                dbparams.Add("sonpublic",sonpublic);
                dbparams.Add("sprocflage",sprocflage);
                dbparams.Add("id",sid);
                sf.ModifyData(sSql,dbparams);
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