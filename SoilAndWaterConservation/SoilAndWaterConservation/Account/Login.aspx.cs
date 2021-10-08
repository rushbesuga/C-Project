using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System;
using System.Web;
using System.Web.UI;
using SoilAndWaterConservation;
using System.Collections.Generic;
using System.Data;
using System.Web.UI.WebControls;

public partial class Account_Login : Page
{
    protected void Page_PreRender(object sender, EventArgs e)
    {
        LoginView loginView = (LoginView)(this.Page.Master as MasterPage).FindControl("LoginView1");
        if (Session["USER"] != null)
        {
            ((System.Web.UI.HtmlControls.HtmlGenericControl)Master.FindControl("AdminSubmenu")).Visible = true;
            ((System.Web.UI.HtmlControls.HtmlAnchor)Master.FindControl("CastleIndex")).HRef = "~/Default_Admin";
            loginView.FindControl("BtnLogin").Visible = false;
            loginView.FindControl("BtnLogOut").Visible = true;
        }
        else
        {
            ((System.Web.UI.HtmlControls.HtmlGenericControl)Master.FindControl("AdminSubmenu")).Visible = false;
            ((System.Web.UI.HtmlControls.HtmlAnchor)Master.FindControl("CastleIndex")).HRef = "~/Default";
            loginView.FindControl("BtnLogin").Visible = true;
            loginView.FindControl("BtnLogOut").Visible = false;
        }

    }
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void LogIn(object sender, EventArgs e)
    {
        if (IsValid)
        {
            string sValidation = Session["ValidateNum"] as string ?? Guid.NewGuid().ToString();
            if (txtCheck.Text != sValidation)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "", "alert('登入失敗，驗證碼有誤！');", true);
                return;
            }
            HttpCookie cookie = new HttpCookie("Info");
            TimeSpan ts = new TimeSpan(1, 0, 0, 0);//cookie有效作用时间，具体查msdn
            cookie.Values.Add("AdminID", UserName.Text.Trim());//增加属性
            Response.AppendCookie(cookie);//确定写入cookie中
            var manager = new UserManager();
            SqlFactory sf = new SqlFactory();
            string sSQl = @"select * from tbl_admin_data where user_id = @user_id and password = @password and enable = @enable";
            Dictionary<string,string> DParameter = new Dictionary<string, string>();
            DParameter.Add("@user_id", UserName.Text.Trim());
            DParameter.Add("@password", Password.Text.Trim());
            DParameter.Add("@enable", "1");
            DataTable dt = sf.QueryData(sSQl, DParameter);
            if (dt.Rows.Count>0)
            {
                Session["USER"] = dt.Rows[0]["user_id"];
                Session["LEVEL"] = dt.Rows[0]["level"];
                sf.InsertLoginLog(UserName.Text.Trim());
                Response.Redirect("../Default_Admin.aspx");
            }
            else
            {
                Response.Redirect("../Default.aspx");
            }
        }
    }
}