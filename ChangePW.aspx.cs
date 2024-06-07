using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Text;

namespace BudgetPlan
{
    public partial class ChangePW : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                RadLabelMsg.Text = "";

                Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
                labMasterTitle.Text = "Change password.";

                HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
                if (htcoUserLoginID != null)
                {
                    RadTextBoxUserID.Text = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
                }

                if (RadTextBoxUserID.Text == "")
                {
                    Response.Redirect("Login.aspx");
                }
            }

        }

        protected void RadButtonChangePW_Click(object sender, EventArgs e)
        {
            StringBuilder MsgList = new StringBuilder("");
            bool IsOK = true;

            RadLabelMsg.Text = "";

            string UserID = RadTextBoxUserID.Text;

            string sql = "";

            ClassMain main = new ClassMain();

            sql = "select * from UserFile where UserID='" + UserID + "'";

            string Msg = "";

            if (RadTextBoxNewPw.Text != RadTextBoxConfirmNewPw.Text)
            {
                MsgList.Append("The new passwords you typed do not match.<br />");
                IsOK = false;
            }

            RadLabelMsg.Text = MsgList.ToString();

            if (IsOK)
            {
                string newpw = main.Encode(RadTextBoxNewPw.Text);

                sql = "update UserFile set PassWord='" + newpw.Replace("'", "''") + "' where UserID='" + UserID + "'";

                int i = main.RunSQL(sql, ref Msg);

                RadLabelErrorMsg.Text = Msg;

                if (i > 0)
                {
                    RadLabelMsg.Text = "The password has been changed!";
                }
            }
        }
    }
}