using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : Page
{
    protected void Page_PreRender(object sender, EventArgs e)
    {
        Session["USER"] = null;
        ((System.Web.UI.HtmlControls.HtmlGenericControl)Master.FindControl("AdminSubmenu")).Visible = false;
        ((System.Web.UI.HtmlControls.HtmlAnchor)Master.FindControl("CastleIndex")).HRef = "~/Default";
        LoginView loginView = (LoginView)(this.Page.Master as MasterPage).FindControl("LoginView1");
        loginView.FindControl("BtnLogOut").Visible = false;
        loginView.FindControl("BtnLogIn").Visible = true;
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
}