<%@ WebHandler Language="C#" Class="PlanQrcodeHandler" %>

using System;
using System.Web;
using System.Data;
using ZXing.Common;
using ZXing.QrCode;
using ZXing;
using System.Drawing;
using System.Drawing.Imaging;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using Newtonsoft.Json;
using System.Collections.Generic;

public class PlanQrcodeHandler : IHttpHandler, System.Web.SessionState.IReadOnlySessionState
{

    public void ProcessRequest(HttpContext context)
    {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sPlanID = (context.Request.Form["plan_id"] != null) ? context.Request.Form["plan_id"] : context.Request["plan_id"];
        string sWebUrl = (context.Request.Form["WebUrl"] != null) ? context.Request.Form["WebUrl"] : context.Request["WebUrl"];

        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "getPlanData":
                sSql = @"select plan_case_no,plan_name,plan_audit_date from tbl_plan_data_detail where plan_id=@sPlanID";
                Dparameter.Add("@sPlanID", sPlanID);
                dt = sf.QueryData(sSql, Dparameter);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "getBarcode":
                string sQRCODE_URL = sWebUrl+ "?plan_id=" + sPlanID;
                Bitmap myBitmap = genQRCode(sQRCODE_URL);
                System.IO.MemoryStream ms = new MemoryStream();
                myBitmap.Save(ms, ImageFormat.Png);
                byte[] byteImage = ms.ToArray();
                var SigBase64= Convert.ToBase64String(byteImage);
                JSONresult = JsonConvert.SerializeObject(SigBase64);
                context.Response.Write(JSONresult);
                break;
        }
    }

    private Bitmap genQRCode(string url)
    {
        BarcodeWriter bw = new BarcodeWriter();
        bw.Format = BarcodeFormat.QR_CODE;
        bw.Options.Width = 400;
        bw.Options.Height = 400;
        Bitmap bitmap = bw.Write(url);
        return bitmap;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}