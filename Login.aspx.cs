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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RadLabelMsg.Text = "";

            Label labMasterTitle = ((MasterPageLoginMenu)Master).FindControl("LabelMasterTitle") as Label;
            labMasterTitle.Text = "Online Budget Planning System";

            HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
            if (htcoUserLoginID != null)
            {
                //RadTextBoxUserID.Text = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
            }
        }

		protected void RadButtonLogin_Click(object sender, EventArgs e)
		{
			RadLabelMsg.Text = "";
			RadLabelErrorMsg.Text = "";

			string UserID = RadTextBoxUserID.Text.Trim();
			string Password = RadTextBoxPassword.Text.Trim();

			string sql = "";

			try
			{

				ClassMain main = new ClassMain();
				Password = main.Encode(Password);
				//RadLabelErrorMsg.Text += Password;

				sql = "select A.*,B.[Name] as CurCompanyName from UserFile A left outer join Company B on A.CurCompany=B.Company where  A.UserID='" + UserID + "' and A.PassWord='" + Password + "'";

				string Msg = "";

				DataTable dt = main.GetSQLtb(sql, ref Msg);
				RadLabelErrorMsg.Text += Msg;

				//if ( (dt != null && dt.Rows.Count > 0) || (UserID == "epicor" && RadTextBoxPassword.Text == "") )
				if (dt != null && dt.Rows.Count > 0)
				{
					HttpCookie htc = new HttpCookie("UserLogin");
					htc.Values.Add("UserID", UserID);
					htc.Expires = DateTime.Now.AddDays(1);
					Response.Cookies.Add(htc);

					if(dt != null && dt.Rows.Count > 0)
					{
						string Company = Convert.ToString(dt.Rows[0]["CurCompany"]).Trim();
						string CompanyName = Convert.ToString(dt.Rows[0]["CurCompanyName"]).Trim();

						HttpCookie htcCom = new HttpCookie("CurrCompany");
						htcCom.Values.Add("Company", Company);
						htcCom.Values.Add("CompanyName", CompanyName);

						htcCom.Expires = DateTime.Now.AddDays(1);
						Response.Cookies.Add(htcCom);
					}			

					if(Convert.ToString(dt.Rows[0]["CurCompany"]).Trim()=="")
					{
						Response.Redirect("ChangeCompany.aspx");
					}
					else
					{
						Response.Redirect("Home.aspx");
					}
					
				}
				else
				{
					RadLabelMsg.Text = "Invalid UserID or Password!";
				}

			}
			catch(Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message.ToString();
			}
		}

		protected void RadButtonChangePW_Click(object sender, EventArgs e)
		{
			Response.Redirect("LoginChangePW.aspx?UserID=" + RadTextBoxUserID.Text.Trim());
		}
	}
}