using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace BudgetPlan
{
    public partial class CompanyRegistry : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{

				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "Company Registry";

				HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
				if (htcoUserLoginID != null)
				{
					RadTextBoxUserID.Text = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
				}

				if (RadTextBoxUserID.Text == "")
				{
					Response.Redirect("Login.aspx");
				}

				//check IsSysAdmin
				ClassMain main = new ClassMain();
				string ExMsg = "";
				StringBuilder ExMsgList = new StringBuilder("");
				string sql = "";

				sql = "select * from UserFile where UserID='" + RadTextBoxUserID.Text + "'";

				DataTable dt = main.GetSQLtb(sql, ref ExMsg);

				if (ExMsg != "")
					ExMsgList.Append("<br />" + ExMsg);

				if (dt != null && dt.Rows.Count > 0)
				{
					bool IsSysAdmin = Convert.ToBoolean(dt.Rows[0]["IsSysAdmin"]);

					if (IsSysAdmin == false)
					{
						Response.Redirect("Home.aspx");
					}
				}

				RadLabelErrorMsg.Text = "";
				RadLabelMsg.Text = "";
			}

			RadTextBoxUserID.Visible = false;
			
		}

		protected void RadButtonCreate_Click(object sender, EventArgs e)
		{
			RadLabelMsg.Text = "";

			if (RadTextBoxCompany.Text.Trim() == "")
			{
				RadLabelMsg.Text = "Invalid Company!";
				return;
			}

			if (RadTextBoxName.Text.Trim() == "")
			{
				RadLabelMsg.Text = "Invalid Name!";
				return;
			}

			string sql = "select * from Company where Company='" + RadTextBoxCompany.Text + "'";

			ClassMain main = new ClassMain();
			string Msg = "";

			DataTable dt = main.GetSQLtb(sql, ref Msg);
			RadLabelErrorMsg.Text = Msg;

			if (dt != null && dt.Rows.Count > 0)
			{
				RadLabelMsg.Text = "Company exists!";
				return;
			}

			sql = "insert Company (Company,[Name],ERPCompany) values ('" + RadTextBoxCompany.Text + "','" + RadTextBoxName.Text + "','" + RadTextBoxERPCompany.Text + "')";

			int x = main.RunSQL(sql, ref Msg);
			RadLabelErrorMsg.Text = Msg;

			RadTextBoxCompany.Text = "";
			RadTextBoxName.Text = "";
			RadTextBoxERPCompany.Text = "";
			RadLabelMsg.Text = RadTextBoxCompany.Text + " created.";

			SqlDataSourceCompanyList.SelectCommand = "select Company,[Name],ERPCompany from Company ORDER BY Company";
			RadGridCompanyList.DataBind();

		}
	}
}