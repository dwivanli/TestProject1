using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Data.SqlClient;

namespace BudgetPlan
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{
				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "Home";

				HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
				if (htcoUserLoginID != null)
				{
					//var h2 = new HtmlGenericControl("h2");
					//h2.InnerHtml = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
					RadLabelUserID.Text = RadLabelUserID.Text + HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
					RadTextBoxUserID.Text = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
				}

				if (RadTextBoxUserID.Text == "")
				{
					Response.Redirect("Login.aspx");
				}

				HttpCookie htcoPassParas = Request.Cookies["CurrCompany"];
				if (htcoPassParas != null)
				{
					RadTextBoxCurrentCompany.Text = HttpUtility.UrlDecode(htcoPassParas.Values["Company"].ToString());
					RadTextBoxCurrentCompanyName.Text = HttpUtility.UrlDecode(htcoPassParas.Values["CompanyName"].ToString());
				}

				SqlDataSourceSearchPlanHed.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceSearchPlanHed.SelectParameters["AssignTo"].DefaultValue = RadTextBoxUserID.Text;

				SqlDataSourceSearchPlanHed2.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceSearchPlanHed2.SelectParameters["SubmitTo"].DefaultValue = RadTextBoxUserID.Text;

			}
		}

		protected void RadButtonRefreshPlanEntry_Click(object sender, EventArgs e)
		{
			this.SqlDataSourceSearchPlanHed.DataBind();
			this.RadGridSearchPlanEntry.Rebind();
		}

		protected void RadButtonRefreshPlanApv_Click(object sender, EventArgs e)
		{
			this.SqlDataSourceSearchPlanHed2.DataBind();
			this.RadGridSearchPlanApproval.Rebind();
		}



	}
}