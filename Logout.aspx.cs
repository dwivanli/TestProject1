using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BudgetPlan
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
			HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
			if (htcoUserLoginID != null)
			{
				htcoUserLoginID.Values.Remove("UserID");

				TimeSpan ts = new TimeSpan(-1, 0, 0, 0);
				htcoUserLoginID.Expires = DateTime.Now.Add(ts);//删除整个Cookie，只要把过期时间设置为现在
				Response.Cookies.Add(htcoUserLoginID);
			}

			HttpCookie htcoPassParas = Request.Cookies["CurrCompany"];
			if (htcoPassParas != null)
			{
				htcoPassParas.Values.Remove("Company");
				htcoPassParas.Values.Remove("CompanyName");

				TimeSpan ts = new TimeSpan(-1, 0, 0, 0);
				htcoPassParas.Expires = DateTime.Now.Add(ts);
				Response.Cookies.Add(htcoPassParas);
			}

			Response.Redirect("Login.aspx");
		}
    }
}