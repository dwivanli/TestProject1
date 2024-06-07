using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace BudgetPlan
{
    public partial class DialogSearchGLAccount : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string Company = "", COACode = "", GLAccount = "ZZZZZZZZZ";

                if (Request.QueryString["Company"] != null)
                {
                    Company = Request.QueryString["Company"].ToString();
                }

                if (Request.QueryString["COACode"] != null)
                {
                    COACode = Request.QueryString["COACode"].ToString();
                }

                SqlDataSourceSearch.SelectParameters["Company"].DefaultValue = Company;
                SqlDataSourceSearch.SelectParameters["COACode"].DefaultValue = COACode;
                SqlDataSourceSearch.SelectParameters["GLAccount"].DefaultValue = GLAccount;
            }
        }

        protected void RadGridSearch_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {

        }

        protected void RadButtonSearch_Click(object sender, EventArgs e)
        {
            string Company = "", COACode = "", GLAccount = RadTextGLAccount.Text.Trim();

            if (Request.QueryString["Company"] != null)
            {
                Company = Request.QueryString["Company"].ToString();
            }

            if (Request.QueryString["COACode"] != null)
            {
                COACode = Request.QueryString["COACode"].ToString();
            }

            //RadLabelMsg.Text = Company;
            //RadLabelErrorMsg.Text = COACode;

            SqlDataSourceSearch.SelectParameters["Company"].DefaultValue = Company;
            SqlDataSourceSearch.SelectParameters["COACode"].DefaultValue = COACode;
            SqlDataSourceSearch.SelectParameters["GLAccount"].DefaultValue = GLAccount+"%";

            SqlDataSourceSearch.DataBind();
            RadGridSearch.DataBind();
        }
    }
}