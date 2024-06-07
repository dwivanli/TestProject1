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
    public partial class LoginChangePW : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            RadLabelMsg.Text = "";

            Label labMasterTitle = ((MasterPageLoginMenu)Master).FindControl("LabelMasterTitle") as Label;
            labMasterTitle.Text = "Change password.";

            HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
            if (htcoUserLoginID != null)
            {
                //RadTextBoxUserID.Text = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
            }

            if (Request.QueryString["UserID"] != null)
            {
                RadTextBoxUserID.Text = Request.QueryString["UserID"].ToString();
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

            DataTable dt = main.GetSQLtb(sql, ref Msg);
            RadLabelErrorMsg.Text = Msg;

            if (dt != null && dt.Rows.Count > 0)
            {
                if (Convert.ToString(dt.Rows[0]["PassWord"]) != "")
                {
                    string CurrPassword = Convert.ToString(dt.Rows[0]["PassWord"]);

                    if(main.Encode(RadTextBoxOldPw.Text)!= CurrPassword)
                    {
                        MsgList.Append("Invalid current password!<br />");
                        IsOK = false;
                    }
                }                
            }

            if (RadTextBoxNewPw.Text != RadTextBoxConfirmNewPw.Text)
            {
                MsgList.Append("The new passwords you typed do not match.<br />");
                IsOK = false;
            }

            RadLabelMsg.Text = MsgList.ToString();

            if(IsOK)
            {
                string newpw = main.Encode(RadTextBoxNewPw.Text);

                sql = "update UserFile set PassWord='" + newpw.Replace("'", "''") + "' where UserID='" + UserID + "'";

                int i = main.RunSQL(sql, ref Msg);

                RadLabelErrorMsg.Text = Msg;

                if(i>0)
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        protected void RadButtonLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }
    }
}