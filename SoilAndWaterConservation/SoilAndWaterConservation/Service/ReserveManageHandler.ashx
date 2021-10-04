<%@ WebHandler Language="C#" Class="ReserveManageHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;
using ClosedXML.Excel;
using System.IO;

public class ReserveManageHandler : IHttpHandler, System.Web.SessionState.IReadOnlySessionState
{

    public void ProcessRequest(HttpContext context)
    {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sDate = (context.Request.Form["NowDate"] != null) ? context.Request.Form["NowDate"] : context.Request["NowDate"];
        string sTimeType = (context.Request.Form["TimeType"] != null) ? context.Request.Form["TimeType"] : context.Request["TimeType"];
        string sReserveTime = (context.Request.Form["ReserveTime"] != null) ? context.Request.Form["ReserveTime"] : context.Request["ReserveTime"];
        string sTownID = (context.Request.Form["TownID"] != null) ? context.Request.Form["TownID"] : context.Request["TownID"];
        string sUserValidation = (context.Request.Form["UserValidation"] != null) ? context.Request.Form["UserValidation"] : context.Request["UserValidation"];
        string sReserveDate = (context.Request.Form["ReserveDate"] != null) ? context.Request.Form["ReserveDate"] : context.Request["ReserveDate"];
        string sReserveTimeType = (context.Request.Form["ReserveTimeType"] != null) ? context.Request.Form["ReserveTimeType"] : context.Request["ReserveTimeType"];
        string sReservePerson = (context.Request.Form["ReservePerson"] != null) ? context.Request.Form["ReservePerson"] : context.Request["ReservePerson"];
        string sReservePhone = (context.Request.Form["ReservePhone"] != null) ? context.Request.Form["ReservePhone"] : context.Request["ReservePhone"];
        string sReserveMail = (context.Request.Form["ReserveMail"] != null) ? context.Request.Form["ReserveMail"] : context.Request["ReserveMail"];
        string sReserveTown = (context.Request.Form["ReserveTown"] != null) ? context.Request.Form["ReserveTown"] : context.Request["ReserveTown"];
        string sReserveTownName = (context.Request.Form["ReserveTownName"] != null) ? context.Request.Form["ReserveTownName"] : context.Request["ReserveTownName"];
        string sReserveItemType = (context.Request.Form["ReserveItemType"] != null) ? context.Request.Form["ReserveItemType"] : context.Request["ReserveItemType"];
        string sReserveContent = (context.Request.Form["ReserveContent"] != null) ? context.Request.Form["ReserveContent"] : context.Request["ReserveContent"];
        string sReserveEngineer = (context.Request.Form["ReserveEngineer"] != null) ? context.Request.Form["ReserveEngineer"] : context.Request["ReserveEngineer"];
        string sReserveEngineerResponse = (context.Request.Form["ReserveEngineerResponse"] != null) ? context.Request.Form["ReserveEngineerResponse"] : context.Request["ReserveEngineerResponse"];
        string sWeekStartDate = (context.Request.Form["WeekStartDate"] != null) ? context.Request.Form["WeekStartDate"] : context.Request["WeekStartDate"];
        string sWeekEndDate = (context.Request.Form["WeekEndDate"] != null) ? context.Request.Form["WeekEndDate"] : context.Request["WeekEndDate"];

        string sSql = "";
        string sBlock_id = "";
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
            case "GetAdminReserveData":
                string sReturnJson = "";
                string sWhereTimeType = "";
                int iBlockID = getBlockID(sTownID);
                sWhereTimeType = " where (reserve_date = @sDate and block_id = " + iBlockID + @") and reserve_time = @sReserveTime ";
                sSql = @"select b.* 
                        from tbl_town a
                        left join tbl_reserve_data b on b.reserve_town_id = a.town_id
                        " + sWhereTimeType;
                Dparameter.Add("@sDate", sDate.Replace("/", "-"));
                Dparameter.Add("@sReserveTime", sReserveTime);
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
            case "GetReserveData":
                sBlock_id = Convert.ToString(getBlockID(sTownID));
                sSql = @"select b.*,a.town_name as reserve_town_name
                        from tbl_town a
                        left join tbl_reserve_data b on b.reserve_town_id = a.town_id
                         where reserve_date = @sReserveDate and reserve_time = @sReserveTime and a.block_id = @sBlock_id";
                Dparameter.Add("@sReserveDate", sReserveDate);
                Dparameter.Add("@sReserveTime", sReserveTime);
                Dparameter.Add("@sBlock_id", sBlock_id);
                dt = sf.QueryData(sSql, Dparameter);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "SaveReserve":
                //同一區不能同時間 不同區可以 管理者模式可以單獨新增單一時段資料
                string sSqlResult = "";
                string sWhere = "";
                sWhere = @" and reserve_date = @sReserveDate and a.reserve_time = @sReserveTimeType";
                sBlock_id = Convert.ToString(getBlockID(sReserveTown));
                string sValidation = context.Session["ValidateNum"] as string ?? Guid.NewGuid().ToString();

                sSql = @"select a.*,b.town_name
                            from tbl_reserve_data a 
                            left JOIN tbl_town b on a.reserve_town_id = b.town_id
                            where b.block_id = @Block_id" + sWhere;
                Dparameter.Add("@Block_id", sBlock_id);
                Dparameter.Add("@sReserveDate", sReserveDate);
                Dparameter.Add("@sReserveTimeType", sReserveTimeType);
                dt = sf.QueryData(sSql, Dparameter);
                if (dt.Rows.Count == 0)
                {
                    Dparameter = new Dictionary<string, string>();
                    sSql = @"Insert tbl_reserve_data (reserve_date,reserve_time,reserve_person_name,reserve_phone,reserve_person_email,reserve_town_id,reserve_item_type,reserve_content,person_update_time,reserve_engineer,reserve_engineer_response,enginner_update_time)
                            VALUES (@sReserveDate,@sReserveTimeType,@sReservePerson,@sReservePhone,@sReserveMail,@sReserveTown,@sReserveItemType,@sReserveContent,getdate(),@sReserveEngineer,@sReserveEngineerResponse,getdate());";
                    Dparameter.Add("@sReserveDate", sReserveDate);
                    Dparameter.Add("@sReserveTimeType", sReserveTimeType);
                    Dparameter.Add("@sReservePerson", sReservePerson);
                    Dparameter.Add("@sReservePhone", sReservePhone);
                    Dparameter.Add("@sReserveMail", sReserveMail);
                    Dparameter.Add("@sReserveTown", sReserveTown);
                    Dparameter.Add("@sReserveItemType", sReserveItemType);
                    Dparameter.Add("@sReserveContent", sReserveContent);
                    Dparameter.Add("@sReserveEngineer", sReserveEngineer);
                    Dparameter.Add("@sReserveEngineerResponse", sReserveEngineerResponse);
                    sSqlResult = sf.ModifyData(sSql, Dparameter);
                    if (sSqlResult == "")
                        sSqlResult = "預約成功";
                }
                else if(dt.Rows.Count == 1 && Convert.ToString(dt.Rows[0]["town_name"]) == sReserveTownName )//果目前唯一一筆資料是當前這筆的話可更新
                {
                    Dparameter = new Dictionary<string, string>();
                    sSql = @"update tbl_reserve_data set reserve_person_name = @sReservePerson,reserve_phone=@sReservePhone,reserve_person_email=@sReserveMail,reserve_item_type=@sReserveItemType,reserve_content=@sReserveContent,reserve_engineer = @sReserveEngineer,reserve_engineer_response = @sReserveEngineerResponse,enginner_update_time = getdate()
                            where reserve_date = @sReserveDate and reserve_time=@sReserveTimeType and reserve_town_id = @sReserveTown";
                    Dparameter.Add("@sReserveDate", sReserveDate);
                    Dparameter.Add("@sReserveTimeType", sReserveTimeType);
                    Dparameter.Add("@sReservePerson", sReservePerson);
                    Dparameter.Add("@sReservePhone", sReservePhone);
                    Dparameter.Add("@sReserveMail", sReserveMail);
                    Dparameter.Add("@sReserveTown", Convert.ToString(getTownID(sReserveTownName)));
                    Dparameter.Add("@sReserveItemType", sReserveItemType);
                    Dparameter.Add("@sReserveContent", sReserveContent);
                    Dparameter.Add("@sReserveEngineer", sReserveEngineer);
                    Dparameter.Add("@sReserveEngineerResponse", sReserveEngineerResponse);
                    sSqlResult = sf.ModifyData(sSql, Dparameter);
                    if (sSqlResult == "")
                        sSqlResult = "資料更新成功";
                }
                else
                {
                    sSqlResult = sReserveDate + " 已被預約，請重新選擇日期時段";
                }
                JSONresult = JsonConvert.SerializeObject(sSqlResult);
                context.Response.Write(JSONresult);
                break;
            case "DelReserve":
                Dparameter = new Dictionary<string, string>();
                sSql = @"delete from tbl_reserve_data 
                        where reserve_date = @sReserveDate and reserve_time=@sReserveTimeType and reserve_town_id = @sReserveTown";
                Dparameter.Add("@sReserveDate", sReserveDate);
                Dparameter.Add("@sReserveTimeType", sReserveTimeType);
                Dparameter.Add("@sReserveTown", Convert.ToString(getTownID(sReserveTownName)));
                sSqlResult = sf.ModifyData(sSql, Dparameter);
                if (sSqlResult == "")
                    sSqlResult = "刪除預約成功";
                JSONresult = JsonConvert.SerializeObject(sSqlResult);
                context.Response.Write(JSONresult);
                break;
            case "ExportReport":
                sSql = @"select block_id from tbl_block";
                dt = sf.QueryData(sSql, null);
                XLWorkbook wb = new XLWorkbook();
                for (int iBlockCount = 1; iBlockCount <= dt.Rows.Count; iBlockCount++)
                {
                    sSql = @"select a.reserve_date as 預約日期,a.reserve_time as 預約時段,a.reserve_person_name as 預約人,a.reserve_phone as 電話,b.town_name as 地點,replace(replace(replace(a.reserve_item_type,'|',' '),'  ',''),' ',',') as 諮詢事項類別,a.reserve_content as 說明,reserve_engineer as 諮詢技師,reserve_engineer_response as 諮詢結果紀錄
                            from tbl_reserve_data a
                            LEFT JOIN tbl_town b on a.reserve_town_id = b.town_id
                            where b.block_id = @iBlockCount and a.reserve_date>=@sWeekStartDate and a.reserve_date<=@sWeekEndDate
                            ORDER BY a.reserve_date,a.reserve_time,a.reserve_town_id";
                    Dparameter = new Dictionary<string, string>();
                    Dparameter.Add("@iBlockCount", Convert.ToString(iBlockCount));
                    Dparameter.Add("@sWeekStartDate", sWeekStartDate);
                    Dparameter.Add("@sWeekEndDate", sWeekEndDate);
                    DataTable dt2 = sf.QueryData(sSql,Dparameter);
                    IXLWorksheet workSheet = wb.Worksheets.Add(dt2,"第"+iBlockCount+"區");
                    workSheet.Columns().AdjustToContents();
                }
                MemoryStream stream = GetStream(wb);
                string sFileName = sWeekStartDate + "-" + sWeekEndDate + "-預約明細表.xlsx";
                context.Response.Clear();
                context.Response.Buffer = true;
                context.Response.AddHeader("content-disposition", "attachment; filename=" + sFileName);
                context.Response.ContentType = "application/vnd.ms-excel";
                context.Response.BinaryWrite(stream.ToArray());
                context.Response.End();
                break;
        }
    }
    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
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
    public int getTownID(string sTownName)
    {
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        string sSql = "select town_id from tbl_town where town_name = @sTownName";
        Dparameter.Add("@sTownName", sTownName);
        dt = sf.QueryData(sSql, Dparameter);
        int iTownID = Convert.ToInt32(dt.Rows[0][0]);
        return iTownID;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}