using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace BudgetPlan
{
    public partial class DialogSearchSegValue : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string Company = "", COACode = "", SegmentNbr = "0", SegmentCode = "ZZZZZZZZZ";

                if (Request.QueryString["Company"] != null)
                {
                    Company = Request.QueryString["Company"].ToString();
                }

                if (Request.QueryString["COACode"] != null)
                {
                    COACode = Request.QueryString["COACode"].ToString();
                }

                if (Request.QueryString["SegmentNbr"] != null)
                {
                    SegmentNbr = Request.QueryString["SegmentNbr"].ToString();
                }

                SqlDataSourceSearch.SelectParameters["Company"].DefaultValue = Company;
                SqlDataSourceSearch.SelectParameters["COACode"].DefaultValue = COACode;
                SqlDataSourceSearch.SelectParameters["SegmentNbr"].DefaultValue = SegmentNbr;
                SqlDataSourceSearch.SelectParameters["SegmentCode"].DefaultValue = SegmentCode;
            }
        }

        protected void RadGridSearch_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {

        }
        protected void RadButtonSearch_Click(object sender, EventArgs e)
        {
            string Company = "", COACode = "", SegmentNbr = "0", SegmentCode = RadTextSegCode.Text.Trim();

            if (Request.QueryString["Company"] != null)
            {
                Company = Request.QueryString["Company"].ToString();
            }

            if (Request.QueryString["COACode"] != null)
            {
                COACode = Request.QueryString["COACode"].ToString();
            }

            if (Request.QueryString["SegmentNbr"] != null)
            {
                SegmentNbr = Request.QueryString["SegmentNbr"].ToString();
            }



            SqlDataSourceSearch.SelectParameters["Company"].DefaultValue = Company;
            SqlDataSourceSearch.SelectParameters["COACode"].DefaultValue = COACode;
            SqlDataSourceSearch.SelectParameters["SegmentNbr"].DefaultValue = SegmentNbr;
            SqlDataSourceSearch.SelectParameters["SegmentCode"].DefaultValue = SegmentCode+"%";

            SqlDataSourceSearch.DataBind();
            RadGridSearch.DataBind();
        }
    }
}