using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BudgetPlan
{
    public partial class ChangeCompany : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{
				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "Change Company";

				HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
				if (htcoUserLoginID != null)
				{
					RadTextBoxUserID.Text = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
				}

				if (RadTextBoxUserID.Text == "")
				{
					Response.Redirect("Login.aspx");
				}

				HttpCookie htcoPassParas = Request.Cookies["CurrCompany"];
				if (htcoPassParas != null)
				{
					RadComboBoxCompany.SelectedValue = HttpUtility.UrlDecode(htcoPassParas.Values["Company"].ToString());
				}

			}
		}

        protected void RadComboBoxCompany_TextChanged(object sender, EventArgs e)
        {

        }

		protected void RadButtonSave_Click(object sender, EventArgs e)
		{
			string Company = Convert.ToString(RadComboBoxCompany.SelectedValue).Trim();
			string CompanyName = Convert.ToString(RadComboBoxCompany.Text).Trim();

			HttpCookie htc = new HttpCookie("CurrCompany");
			htc.Values.Add("Company", Company);
			htc.Values.Add("CompanyName", CompanyName);
			htc.Expires = DateTime.Now.AddDays(1);

			/*
			DateTime dt = DateTime.Now;
			TimeSpan ts = new TimeSpan(0, 0, 1, 0, 0);//过期时间为1分钟
			htc.Expires = dt.Add(ts);//设置过期时间
			*/

			Response.Cookies.Add(htc);

			ClassMain main = new ClassMain();
			string Msg = "";
			string sql = "update UserFile set CurCompany='" + Company + "' where UserID='"+RadTextBoxUserID.Text+"'";
			main.RunSQL(sql, ref Msg);

			RadLabelMsg.Text = "Change current company to "+ RadComboBoxCompany.Text;
		}
	}
}