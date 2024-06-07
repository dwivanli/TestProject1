using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

using System.Text;
using System.Data;

namespace BudgetPlan
{
    public partial class MasterPageSingleMenu : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                InitMenuItems();
            }
        }

        private void InitMenuItems()
        {
            string UserID = "";

            HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
            if (htcoUserLoginID != null)
            {
                UserID = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
            }

            if(UserID == "")
            {
                Response.Redirect("Login.aspx");
            }

            ClassMain main = new ClassMain();
            string ExMsg = "";
            StringBuilder ExMsgList = new StringBuilder("");
            string sql = "";

            try
            {

                sql = "select * from SysMenu where MenuID in (select MenuID from vw_MenuAccessByUser where UserID = '"+UserID+ "') Order by MenuSeq";
 
                DataTable dt = main.GetSQLtb(sql, ref ExMsg);

                if (ExMsg != "")
                    ExMsgList.Append(ExMsg + "<br />" + sql + "<br />");

                if(dt!=null && dt.Rows.Count>0)
                {
                    RadMenu1.DataTextField = "MenuDesc";
                    RadMenu1.DataNavigateUrlField = "NavigateUrl";
                    RadMenu1.DataFieldID = "MenuID";
                    RadMenu1.DataFieldParentID = "ParentMenuID";    //ParentMenuID null is first level menu


                    RadMenu1.DataSource = dt;
                    RadMenu1.DataBind();
                }

/*
                foreach(DataRow dr in dt.Rows)
                {
                    
                    RadMenu1.DataTextField = "MenuDesc";
                    RadMenu1.DataNavigateUrlField = "NavigateUrl";
                    RadMenu1.DataFieldID = "MenuID";

                    RadMenu1.Items.Add()
                }
*/
            }
            catch (Exception ex)
            {
                ExMsgList.Append(ex.Message + "<br />");
            }
            finally
            {
                //RadLabelErrorMsg.Text = ExMsgList.ToString();
            }


            /*
                    <Items>
                        <telerik:RadMenuItem Text="Home" NavigateUrl="Home.aspx" />
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="Budget Template" NavigateUrl="BudgetTemplate.aspx" />
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="Budget Plan" NavigateUrl="BudgetPlan.aspx" />
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="Budget Entry" NavigateUrl="BudgetEntry.aspx" />
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="Budget Approval" NavigateUrl="BudgetApproval.aspx" />
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="Upload to Epicor" NavigateUrl="UploadToEpicor.aspx" />
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="User Registry" NavigateUrl="UserRegistry.aspx"/>
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="Company Registry" NavigateUrl="CompanyRegistry.aspx"/>
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="Change Company" NavigateUrl="ChangeCompany.aspx"/>
                        <telerik:RadMenuItem IsSeparator="true" />
                        <telerik:RadMenuItem Text="Logout" NavigateUrl="Logout.aspx"/>
                    </Items>             
             */

        }
    }
}