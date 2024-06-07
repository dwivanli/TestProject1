using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

using System.Data;
using System.Data.SqlClient;

namespace BudgetPlan
{
    public partial class BudgetApproval : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{
				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "Budget Approval";

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
					RadTextBoxCurrentCompany.Text = HttpUtility.UrlDecode(htcoPassParas.Values["Company"].ToString());
					RadTextBoxCurrentCompanyName.Text = HttpUtility.UrlDecode(htcoPassParas.Values["CompanyName"].ToString());
				}

				RadLabelErrorMsg.Text = "";
				RadLabelMsg.Text = "";

				BudgetPlan_GetByID("COMPANY", "EntryNum", "0");

				SqlDataSourceSearchPlanHed.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceSearchPlanHed.SelectParameters["SubmitTo"].DefaultValue = RadTextBoxUserID.Text;

				SqlDataSourceCOACode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBookID.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceFiscalYear.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBudgetCode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
			}
		}

		protected void RadButtonSearch_Click(object sender, EventArgs e)
		{
			RadLabelErrorMsg.Text = "";
			RadLabelMsg.Text = "";

			this.SqlDataSourceSearchPlanHed.DataBind();
			this.RadGridSearch.Rebind();

			RadGridSearch.Visible = true;
		}

		protected void RadGridSearch_ItemCommand(object sender, GridCommandEventArgs e)
		{
			if (e.CommandName == "RadButtonSearchOK")
			{
				foreach (GridDataItem item in RadGridSearch.SelectedItems)
				{
					string Company = item.GetDataKeyValue("Company").ToString();
					string EntryNum = item.GetDataKeyValue("EntryNum").ToString();
					string Revision = item.GetDataKeyValue("Revision").ToString();

					BudgetPlan_GetByID(Company, EntryNum, Revision);
				}

				RadGridSearch.Visible = false;
			}

			if (e.CommandName == "RadButtonSearchCancel")
			{
				RadGridSearch.Visible = false;
			}
		}

		protected void BudgetPlan_GetByID(string Company, string EntryNum, string Revision)
		{
			string sql = "";

			sql = "select * from BudgetPlanHed where Company='" + Company + "' and EntryNum='" + EntryNum + "' and Revision=" + Revision;

			ClassMain main = new ClassMain();
			string Msg = "";

			DataTable dtHed = main.GetSQLtb(sql, ref Msg);
			RadLabelErrorMsg.Text = Msg;

			if (dtHed != null && dtHed.Rows.Count == 0)
			{
				DataRow dr = dtHed.NewRow();
				dtHed.Rows.Add(dr);
			}

			RadTextBoxCompany.Text = Convert.ToString(dtHed.Rows[0]["Company"]);
			RadTextBoxEntryNum.Text = Convert.ToString(dtHed.Rows[0]["EntryNum"]);
			RadTextBoxRevision.Text = Convert.ToString(dtHed.Rows[0]["Revision"]);
			RadTextBoxPreparedBy.Text = Convert.ToString(dtHed.Rows[0]["PreparedBy"]);

			if (Convert.ToString(dtHed.Rows[0]["SubmissionDueDate"]) != "")
				RadDatePickerSubmissionDueDate.SelectedDate = Convert.ToDateTime(dtHed.Rows[0]["SubmissionDueDate"]);
			else
				RadDatePickerSubmissionDueDate.SelectedDate = null;

			RadComboBoxSubmitTo.Text = "";
			RadComboBoxSubmitTo.SelectedValue = Convert.ToString(dtHed.Rows[0]["SubmitTo"]);
			RadComboBoxCOACode.Text = "";
			RadComboBoxCOACode.SelectedValue = Convert.ToString(dtHed.Rows[0]["COACode"]);
			RadComboBoxBookID.Text = "";
			RadComboBoxBookID.SelectedValue = Convert.ToString(dtHed.Rows[0]["BookID"]);
			RadComboBoxFiscalYear.Text = "";
			RadComboBoxFiscalYear.SelectedValue = Convert.ToString(dtHed.Rows[0]["FiscalYear"]);
			RadComboBoxBudgetCode.Text = "";
			RadComboBoxBudgetCode.SelectedValue = Convert.ToString(dtHed.Rows[0]["BudgetCode"]);
			RadTextBoxBudgetTitle.Text = Convert.ToString(dtHed.Rows[0]["BudgetTitle"]);

			RadTextBoxStatus.Text = Convert.ToString(dtHed.Rows[0]["Status"]);

			this.SqlDataSourceDtl.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceDtl.SelectParameters["EntryNum"].DefaultValue = EntryNum;
			this.SqlDataSourceDtl.SelectParameters["Revision"].DefaultValue = Revision;

			this.SqlDataSourceDtl.DataBind();
			this.RadGridDtl.DataBind();
		}

		protected void RadButtonApprove_Click(object sender, EventArgs e)
		{
			string Status = "Approved";
			string SubmitTo = RadComboBoxSubmitTo.SelectedValue.ToString();

			ClassMain main = new ClassMain();

			SqlCommand cmd2 = new SqlCommand();
			cmd2.CommandText = "update BudgetPlanHed set [Status] = @Status where [Company] = @Company and [EntryNum] = @EntryNum and [Revision] = @Revision";
			cmd2.CommandTimeout = 3600;
			cmd2.Parameters.Add(new SqlParameter("@Company", RadTextBoxCompany.Text));
			cmd2.Parameters.Add(new SqlParameter("@EntryNum", RadTextBoxEntryNum.Text));
			cmd2.Parameters.Add(new SqlParameter("@Revision", RadTextBoxRevision.Text));
			cmd2.Parameters.Add(new SqlParameter("@Status", Status));

			string Msg2 = "";
			int UpdateRows2 = main.UpdateBySQL(cmd2, ref Msg2);

			if (Msg2 != "")
				RadLabelErrorMsg.Text = "Update Error:" + Msg2;

			RadLabelMsg.Text = "Approved";
			RadTextBoxStatus.Text = Status;
		}
		protected void RadButtonReject_Click(object sender, EventArgs e)
		{
			string Status = "Rejected";
			string SubmitTo = RadComboBoxSubmitTo.SelectedValue.ToString();

			ClassMain main = new ClassMain();

			SqlCommand cmd2 = new SqlCommand();
			cmd2.CommandText = "update BudgetPlanHed set [Status] = @Status where [Company] = @Company and [EntryNum] = @EntryNum and [Revision] = @Revision";
			cmd2.CommandTimeout = 3600;
			cmd2.Parameters.Add(new SqlParameter("@Company", RadTextBoxCompany.Text));
			cmd2.Parameters.Add(new SqlParameter("@EntryNum", RadTextBoxEntryNum.Text));
			cmd2.Parameters.Add(new SqlParameter("@Revision", RadTextBoxRevision.Text));
			cmd2.Parameters.Add(new SqlParameter("@Status", Status));

			string Msg2 = "";
			int UpdateRows2 = main.UpdateBySQL(cmd2, ref Msg2);

			if (Msg2 != "")
				RadLabelErrorMsg.Text = "Update Error:" + Msg2;

			RadLabelMsg.Text = "Rejected";
			RadTextBoxStatus.Text = Status;
		}

		protected void RadButtonDownload_Click(object sender, EventArgs e)
		{
			try
			{
				RadGridDtl.ExportSettings.Excel.Format = GridExcelExportFormat.Xlsx;
				RadGridDtl.ExportSettings.ExportOnlyData = true;
				RadGridDtl.ExportSettings.IgnorePaging = true;
				RadGridDtl.ExportSettings.OpenInNewWindow = true;
				RadGridDtl.ExportSettings.FileName = "BudgetApproval " + RadTextBoxEntryNum.Text;

				RadGridDtl.MasterTableView.ExportToExcel();
			}
			catch (Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
		}
	}
}