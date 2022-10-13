<%@ WebHandler Language="C#" Class="PlanUpload" %>

using System;
using System.IO;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;
using ClosedXML.Excel;
using System.Data.SqlClient;
public class PlanUpload : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string sType = (context.Request.Form["Type"] != null) ? context.Request.Form["Type"] : context.Request["Type"];
        string sFilter = (context.Request.Form["Filter"] != null) ? context.Request.Form["Filter"] : context.Request["Filter"];
        string sid = (context.Request.Form["id"] != null) ? context.Request.Form["id"] : context.Request["id"];
        string sstartdate = (context.Request.Form["startdate"] != null) ? context.Request.Form["startdate"] : context.Request["startdate"];
        string senddate = (context.Request.Form["enddate"] != null) ? context.Request.Form["enddate"] : context.Request["enddate"];
        string sname = (context.Request.Form["name"] != null) ? context.Request.Form["name"] : context.Request["name"];
        string sremark = (context.Request.Form["remark"] != null) ? context.Request.Form["remark"] : context.Request["remark"];
        string sfile1name = (context.Request.Form["file1name"] != null) ? context.Request.Form["file1name"] : context.Request["file1name"];
        string sfile1type = (context.Request.Form["file1type"] != null) ? context.Request.Form["file1type"] : context.Request["file1type"];
        string sfile2name = (context.Request.Form["file2name"] != null) ? context.Request.Form["file2name"] : context.Request["file2name"];
        string sfile2type = (context.Request.Form["file2type"] != null) ? context.Request.Form["file2type"] : context.Request["file2type"];
        string sfile3name = (context.Request.Form["file3name"] != null) ? context.Request.Form["file3name"] : context.Request["file3name"];
        string sfile3type = (context.Request.Form["file3type"] != null) ? context.Request.Form["file3type"] : context.Request["file3type"];
        string fileid = (context.Request.Form["file_id"] != null) ? context.Request.Form["file_id"] : context.Request["file_id"];
        byte[] bytes = null;
        var httpPostedFile = context.Request.Files["UploadedFile"];
        if (httpPostedFile != null)
        {
            using (var memoryStream = new MemoryStream())
            {
                httpPostedFile.InputStream.CopyTo(memoryStream);
                bytes = memoryStream.ToArray();
            }
        }
        string sSql = "";
        SqlFactory sf = new SqlFactory();
        DataTable dt = new DataTable();
        string JSONresult = "";
        Dictionary<string, string> Dparameter = new Dictionary<string, string>();
        switch (sType)
        {
            case "tbl_planupload_data":
                sSql = @"select plan_upload_id,plan_upload_name,plan_upload_case_no,convert(varchar, plan_upload_date, 111) as plan_upload_date,
                                plan_upload_file_id_1,plan_upload_file_name_1,plan_upload_file_type_1,
                                plan_upload_file_id_2,plan_upload_file_name_2,plan_upload_file_type_2,
                                plan_upload_file_id_3,plan_upload_file_name_3,plan_upload_file_type_3
                                from tbl_plan_upload_data where 1=1";
                if (!string.IsNullOrEmpty(sFilter))
                {
                    sSql += "and (plan_upload_case_no like'%" + sFilter + "%' " + " or plan_upload_name like '%" + sFilter + "%')";
                }
                if (!string.IsNullOrEmpty(sstartdate) && !string.IsNullOrEmpty(senddate))
                {
                    sSql += "and convert(varchar, plan_upload_date, 23) between '" + sstartdate + "' and '" + senddate + "'";
                }
                sSql += " order by plan_upload_id";
                dt = sf.QueryData(sSql, null);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "plan_upload_file":
                //清除已存在之檔案資料
                sSql = @"delete tbl_paln_file_data where plan_file_id =@file_id ";
                Dparameter.Add("file_id", fileid);
                sf.ModifyData(sSql, Dparameter);
                //新增檔案資料(binary)
                string sConnection = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["MSSQL"].ConnectionString;
                SqlConnection conn = new SqlConnection(sConnection);
                sSql = @"insert into tbl_paln_file_data 
                           select @file_id,@file_data,getdate()";
                SqlCommand cmmd = new SqlCommand(sSql, conn);
                conn.Open();
                cmmd.Parameters.Add("@file_id", SqlDbType.VarChar);
                cmmd.Parameters["@file_id"].Value = fileid;

                cmmd.Parameters.Add("@file_data", SqlDbType.VarBinary);
                cmmd.Parameters["@file_data"].Value = bytes;
                var firstColumn = cmmd.ExecuteScalar();
                string result = "";
                if (firstColumn != null)
                {
                    result = firstColumn.ToString();
                }
                cmmd.Dispose();
                conn.Close();
                break;
            case "plan_delete_file":
                sSql = @"delete tbl_paln_file_data where plan_file_id =@file_id ";
                Dparameter.Add("file_id", fileid);
                sf.ModifyData(sSql, Dparameter);
                break;
            case "save_plan_data":

                sSql = @"select * from tbl_plan_upload_data where plan_upload_case_no=@plan_upload_case_no";
                Dparameter.Add("plan_upload_case_no", sid);
                dt = sf.QueryData(sSql, Dparameter);
                Dparameter = new Dictionary<string, string>();
                if (dt.Rows.Count > 0)
                {
                    sSql = @"update tbl_plan_upload_data 
                                set plan_upload_name=@plan_upload_name,plan_upload_case_no=@plan_upload_case_no,plan_upload_date=getdate(),
                                    plan_upload_file_id_1=@plan_upload_file_id_1,plan_upload_file_name_1=@plan_upload_file_name_1,
                                    plan_upload_file_type_1=@plan_upload_file_type_1,plan_upload_file_id_2=@plan_upload_file_id_2,
                                    plan_upload_file_name_2=@plan_upload_file_name_2,plan_upload_file_type_2=@plan_upload_file_type_2,
                                    plan_upload_file_id_3=@plan_upload_file_id_3,plan_upload_file_name_3=@plan_upload_file_name_3,
                                    plan_upload_file_type_3=@plan_upload_file_type_3,plan_upload_time=getdate(),plan_upload_remark=@plan_upload_remark
                              where plan_upload_id=@plan_upload_id
                              ";
                    Dparameter.Add("@plan_upload_name", sname);
                    Dparameter.Add("@plan_upload_case_no", sid);
                    Dparameter.Add("@plan_upload_file_id_1", sid + "_1");
                    Dparameter.Add("@plan_upload_file_name_1", sfile1name);
                    Dparameter.Add("@plan_upload_file_type_1", sfile1type);
                    Dparameter.Add("@plan_upload_file_id_2", sid + "_2");
                    Dparameter.Add("@plan_upload_file_name_2", sfile2name);
                    Dparameter.Add("@plan_upload_file_type_2", sfile2type);
                    Dparameter.Add("@plan_upload_file_id_3", sid + "_3");
                    Dparameter.Add("@plan_upload_file_name_3", sfile3name);
                    Dparameter.Add("@plan_upload_file_type_3", sfile3type);
                    Dparameter.Add("@plan_upload_remark", sremark);
                    Dparameter.Add("@plan_upload_id", dt.Rows[0]["plan_upload_id"].ToString());
                    sf.ModifyData(sSql, Dparameter);
                }
                else
                {
                    sSql = @"insert into tbl_plan_upload_data (plan_upload_name,plan_upload_case_no,plan_upload_date,
                            plan_upload_file_id_1,plan_upload_file_name_1,plan_upload_file_type_1,
                            plan_upload_file_id_2,plan_upload_file_name_2,plan_upload_file_type_2,
                            plan_upload_file_id_3,plan_upload_file_name_3,plan_upload_file_type_3,
                            plan_upload_time,plan_upload_remark
                            )
                           select @plan_upload_name,@plan_upload_case_no,getdate(),@plan_upload_file_id_1,@plan_upload_file_name_1,
                                  @plan_upload_file_type_1,@plan_upload_file_id_2,@plan_upload_file_name_2,@plan_upload_file_type_2,
                                  @plan_upload_file_id_3,@plan_upload_file_name_3,@plan_upload_file_type_3,getdate(),@plan_upload_remark
                    ";
                    Dparameter.Add("@plan_upload_name", sname);
                    Dparameter.Add("@plan_upload_case_no", sid);
                    Dparameter.Add("@plan_upload_file_id_1", sid + "_1");
                    Dparameter.Add("@plan_upload_file_name_1", sfile1name);
                    Dparameter.Add("@plan_upload_file_type_1", sfile1type);
                    Dparameter.Add("@plan_upload_file_id_2", sid + "_2");
                    Dparameter.Add("@plan_upload_file_name_2", sfile2name);
                    Dparameter.Add("@plan_upload_file_type_2", sfile2type);
                    Dparameter.Add("@plan_upload_file_id_3", sid + "_3");
                    Dparameter.Add("@plan_upload_file_name_3", sfile3name);
                    Dparameter.Add("@plan_upload_file_type_3", sfile3type);
                    Dparameter.Add("@plan_upload_remark", sremark);
                    sf.ModifyData(sSql, Dparameter);
                }
                break;
            case "loadplanuploaddata":
                sSql = @"select plan_upload_name,plan_upload_case_no,plan_upload_date,
                            plan_upload_file_id_1,plan_upload_file_name_1,plan_upload_file_type_1,
                            plan_upload_file_id_2,plan_upload_file_name_2,plan_upload_file_type_2,
                            plan_upload_file_id_3,plan_upload_file_name_3,plan_upload_file_type_3,
                            plan_upload_time,plan_upload_remark from tbl_plan_upload_data 
                            where plan_upload_case_no=@plan_upload_case_no
                        ";
                Dparameter.Add("@plan_upload_case_no", sid);
                dt = sf.QueryData(sSql, Dparameter);
                JSONresult = JsonConvert.SerializeObject(dt);
                context.Response.Write(JSONresult);
                break;
            case "deleteplanuploaddata":
                sSql = @" delete   from tbl_plan_upload_data where  plan_upload_case_no =@plan_upload_case_no";
                Dparameter.Add("@plan_upload_case_no", sid);
                sf.ModifyData(sSql, Dparameter);
                sSql = @"delete  from tbl_paln_file_data where  plan_file_id in(" + "'" + sid + "_1','" + sid + "_2','" + sid + "_3'" + ")";
                sf.QueryData(sSql, null);
                break;
            case "ExportFile":
                sSql = @" select case when b.plan_upload_file_id_1=@plan_file_id then b.plan_upload_file_name_1  
						when b.plan_upload_file_id_2= @plan_file_id then b.plan_upload_file_name_2 
						else b.plan_upload_file_name_3 end filename,
			 case when b.plan_upload_file_id_1= @plan_file_id then b.plan_upload_file_type_1 
						when b.plan_upload_file_id_2= @plan_file_id then b.plan_upload_file_type_2 
						else b.plan_upload_file_type_3 end filetype,
						Plan_file_data 
                   from tbl_paln_file_data a 
                   join tbl_plan_upload_data b on b.plan_upload_case_no=@plan_case_no  and 1=1 
                  where a.plan_file_id =@plan_file_id";
                Dparameter.Add("@plan_case_no", sid);
                Dparameter.Add("@plan_file_id", fileid);
                dt = sf.QueryData(sSql, Dparameter);
                byte[] file = (byte[])dt.Rows[0][2];
                MemoryStream stream = new MemoryStream(file);
                string sFileName = dt.Rows[0][0].ToString();
                context.Response.Clear();
                context.Response.Buffer = true;
                context.Response.AddHeader("content-disposition", "attachment; filename=" + sFileName);
                context.Response.ContentType = dt.Rows[0][1].ToString();
                context.Response.BinaryWrite(stream.ToArray());
                context.Response.End();
                break;
            case "exportexcel":
                sSql = @"select plan_upload_case_no as '核定文號',plan_upload_name as '計畫名稱',convert(varchar, plan_upload_date, 111) as '上傳日期',
                                plan_upload_file_name_1 as '附件一',plan_upload_file_name_2 as '附件二',plan_upload_file_name_3 as'附件三'
                                from tbl_plan_upload_data where 1=1";
                if (!string.IsNullOrEmpty(sFilter))
                {
                    sSql += "and (plan_upload_case_no like'%" + sFilter + "%' " + " or plan_upload_name like '%" + sFilter + "%')";
                }
                if (!string.IsNullOrEmpty(sstartdate) && !string.IsNullOrEmpty(senddate))
                {
                    sSql += "and convert(varchar, plan_upload_date, 23) between '" + sstartdate + "' and '" + senddate + "'";
                }
                sSql += " order by plan_upload_id";
                dt = sf.QueryData(sSql, null);
                XLWorkbook wb = new XLWorkbook();
                IXLWorksheet workSheet = wb.Worksheets.Add(dt,"計畫書查詢總表");
                workSheet.Columns().AdjustToContents();
                MemoryStream streamexcel = GetStream(wb);
                string sexcelFileName = "計畫書查詢總表.xlsx";
                context.Response.Clear();
                context.Response.Buffer = true;
                context.Response.AddHeader("content-disposition", "attachment; filename=" + sexcelFileName);
                context.Response.ContentType = "application/vnd.ms-excel";
                context.Response.BinaryWrite(streamexcel.ToArray());
                context.Response.End();
                break;
            case "plan_delete_file_all":
                sSql = @"delete  from tbl_paln_file_data where  plan_file_id in(" + "'" + fileid + "_1','" + fileid + "_2','" + fileid + "_3'" + ")";
                sf.QueryData(sSql, null);
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
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}