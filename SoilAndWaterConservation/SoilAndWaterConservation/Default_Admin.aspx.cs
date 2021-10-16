using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default_Admin : Page
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
        if (Session["USER"] == null)
        {
            Response.Redirect("Default.aspx");
        }
        if (Session["LEVEL"] != null)
        {
            if (Session["LEVEL"].ToString() == "2")
                hidlevelcontrol.Value = "1";
            else if (Session["LEVEL"].ToString() == "1" || Session["LEVEL"].ToString() == "9")
                hidlevelcontrol.Value = "0";
        }
    }
}