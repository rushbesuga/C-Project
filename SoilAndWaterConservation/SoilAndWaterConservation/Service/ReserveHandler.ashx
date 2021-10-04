<%@ WebHandler Language="C#" Class="ReserveHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;

public class ReserveHandler : IHttpHandler, System.Web.SessionState.IReadOnlySessionState
{

    public void ProcessRequest(HttpContext context)
    {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sDate = (context.Request.Form["NowDate"] != null) ? context.Request.Form["NowDate"] : context.Request["NowDate"];
        string sTimeType = (context.Request.Form["TimeType"] != null) ? context.Request.Form["TimeType"] : context.Request["TimeType"];
        string sTownID = (context.Request.Form["TownID"] != null) ? context.Request.Form["TownID"] : context.Request["TownID"];
        string sUserValidation = (context.Request.Form["UserValidation"] != null) ? context.Request.Form["UserValidation"] : context.Request["UserValidation"];
        string sReserveDate = (context.Request.Form["ReserveDate"] != null) ? context.Request.Form["ReserveDate"] : context.Request["ReserveDate"];
        string sReserveTimeType = (context.Request.Form["ReserveTimeType"] != null) ? context.Request.Form["ReserveTimeType"] : context.Request["ReserveTimeType"];
        string sReservePerson = (context.Request.Form["ReservePerson"] != null) ? context.Request.Form["ReservePerson"] : context.Request["ReservePerson"];
        string sReservePhone = (context.Request.Form["ReservePhone"] != null) ? context.Request.Form["ReservePhone"] : context.Request["ReservePhone"];
        string sReserveMail = (context.Request.Form["ReserveMail"] != null) ? context.Request.Form["ReserveMail"] : context.Request["ReserveMail"];
        string sReserveTown = (context.Request.Form["ReserveTown"] != null) ? context.Request.Form["ReserveTown"] : context.Request["ReserveTown"];
        string sReserveItemType = (context.Request.Form["ReserveItemType"] != null) ? context.Request.Form["ReserveItemType"] : context.Request["ReserveItemType"];
        string sReserveContent = (context.Request.Form["ReserveContent"] != null) ? context.Request.Form["ReserveContent"] : context.Request["ReserveContent"];
        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "genCalendarDate":
                string sResultDate = getWeekData(sDate);
                JSONresult = JsonConvert.SerializeObject(sResultDate);
                context.Response.Write(JSONresult);
                break;
            case "GetNormalReserveData":
                string sReturnJson = "";
                string sWhereTimeType = "";
                int iBlockID = getBlockID(sTownID);
                if (sTimeType == "Morning")
                {
                    sWhereTimeType = " where (reserve_date = @sDate and block_id = " + iBlockID + @") and (reserve_time = '09:00-10:00' or reserve_time = '10:00-11:00' or reserve_time = '11:00-12:00') ";
                }
                else
                {
                    sWhereTimeType = " where (reserve_date = @sDate and block_id = " + iBlockID + @") and (reserve_time = '13:00-14:00' or reserve_time = '14:00-15:00' or reserve_time = '15:00-16:00') ";
                }
                sSql = @"select b.* 
                        from tbl_town a
                        left join tbl_reserve_data b on b.reserve_town_id = a.town_id
                        " + sWhereTimeType;
                Dparameter.Add("@sDate", sDate.Replace("/", "-"));
                dt = sf.QueryData(sSql, Dparameter);
                if (dt.Rows.Count >= 1)
                {
                    sReturnJson = @"[{""color"":""red""},{""text"":""已約""}]";
                }
                else
                {
                    sReturnJson = @"[{""color"":""rgb(146, 208, 80)""},{""text"":""可預約""}]";
                }
                context.Response.Write(sReturnJson);
                break;
            case "SaveReserve":
                string sSqlResult = "";
                string sTimeType_ = "";
                string sWhere = "";
                if (sReserveTimeType == "09:00-10:00" || sReserveTimeType == "10:00-11:00" || sReserveTimeType == "11:00-12:00")
                {
                    sTimeType_ = "上午";
                    sWhere = @" and reserve_date = @sReserveDate and a.reserve_time in ('09:00-10:00','10:00-11:00','11:00-12:00')";
                }
                else
                {
                    sTimeType_ = "下午";
                    sWhere = @" and reserve_date = @sReserveDate and a.reserve_time in ('13:00-14:00','14:00-15:00','15:00-16:00')";
                }
                string sBlock_id = Convert.ToString(getBlockID(sReserveTown));
                string sValidation = context.Session["ValidateNum"] as string ?? Guid.NewGuid().ToString();
                if (sUserValidation == sValidation)
                {
                    sSql = @"select *
                            from tbl_reserve_data a 
                            left JOIN tbl_town b on a.reserve_town_id = b.town_id
                            where b.block_id = @Block_id" + sWhere;
                    Dparameter.Add("@Block_id", sBlock_id);
                    Dparameter.Add("@sReserveDate", sReserveDate);
                    dt = sf.QueryData(sSql, Dparameter);
                    if (dt.Rows.Count == 0)
                    {
                        Dparameter = new Dictionary<string, string>();
                        sSql = @"Insert tbl_reserve_data (reserve_date,reserve_time,reserve_person_name,reserve_phone,reserve_person_email,reserve_town_id,reserve_item_type,reserve_content,person_update_time)
                            VALUES (@sReserveDate,@sReserveTimeType,@sReservePerson,@sReservePhone,@sReserveMail,@sReserveTown,@sReserveItemType,@sReserveContent,getdate());";
                        Dparameter.Add("@sReserveDate", sReserveDate);
                        Dparameter.Add("@sReserveTimeType", sReserveTimeType);
                        Dparameter.Add("@sReservePerson", sReservePerson);
                        Dparameter.Add("@sReservePhone", sReservePhone);
                        Dparameter.Add("@sReserveMail", sReserveMail);
                        Dparameter.Add("@sReserveTown", sReserveTown);
                        Dparameter.Add("@sReserveItemType", sReserveItemType);
                        Dparameter.Add("@sReserveContent", sReserveContent);
                        sSqlResult = sf.ModifyData(sSql, Dparameter);
                        if (sSqlResult == "")
                            sSqlResult = "預約成功";
                    }
                    else
                    {
                        sSqlResult = sReserveDate+" "+sTimeType_+"時段已被預約，請重新選擇日期時段";
                    }
                }
                else
                {
                    sSqlResult = "驗證碼錯誤!請重新輸入";
                }
                JSONresult = JsonConvert.SerializeObject(sSqlResult);
                context.Response.Write(JSONresult);
                break;
        }
    }
    public string calDecreaseDate(DateTime Dnow, int DecreaseDays)
    {
        DecreaseDays = DecreaseDays * -1;
        string sResultDate = "";
        for (int i = DecreaseDays; i <= -1; i++)
        {
            if (i != -1)
                sResultDate += Dnow.AddDays(i).ToString("yyyy/MM/dd") + ",";
            else
                sResultDate += Dnow.AddDays(i).ToString("yyyy/MM/dd");
        }
        return sResultDate;
    }
    public string calAddDate(DateTime Dnow, int AddDays)
    {
        string sResultDate = "";
        for (int i = 1; i <= AddDays; i++)
        {
            if (i != AddDays)
                sResultDate += Dnow.AddDays(i).ToString("yyyy/MM/dd") + ",";
            else
                sResultDate += Dnow.AddDays(i).ToString("yyyy/MM/dd");
        }
        return sResultDate;
    }
    public string getWeekData(string sDate)
    {
        string sResultDate = "";
        DateTime Dnow = Convert.ToDateTime(sDate);
        string[] Day = new string[] { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
        string week = Day[Convert.ToInt32(Dnow.DayOfWeek.ToString("d"))].ToString();
        if (week == "星期六")
        {
            Dnow = Dnow.AddDays(2);
            week = "星期一";
        }
        else if (week == "星期日")
        {
            Dnow = Dnow.AddDays(1);
            week = "星期一";
        }
        switch (week)
        {
            case "星期一":
                sResultDate += Dnow.ToString("yyyy/MM/dd") + ",";
                sResultDate += calAddDate(Dnow, 4);
                break;
            case "星期二":
                sResultDate += calDecreaseDate(Dnow, 1) + ",";
                sResultDate += Dnow.ToString("yyyy/MM/dd") + ",";
                sResultDate += calAddDate(Dnow, 3);
                break;
            case "星期三":
                sResultDate += calDecreaseDate(Dnow, 2) + ",";
                sResultDate += Dnow.ToString("yyyy/MM/dd") + ",";
                sResultDate += calAddDate(Dnow, 2);
                break;
            case "星期四":
                sResultDate += calDecreaseDate(Dnow, 3) + ",";
                sResultDate += Dnow.ToString("yyyy/MM/dd") + ",";
                sResultDate += calAddDate(Dnow, 1);
                break;
            case "星期五":
                sResultDate += calDecreaseDate(Dnow, 4) + ",";
                sResultDate += Dnow.ToString("yyyy/MM/dd") + ",";
                break;
        }
        return sResultDate;
    }
    public int getBlockID(string sTownID)
    {
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        string sSql = "select block_id from tbl_town where town_id = @sTownID";
        Dparameter.Add("@sTownID", sTownID);
        dt = sf.QueryData(sSql, Dparameter);
        int iBlockID = Convert.ToInt32(dt.Rows[0][0]);
        return iBlockID;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}