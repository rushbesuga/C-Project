﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_SendQA : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        rbmale.Checked = true;
    }



    protected void btnsend_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(tbemailtitle.Text))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "", "alert(\"請輸入email主旨 !\");", true);
            return;
        }
        else if (string.IsNullOrEmpty(tbname.Text))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "", "alert(\"請輸入姓名 !\");", true);
            return;
        }
        else if (string.IsNullOrEmpty(tbphone.Text)) { 
            ScriptManager.RegisterStartupScript(this, this.GetType(), "", "alert(\"請輸入電話號碼 !\");", true);
            return;
        }
        else if (string.IsNullOrEmpty(tbemail.Text)) { 
            ScriptManager.RegisterStartupScript(this, this.GetType(), "", "alert(\"請輸入Email信箱 !\");", true);
            return;
        }
        else if (string.IsNullOrEmpty(tbcontent.Text)) { 
            ScriptManager.RegisterStartupScript(this, this.GetType(), "", "alert(\"請輸入問題 !\");", true);
            return;
        }
        string sValidation = Session["ValidateNum"] as string ?? Guid.NewGuid().ToString();
        if (txtCheck.Text != sValidation)
        {
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "", "alert('登入失敗，驗證碼有誤！');", true);
            return;
        }
        try
        {
            SqlFactory sqlFactory = new SqlFactory();
            string sSql = @"insert into tbl_qaandmessage_data(row_title,row_name,row_gender,row_phone,row_email,row_content,row_createtime)
                           values(@title,@name,@gender,@phone,@email,@content, getdate())
            ";
            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("title", tbemailtitle.Text);
            param.Add("name", tbname.Text);
            string gender = "0";
            if (!rbmale.Checked)
                gender = "1";
            param.Add("gender", gender);
            param.Add("phone", tbphone.Text);
            param.Add("email", tbemail.Text);
            param.Add("content", tbcontent.Text);
            sqlFactory.ModifyData(sSql, param);
            Response.Redirect("../pages/QAandMessageBoard.aspx");
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "", "alert('發問成功');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "", "alert('發問失敗');", true);
        }
    }

    protected void btnclear_Click(object sender, EventArgs e)
    {
        tbname.Text = "";
        tbemailtitle.Text = "";
        tbphone.Text = "";
        tbemail.Text = "";
        tbcontent.Text = "";
        rbmale.Checked = true;
    }
}