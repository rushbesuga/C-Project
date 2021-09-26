<%@ WebHandler Language="C#" Class="PaymentCalculateHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;

public class PaymentCalculateHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sMarginTypeId = (context.Request.Form["margin_type_id"] != null) ? context.Request.Form["margin_type_id"] : context.Request["margin_type_id"];
        string sDevTotalAmount = (context.Request.Form["dev_total_amount"] != null) ? context.Request.Form["dev_total_amount"] : context.Request["dev_total_amount"];
        string sAuditOriginalPrice = (context.Request.Form["AuditOriginalPrice"] != null) ? context.Request.Form["AuditOriginalPrice"] : context.Request["AuditOriginalPrice"];
        string sMakeOriginalPrice = (context.Request.Form["MakeOriginalPrice"] != null) ? context.Request.Form["MakeOriginalPrice"] : context.Request["MakeOriginalPrice"];
        string sChangeMakePrice = (context.Request.Form["ChangeMakePrice"] != null) ? context.Request.Form["ChangeMakePrice"] : context.Request["ChangeMakePrice"];
        string sArea = (context.Request.Form["Area"] != null) ? context.Request.Form["Area"] : context.Request["Area"];
        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "GetDevOption":
                sSql = @"select * from tbl_margin_data order by margin_type_id";
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;

            case "GetDevCalPrice":
                sSql = @"select CAST(" + sDevTotalAmount + @" * rate AS bigint) as margin_price from tbl_margin_data where margin_type_id = @margin_type_id";
                Dparameter.Add("@margin_type_id", sMarginTypeId);
                dt = sf.QueryData(sSql, Dparameter);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;

            case "GetPlanChangeCalPrice":
                long iAuditOriginalPrice = Convert.ToInt64(sAuditOriginalPrice);
                long iMakeOriginalPrice = Convert.ToInt64(sMakeOriginalPrice);
                long iChangeMakePrice = Convert.ToInt64(sChangeMakePrice);
                long iFinalPrice = 0;
                long iDiffPrice = Math.Abs(iMakeOriginalPrice - iChangeMakePrice);
                iFinalPrice = ((iAuditOriginalPrice * iDiffPrice) / iMakeOriginalPrice) / 1000;
                iFinalPrice = iFinalPrice * 1000;
                if (iFinalPrice < 10000)
                    iFinalPrice = 10000;
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(@"[{""change_audit_price"":" + iFinalPrice + "}]");
                break;

            case "GetPlanAuditCalPrice":
                Int64 iTotalPrice = 0;
                if (Convert.ToDecimal(sArea) < 1)
                {
                    sSql = @"select result from tbl_plan_data where " + sArea + " >= value_lower and " + sArea + " < value_higher";
                    dt = sf.QueryData(sSql, null);
                    iTotalPrice = Convert.ToInt64(dt.Rows[0][0]);
                }
                if (Convert.ToDecimal(sArea) == 1)
                {
                    sSql = @"select result from tbl_plan_data where " + sArea + " >= value_lower and " + sArea + " <= value_higher";
                    dt = sf.QueryData(sSql, null);
                    iTotalPrice = Convert.ToInt64(dt.Rows[0][0]);
                }
                else if (Convert.ToDecimal(sArea) > 1 && Convert.ToDecimal(sArea)<10 )
                {
                    Int64 iDiffArea = Convert.ToInt64(Math.Ceiling(Convert.ToDecimal(sArea)-1));//計算面積多出多少無條件進位
                    sSql = @"select result from tbl_plan_data where " + sArea + " > value_lower and " + sArea + " < value_higher";
                    dt = sf.QueryData(sSql, null);
                    long iPerAreaPrice = Convert.ToInt64(dt.Rows[0][0]);
                    iTotalPrice = iPerAreaPrice * iDiffArea;
                }
                else if (Convert.ToDecimal(sArea) >= 10)
                {
                    Int64 iDiffArea = Convert.ToInt64(Math.Ceiling(Convert.ToDecimal(sArea)-10));//計算面積多出多少無條件進位
                    sSql = @"select result from tbl_plan_data where " + sArea + " >= value_lower and " + sArea + " < value_higher";
                    dt = sf.QueryData(sSql, null);
                    long iPerAreaPrice = Convert.ToInt64(dt.Rows[0][0]);
                    iTotalPrice = iPerAreaPrice * iDiffArea;
                }

                if (Convert.ToDecimal(sArea) > 1) //如果超出1公頃 抓超過1公頃前的金額
                {
                    sSql = @"select result from tbl_plan_data where 0.9 >= value_lower and 0.9 < value_higher";
                    dt = sf.QueryData(sSql, null);
                    iTotalPrice = iTotalPrice + Convert.ToInt64(dt.Rows[0][0]);
                }
                if (Convert.ToDecimal(sArea) >= 10) //如果10公頃以上 抓超過1~10公頃前的金額
                {
                    sSql = @"select result from tbl_plan_data where 9 >= value_lower and 9 < value_higher";//抓出超過1公頃時每1公頃加收費用
                    dt = sf.QueryData(sSql, null);
                    iTotalPrice = iTotalPrice + (Convert.ToInt64(dt.Rows[0][0])*9);
                }
                context.Response.Write(@"[{""plan_audit_cal_price"":" + iTotalPrice + "}]");
                break;

            case "GetPlanningAuditCalPrice":
                Int64 iPlanningTotalPrice = 0;
                if (Convert.ToDecimal(sArea) < 2)
                {
                    sSql = @"select result from tbl_planning_data where " + sArea + " >= value_lower and " + sArea + " < value_higher";
                    dt = sf.QueryData(sSql, null);
                    iPlanningTotalPrice = Convert.ToInt64(dt.Rows[0][0]);
                }
                else if (Convert.ToDecimal(sArea) >= 2 && Convert.ToDecimal(sArea)<=10 )
                {
                    Int64 iDiffArea = Convert.ToInt64(Math.Ceiling(Convert.ToDecimal(sArea)-2));//計算面積多出多少無條件進位
                    if (iDiffArea == 0)
                        iDiffArea = 1;
                    sSql = @"select result from tbl_planning_data where " + sArea + " >= value_lower and " + sArea + " <= value_higher";
                    dt = sf.QueryData(sSql, null);
                    long iPerAreaPrice = Convert.ToInt64(dt.Rows[0][0]);
                    iPlanningTotalPrice = iPerAreaPrice * iDiffArea;
                }
                else if (Convert.ToDecimal(sArea) > 10)
                {
                    Int64 iDiffArea = Convert.ToInt64(Math.Ceiling(Convert.ToDecimal(sArea)-10));//計算面積多出多少無條件進位
                    sSql = @"select result from tbl_planning_data where " + sArea + " > value_lower and " + sArea + " < value_higher";
                    dt = sf.QueryData(sSql, null);
                    long iPerAreaPrice = Convert.ToInt64(dt.Rows[0][0]);
                    iPlanningTotalPrice = iPerAreaPrice * iDiffArea;
                }

                if (Convert.ToDecimal(sArea) >= 2) //如果超出2公頃 抓超過2公頃前的金額
                {
                    sSql = @"select result from tbl_planning_data where value_higher < 2";
                    dt = sf.QueryData(sSql, null);
                    iPlanningTotalPrice = iPlanningTotalPrice + Convert.ToInt64(dt.Rows[0][0]);
                }
                if (Convert.ToDecimal(sArea) > 10) //如果10公頃以上 抓超過2~10公頃前的金額
                {
                    sSql = @"select result from tbl_planning_data where 2 >= value_lower and 9 < value_higher";//抓出超過1公頃時每1公頃加收費用
                    dt = sf.QueryData(sSql, null);
                    iPlanningTotalPrice = iPlanningTotalPrice + (Convert.ToInt64(dt.Rows[0][0])*8);
                }
                context.Response.Write(@"[{""planning_audit_cal_price"":" + iPlanningTotalPrice + "}]");
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