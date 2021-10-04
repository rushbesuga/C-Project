using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_CheckQA : System.Web.UI.Page
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
}