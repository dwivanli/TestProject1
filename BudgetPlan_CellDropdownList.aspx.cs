using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Telerik.Web.UI;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Threading;

namespace BudgetPlan
{
    public partial class BudgetPlan_CellDropdownList : System.Web.UI.Page
    {
        protected static DataTable pGLAccountList;
        protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{
				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "Budget Plan";

				RadTextBoxUserID.Text = "epicor";
				RadTextBoxCurrentCompany.Text = "BGCA";
				RadTextBoxCurrentCompanyName.Text = "BGCA";

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
				SqlDataSourceSearchPlanHed.SelectParameters["PreparedBy"].DefaultValue = RadTextBoxUserID.Text;
				SqlDataSourceCOACode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBookID.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceFiscalYear.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBudgetCode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceSearchTemplateHed.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;

				string COACode = "";
				//Set_SqlDataSourceSegValuePara(RadTextBoxCurrentCompany.Text, COACode);

				string Msg = "";

				string sql = "select top 20 replace(GLAccount,'|','-') as GLAccount,AccountDesc,COACode,SegValue1,SegValue2,SegValue3,SegValue4,SegValue5,SegValue6,SegValue7,SegValue8,SegValue9,SegValue10 from erp.GLAccount where Company=@Company";

				ClassEpicor cEpicor = new ClassEpicor();

				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sql;
				cmd.Parameters.Add(new SqlParameter("@Company", RadTextBoxCurrentCompany.Text));

				DataTable dt = cEpicor.GetData(cmd, ref Msg);
				RadLabelMsg.Text = Msg;

				pGLAccountList = dt;
			}
		}

		protected void RadButtonSearchTemplate_Click(object sender, EventArgs e)
		{
			RadLabelErrorMsg.Text = "";
			RadLabelMsg.Text = "";

			this.SqlDataSourceSearchTemplateHed.DataBind();
			this.RadGridSearchTemplate.Rebind();

			RadGridSearchTemplate.Visible = true;
		}

		protected void RadGridSearchTemplate_ItemCommand(object sender, GridCommandEventArgs e)
		{
			if (e.CommandName == "RadButtonSearchOK")
			{
				foreach (GridDataItem item in RadGridSearchTemplate.SelectedItems)
				{
					string Company = item.GetDataKeyValue("Company").ToString();
					string TemplateNum = item.GetDataKeyValue("TemplateNum").ToString();

					BudgetTemplate_CopyByTemplate(Company, TemplateNum, RadTextBoxEntryNum.Text, RadTextBoxRevision.Text);
				}

				RadGridSearchTemplate.Visible = false;

				BudgetPlan_GetByID(RadTextBoxCompany.Text, RadTextBoxEntryNum.Text, RadTextBoxRevision.Text);
			}

			if (e.CommandName == "RadButtonSearchCancel")
			{
				RadGridSearchTemplate.Visible = false;
			}
		}

		protected void BudgetTemplate_CopyByTemplate(string Company, string TemplateNum, string EntryNum, string Revision)
		{
			ClassMain main = new ClassMain();
			string Msg = "";
			StringBuilder MsgList = new StringBuilder("");

			string sql = "";

			sql = "select * from BudgetTemplateHed where Company='" + Company + "' and TemplateNum='" + TemplateNum + "'";

			DataTable dtTemplateHed = main.GetSQLtb(sql, ref Msg);
			RadLabelErrorMsg.Text = Msg;

			if (dtTemplateHed != null && dtTemplateHed.Rows.Count > 0)
			{
				string COACode = Convert.ToString(dtTemplateHed.Rows[0]["COACode"]);
				string BookID = Convert.ToString(dtTemplateHed.Rows[0]["BookID"]);
				string FiscalYear = Convert.ToString(dtTemplateHed.Rows[0]["FiscalYear"]);
				string BudgetCode = Convert.ToString(dtTemplateHed.Rows[0]["BudgetCode"]);

				sql = "update BudgetPlanHed set COACode='" + COACode + "',BookID='" + BookID + "',FiscalYear='" + FiscalYear + "',BudgetCode='" + BudgetCode + "' where Company='" + Company + "' and EntryNum='" + EntryNum + "' and Revision='" + Revision + "'";

				//string debugTxt = "update DebugTest set TestValue='" + sql.Replace("'", "''") + "'";
				//main.RunSQL(debugTxt, ref Msg);

				Msg = "";
				main.RunSQL(sql, ref Msg);
				if (Msg != "")
					MsgList.Append(Msg + "<br />");

				sql = "delete BudgetPlanDtl where Company='" + Company + "' and EntryNum='" + EntryNum + "'";
				Msg = "";
				main.RunSQL(sql, ref Msg);
				if (Msg != "")
					MsgList.Append(Msg + "<br />");

				sql = "insert BudgetPlanDtl([Company], [EntryNum], [Revision], [Line], [Budget_Item], [GLAccount], [AccountDesc], [Period_1], [Period_2], [Period_3], [Period_4], [Period_5], [Period_6], [Period_7], [Period_8], [Period_9], [Period_10], [Period_11], [Period_12], [SegValue1], [SegValue2], [SegValue3], [SegValue4], [SegValue5], [SegValue6], [SegValue7], [SegValue8], [SegValue9], [SegValue10], [CreatedBy], [CreatedDate])";
				sql = sql + " select [Company], '" + EntryNum + "', '" + Revision + "', [Line], [Budget_Item], [GLAccount], [AccountDesc], [Period_1], [Period_2], [Period_3], [Period_4], [Period_5], [Period_6], [Period_7], [Period_8], [Period_9], [Period_10], [Period_11], [Period_12], [SegValue1], [SegValue2], [SegValue3], [SegValue4], [SegValue5], [SegValue6], [SegValue7], [SegValue8], [SegValue9], [SegValue10], '" + RadTextBoxUserID.Text + "', GetDate()";
				sql = sql + " from BudgetTemplateDtl";
				sql = sql + " where Company='" + Company + "' and TemplateNum='" + TemplateNum + "'";
				sql = sql + " order by [Line]";


				Msg = "";
				main.RunSQL(sql, ref Msg);
				if (Msg != "")
					MsgList.Append(Msg + "<br />");

				RadLabelErrorMsg.Text = MsgList.ToString();
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
			try
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
				{
					//RadTextBoxSubmissionDueDate.Text = Convert.ToDateTime(dtHed.Rows[0]["SubmissionDueDate"]).ToString("yyyy-MM-dd");
					RadDatePickerSubmissionDueDate.SelectedDate = Convert.ToDateTime(dtHed.Rows[0]["SubmissionDueDate"]);
				}
				else
				{
					//RadTextBoxSubmissionDueDate.Text = "";
					RadDatePickerSubmissionDueDate.SelectedDate = null;
				}


				RadComboBoxAssignTo.Text = "";
				RadComboBoxAssignTo.SelectedValue = Convert.ToString(dtHed.Rows[0]["AssignTo"]);
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

				//Set_SqlDataSourceSegValuePara(RadTextBoxCompany.Text, RadComboBoxCOACode.SelectedValue.ToString());

				this.RadGridDtl.DataBind();

				if (Convert.ToString(dtHed.Rows[0]["Status"]) != "")
				{
					IsEntryReadOnly(true);
				}
				else
				{
					IsEntryReadOnly(false);
				}

				RadTextBoxEntryNum.ReadOnly = true;



			}
			catch (Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message.ToString();
			}

		}

		protected void IsEntryReadOnly(bool IsReadOnly)
		{
			RadTextBoxCompany.ReadOnly = IsReadOnly;
			RadTextBoxEntryNum.ReadOnly = IsReadOnly;
			//RadTextBoxRevision.ReadOnly = IsReadOnly;
			//RadTextBoxPreparedBy.ReadOnly = IsReadOnly;
			//RadTextBoxSubmissionDueDate.ReadOnly = !IsReadOnly;
			RadDatePickerSubmissionDueDate.Enabled = !IsReadOnly;
			RadComboBoxAssignTo.Enabled = !IsReadOnly;
			RadComboBoxCOACode.Enabled = !IsReadOnly;
			RadComboBoxBookID.Enabled = !IsReadOnly;
			RadComboBoxFiscalYear.Enabled = !IsReadOnly;
			RadComboBoxBudgetCode.Enabled = !IsReadOnly;
			RadTextBoxBudgetTitle.ReadOnly = IsReadOnly;
			//RadTextBoxStatus.ReadOnly = IsReadOnly;

		}
		protected void RadButtonNew_Click(object sender, EventArgs e)
		{
			string Company = "Company";
			string EntryNum = "EntryNum";
			BudgetPlan_GetNewHed(Company, EntryNum);
		}

		protected void BudgetPlan_GetNewHed(string Company, string EntryNum)
		{
			string sql = "";

			sql = "select * from BudgetPlanHed where Company='" + Company + "' and EntryNum='" + EntryNum + "'";

			ClassMain main = new ClassMain();
			string Msg = "";

			DataTable dtHed = main.GetSQLtb(sql, ref Msg);
			RadLabelErrorMsg.Text = Msg;

			if (dtHed != null && dtHed.Rows.Count == 0)
			{
				DataRow dr = dtHed.NewRow();
				dr["Company"] = RadTextBoxCurrentCompany.Text;
				dr["Revision"] = 0;
				dr["FiscalYear"] = 0;
				dr["PreparedBy"] = RadTextBoxUserID.Text;
				dtHed.Rows.Add(dr);
			}

			RadTextBoxCompany.Text = Convert.ToString(dtHed.Rows[0]["Company"]);
			RadTextBoxEntryNum.Text = Convert.ToString(dtHed.Rows[0]["EntryNum"]);
			RadTextBoxRevision.Text = Convert.ToString(dtHed.Rows[0]["Revision"]);
			RadTextBoxPreparedBy.Text = Convert.ToString(dtHed.Rows[0]["PreparedBy"]);
			//RadTextBoxSubmissionDueDate.Text = Convert.ToString(dtHed.Rows[0]["SubmissionDueDate"]);
			RadDatePickerSubmissionDueDate.SelectedDate = DateTime.Now.Date;
			RadComboBoxAssignTo.Text = "";
			RadComboBoxAssignTo.SelectedValue = Convert.ToString(dtHed.Rows[0]["AssignTo"]);
			RadComboBoxCOACode.Text = "";
			RadComboBoxCOACode.SelectedValue = Convert.ToString(dtHed.Rows[0]["COACode"]);
			RadComboBoxBookID.Text = "";
			RadComboBoxBookID.SelectedValue = Convert.ToString(dtHed.Rows[0]["BookID"]);
			RadComboBoxFiscalYear.Text = "";
			RadComboBoxFiscalYear.SelectedValue = Convert.ToString(dtHed.Rows[0]["FiscalYear"]);
			RadComboBoxBudgetCode.SelectedValue = Convert.ToString(dtHed.Rows[0]["BudgetCode"]);
			RadTextBoxBudgetTitle.Text = Convert.ToString(dtHed.Rows[0]["BudgetTitle"]);
			RadTextBoxStatus.Text = Convert.ToString(dtHed.Rows[0]["Status"]);

			this.SqlDataSourceDtl.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceDtl.SelectParameters["EntryNum"].DefaultValue = EntryNum;

			this.SqlDataSourceDtl.DataBind();
			this.RadGridDtl.DataBind();

			RadTextBoxEntryNum.ReadOnly = false;
			RadDatePickerSubmissionDueDate.Enabled = true;
			RadComboBoxAssignTo.Enabled = true;
			RadComboBoxCOACode.Enabled = true;
			RadComboBoxBookID.Enabled = true;
			RadComboBoxFiscalYear.Enabled = true;
			RadComboBoxBudgetCode.Enabled = true;
			RadTextBoxBudgetTitle.ReadOnly = false;
		}

		protected void RadButtonSave_Click(object sender, EventArgs e)
		{
			string sql = "";

			sql = "select * from BudgetPlanHed where Company='' and EntryNum='' and Revision=0";

			ClassMain main = new ClassMain();
			string Msg = "";

			DataTable dtHed = main.GetSQLtb(sql, ref Msg);
			RadLabelErrorMsg.Text = Msg;

			if (dtHed != null && dtHed.Rows.Count == 0)
			{
				DataRow dr = dtHed.NewRow();
				dtHed.Rows.Add(dr);
			}

			dtHed.Rows[0]["Company"] = RadTextBoxCompany.Text;
			dtHed.Rows[0]["EntryNum"] = RadTextBoxEntryNum.Text;
			dtHed.Rows[0]["Revision"] = RadTextBoxRevision.Text;
			dtHed.Rows[0]["PreparedBy"] = RadTextBoxPreparedBy.Text;
			//dtHed.Rows[0]["SubmissionDueDate"] = RadTextBoxSubmissionDueDate.Text;
			dtHed.Rows[0]["SubmissionDueDate"] = Convert.ToDateTime(RadDatePickerSubmissionDueDate.SelectedDate);
			dtHed.Rows[0]["AssignTo"] = RadComboBoxAssignTo.SelectedValue;
			dtHed.Rows[0]["COACode"] = RadComboBoxCOACode.SelectedValue;
			dtHed.Rows[0]["BookID"] = RadComboBoxBookID.SelectedValue;
			dtHed.Rows[0]["FiscalYear"] = RadComboBoxFiscalYear.SelectedValue;
			dtHed.Rows[0]["BudgetCode"] = RadComboBoxBudgetCode.SelectedValue;
			dtHed.Rows[0]["BudgetTitle"] = RadTextBoxBudgetTitle.Text;
			dtHed.Rows[0]["CreatedBy"] = RadTextBoxUserID.Text;
			dtHed.Rows[0]["CreatedDate"] = DateTime.Now.Date;
			dtHed.Rows[0]["ChangedBy"] = RadTextBoxUserID.Text;
			dtHed.Rows[0]["ChangedDate"] = DateTime.Now.Date;


			Msg = "";
			BudgetPlan_UpdateHed(dtHed.Rows[0], ref Msg);
			RadLabelErrorMsg.Text = Msg;

			RadLabelMsg.Text = "Entry# saved.";

			RadTextBoxEntryNum.ReadOnly = true;
		}

		protected void BudgetPlan_UpdateHed(DataRow drSave, ref string Msg)
		{
			string sql = "", Company = "", EntryNum = "", CreatedBy = "";
			int Revision = 0;
			DateTime CreatedDate;

			Company = Convert.ToString(drSave["Company"]);
			EntryNum = Convert.ToString(drSave["EntryNum"]);
			Revision = Convert.ToInt32(drSave["Revision"]);
			CreatedBy = Convert.ToString(drSave["CreatedBy"]);
			CreatedDate = Convert.ToDateTime(drSave["CreatedDate"]);

			sql = "select * from BudgetPlanHed where Company='" + Company + "' and EntryNum='" + EntryNum + "' and Revision=" + Revision.ToString() + "";

			ClassMain main = new ClassMain();

			DataTable dtHed = main.GetSQLtb(sql, ref Msg);

			if (dtHed != null && dtHed.Rows.Count == 0)
			{
				SqlCommand cmd1 = new SqlCommand();
				cmd1.CommandText = "insert into BudgetPlanHed(Company,EntryNum,Revision,CreatedBy,CreatedDate) Values (@Company,@EntryNum,@Revision,@CreatedBy,@CreatedDate)";
				cmd1.CommandTimeout = 3600;
				cmd1.Parameters.Add(new SqlParameter("@Company", Company));
				cmd1.Parameters.Add(new SqlParameter("@EntryNum", EntryNum));
				cmd1.Parameters.Add(new SqlParameter("@Revision", Revision));
				cmd1.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
				cmd1.Parameters.Add(new SqlParameter("@CreatedDate", CreatedDate.ToString("yyyy-MM-dd")));

				string Msg1 = "";
				int UpdateRows1 = main.UpdateBySQL(cmd1, ref Msg1);

				if (Msg1 != "")
					Msg += "Insert Error:" + Msg1;

			}


			SqlCommand cmd2 = new SqlCommand();
			cmd2.CommandText = "update BudgetPlanHed set [PreparedBy] = @PreparedBy, [SubmissionDueDate] = @SubmissionDueDate, [AssignTo] = @AssignTo, [COACode] = @COACode, [BookID] = @BookID, [FiscalYear] = @FiscalYear, [BudgetCode] = @BudgetCode, [BudgetTitle] = @BudgetTitle, [ChangedBy] = @ChangedBy, [ChangedDate] = @ChangedDate where [Company] = @Company and [EntryNum] = @EntryNum and [Revision] = @Revision";
			cmd2.CommandTimeout = 3600;
			cmd2.Parameters.Add(new SqlParameter("@Company", Convert.ToString(drSave["Company"])));
			cmd2.Parameters.Add(new SqlParameter("@EntryNum", Convert.ToString(drSave["EntryNum"])));
			cmd2.Parameters.Add(new SqlParameter("@Revision", Convert.ToString(drSave["Revision"])));
			cmd2.Parameters.Add(new SqlParameter("@PreparedBy", Convert.ToString(drSave["PreparedBy"])));
			cmd2.Parameters.Add(new SqlParameter("@SubmissionDueDate", Convert.ToString(drSave["SubmissionDueDate"])));
			cmd2.Parameters.Add(new SqlParameter("@AssignTo", Convert.ToString(drSave["AssignTo"])));
			cmd2.Parameters.Add(new SqlParameter("@COACode", Convert.ToString(drSave["COACode"])));
			cmd2.Parameters.Add(new SqlParameter("@BookID", Convert.ToString(drSave["BookID"])));
			cmd2.Parameters.Add(new SqlParameter("@FiscalYear", Convert.ToString(drSave["FiscalYear"])));
			cmd2.Parameters.Add(new SqlParameter("@BudgetCode", Convert.ToString(drSave["BudgetCode"])));
			cmd2.Parameters.Add(new SqlParameter("@BudgetTitle", Convert.ToString(drSave["BudgetTitle"])));
			cmd2.Parameters.Add(new SqlParameter("@ChangedBy", Convert.ToString(drSave["ChangedBy"])));
			cmd2.Parameters.Add(new SqlParameter("@ChangedDate", Convert.ToDateTime(drSave["ChangedDate"]).ToString("yyyy-MM-dd")));

			string Msg2 = "";
			int UpdateRows2 = main.UpdateBySQL(cmd2, ref Msg2);

			/*
			string Msg2 = "";
			sql = "update BudgetPlanHed set [PreparedBy] = '"+ Convert.ToString(drSave["PreparedBy"]) + "', [SubmissionDueDate] = '"+ Convert.ToDateTime(drSave["SubmissionDueDate"]).ToString("yyyy-MM-dd") + "', [AssignTo] = '"+ Convert.ToString(drSave["AssignTo"]) + "', [COACode] = '"+ Convert.ToString(drSave["COACode"]) + "', [BookID] = '"+ Convert.ToString(drSave["BookID"]) + "', [FiscalYear] = '"+ Convert.ToString(drSave["FiscalYear"]) + "', [BudgetCode] = '"+ Convert.ToString(drSave["BudgetCode"]) + "', [BudgetTitle] = '"+ Convert.ToString(drSave["BudgetTitle"]) + "', [ChangedBy] = '"+ Convert.ToString(drSave["ChangedBy"]) + "', [ChangedDate] = '"+ Convert.ToDateTime(drSave["ChangedDate"]).ToString("yyyy-MM-dd") + "' where [Company] = '"+ Convert.ToString(drSave["Company"]) + "' and [EntryNum] = '"+ Convert.ToString(drSave["EntryNum"]) + "' and [Revision] = '"+ Convert.ToString(drSave["Revision"]) + "'";
			main.RunSQL(sql, ref Msg2);
			*/

			if (Msg2 != "")
				Msg += "Update Error:" + Msg2;

		}

		protected void RadButtonConfirmAssign_Click(object sender, EventArgs e)
		{
			string Status = "Pending Budget Entry";
			string AssignTo = RadComboBoxAssignTo.SelectedValue.ToString();

			ClassMain main = new ClassMain();

			SqlCommand cmd2 = new SqlCommand();
			cmd2.CommandText = "update BudgetPlanHed set [AssignTo] = @AssignTo, [Status] = @Status where [Company] = @Company and [EntryNum] = @EntryNum and [Revision] = @Revision";
			cmd2.CommandTimeout = 3600;
			cmd2.Parameters.Add(new SqlParameter("@Company", RadTextBoxCompany.Text));
			cmd2.Parameters.Add(new SqlParameter("@EntryNum", RadTextBoxEntryNum.Text));
			cmd2.Parameters.Add(new SqlParameter("@Revision", RadTextBoxRevision.Text));
			cmd2.Parameters.Add(new SqlParameter("@AssignTo", AssignTo));
			cmd2.Parameters.Add(new SqlParameter("@Status", Status));

			string Msg2 = "";
			int UpdateRows2 = main.UpdateBySQL(cmd2, ref Msg2);

			if (Msg2 != "")
				RadLabelErrorMsg.Text = "Update Error:" + Msg2;

			RadLabelMsg.Text = "Assigned to " + RadComboBoxAssignTo.Text;
			RadTextBoxStatus.Text = Status;
		}


		protected void RadGridDtl_ItemDataBound(object sender, GridItemEventArgs e)
		{
			bool IsDataReadOnly = false;

			if (RadTextBoxStatus.Text == "")
			{
				IsDataReadOnly = false;
			}
			else
			{
				IsDataReadOnly = true;
			}


			foreach (GridColumn col in RadGridDtl.MasterTableView.Columns)
			{

				//if (col.ColumnType == "GridBoundColumn" && col.UniqueName == "Period_1")
				if (col.ColumnType == "GridBoundColumn")
				{
					GridBoundColumn colBound = col as GridBoundColumn;
					colBound.ReadOnly = IsDataReadOnly;
				}
			}

			foreach (GridColumn col in RadGridDtl.MasterTableView.Columns)
			{
				if (col.ColumnType == "GridTemplateColumn")
				{
					GridTemplateColumn tempCol = (GridTemplateColumn)col;
					tempCol.ReadOnly = IsDataReadOnly;
				}
			}

		}

		//type方式必须是post，方法必须是静态的，方法声明要加上特性[System.Web.Services.WebMethod()]，传递的参数个数也应该和方法的参数相同。
		[System.Web.Services.WebMethod()]
		public static string AjaxMethod_GetPreloadAccountDesc(string paramGLA, string paramCOACode)
		{
			//return "参数1为：" + param1 + "，参数2为：" + param2;

			//string AccountDesc = "";
			string rtValueList = "";

			if (pGLAccountList != null)
			{
				foreach (DataRow dr in pGLAccountList.Rows)
				{
					if (paramGLA == Convert.ToString(dr["GLAccount"]) && paramCOACode == Convert.ToString(dr["COACode"]))
					{
						//AccountDesc = Convert.ToString(dr["AccountDesc"]);
						rtValueList = Convert.ToString(dr["AccountDesc"]) + "~" + Convert.ToString(dr["SegValue1"]) + "~" + Convert.ToString(dr["SegValue2"]) + "~" + Convert.ToString(dr["SegValue3"]);
						break;
					}
				}
			}

			//return AccountDesc;
			return rtValueList;
		}

		protected void RadButtonCopy_Click(object sender, EventArgs e)
		{
			string Company = RadTextBoxCompany.Text;
			string EntryNum = RadTextBoxEntryNum.Text;


			ClassMain main = new ClassMain();
			string Msg = "";
			StringBuilder MsgList = new StringBuilder("");

			string sql = "";

			//Get New RevisionNum
			sql = "select (isnull(Max([Revision]),0)+1) as NewRevision from BudgetPlanHed where Company='" + Company + "' and EntryNum='" + EntryNum + "'";
			Msg = "";
			DataTable dtNewRev = main.GetSQLtb(sql, ref Msg);
			if (Msg != "")
				MsgList.Append(Msg + "<br />");


			//debug update value
			string debugTxt = "update DebugTest set TestValue='" + sql.Replace("'", "''") + "'";
			main.RunSQL(debugTxt, ref Msg);


			if (dtNewRev != null && dtNewRev.Rows.Count > 0)
			{
				string NewRevision = Convert.ToString(dtNewRev.Rows[0]["NewRevision"]);

				//copy BudgetTemplateHed
				sql = "insert BudgetTemplateHed([Company], [EntryNum], [Revision], [PreparedBy], [SubmissionDueDate], [COACode], [BookID], [FiscalYear], [BudgetCode], [BudgetTitle], [InactiveRevision], [CreatedBy], [CreatedDate], [ChangedBy], [ChangedDate]";
				sql = "select [Company], [EntryNum], '" + NewRevision + "' as [Revision], [PreparedBy], [SubmissionDueDate], [COACode], [BookID], [FiscalYear], [BudgetCode], [BudgetTitle], 0 as [InactiveRevision], '" + RadTextBoxUserID.Text + "', GetDate(), '" + RadTextBoxUserID.Text + "', GetDate() from BudgetTemplateHed where Company='" + Company + "' and EntryNum='" + EntryNum + "'";

				Msg = "";
				main.RunSQL(sql, ref Msg);
				if (Msg != "")
					MsgList.Append(Msg + "<br />");

				//copy BudgetPlanDtl
				sql = "insert BudgetPlanDtl([Company], [EntryNum], [Revision], [Line], [Budget_Item], [GLAccount], [AccountDesc], [Period_1], [Period_2], [Period_3], [Period_4], [Period_5], [Period_6], [Period_7], [Period_8], [Period_9], [Period_10], [Period_11], [Period_12], [SegValue1], [SegValue2], [SegValue3], [SegValue4], [SegValue5], [SegValue6], [SegValue7], [SegValue8], [SegValue9], [SegValue10], [CreatedBy], [CreatedDate])";
				sql = sql + " [Company], [EntryNum], '" + NewRevision + "' as [Revision], [Line], [Budget_Item], [GLAccount], [AccountDesc], [Period_1], [Period_2], [Period_3], [Period_4], [Period_5], [Period_6], [Period_7], [Period_8], [Period_9], [Period_10], [Period_11], [Period_12], [SegValue1], [SegValue2], [SegValue3], [SegValue4], [SegValue5], [SegValue6], [SegValue7], [SegValue8], [SegValue9], [SegValue10], '" + RadTextBoxUserID.Text + "', GetDate()";
				sql = sql + " from BudgetTemplateDtl";
				sql = sql + " where Company='" + Company + "' and EntryNum='" + EntryNum + "'";
				sql = sql + " order by [Line]";

				Msg = "";
				main.RunSQL(sql, ref Msg);
				if (Msg != "")
					MsgList.Append(Msg + "<br />");

				//set inactive old revision
				sql = "update BudgetTemplateHed set InactiveRevision=1 where Company='" + Company + "' and EntryNum='" + EntryNum + "' and Revision<" + NewRevision;

				Msg = "";
				main.RunSQL(sql, ref Msg);
				if (Msg != "")
					MsgList.Append(Msg + "<br />");


				RadLabelErrorMsg.Text = MsgList.ToString();

				BudgetPlan_GetByID(Company, EntryNum, NewRevision);
			}

		}

		protected void RadButtonVoid_Click(object sender, EventArgs e)
		{
			string Company = RadTextBoxCompany.Text;
			string EntryNum = RadTextBoxEntryNum.Text;
			string Revision = RadTextBoxRevision.Text;

			ClassMain main = new ClassMain();
			string Msg = "";
			StringBuilder MsgList = new StringBuilder("");

			//string sql = "update BudgetPlanHed set void=1 where Company='"+Company+"' and EntryNum='"+EntryNum+"'";
			string sql = "update BudgetPlanHed set Status='Void' where Company='" + Company + "' and EntryNum='" + EntryNum + "' and Revision=" + Revision;

			Msg = "";
			main.RunSQL(sql, ref Msg);
			if (Msg != "")
				MsgList.Append(Msg + "<br />");


			RadLabelErrorMsg.Text = MsgList.ToString();
			RadLabelMsg.Text = "EntryNum:" + EntryNum + " voided.";

			BudgetPlan_GetByID(Company, EntryNum, Revision);
		}
		protected void RadComboBoxCOACode_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
		{
			//Set_SqlDataSourceSegValuePara(RadTextBoxCompany.Text, RadComboBoxCOACode.SelectedValue.ToString());
			//this.RadGridDtl.DataBind();
		}
		protected void Set_SqlDataSourceSegValuePara(string Company, string COACode)
		{
			this.SqlDataSourceGLAccount.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceGLAccount.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceGLAccount.DataBind();
			this.SqlDataSourceSegValue1.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue1.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue1.DataBind();
			this.SqlDataSourceSegValue2.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue2.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue2.DataBind();
			this.SqlDataSourceSegValue3.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue3.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue3.DataBind();
			this.SqlDataSourceSegValue4.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue4.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue4.DataBind();
			this.SqlDataSourceSegValue5.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue5.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue5.DataBind();
			this.SqlDataSourceSegValue6.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue6.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue6.DataBind();
			this.SqlDataSourceSegValue7.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue7.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue7.DataBind();
			this.SqlDataSourceSegValue8.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue8.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue8.DataBind();
			this.SqlDataSourceSegValue9.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue9.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue9.DataBind();
			this.SqlDataSourceSegValue10.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceSegValue10.SelectParameters["COACode"].DefaultValue = COACode;
			this.SqlDataSourceSegValue10.DataBind();

			//this.RadGridDtl.DataBind();
		}

		protected void RadButtonDelete_Click(object sender, EventArgs e)
		{
			string EntryNum = RadTextBoxEntryNum.Text;

			ClassMain main = new ClassMain();
			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");
			string sql = "";

			try
			{
				sql = "select * from BudgetPlanHed where Company='" + RadTextBoxCompany.Text + "' and EntryNum='" + RadTextBoxEntryNum.Text + "'";

				DataTable dt = main.GetSQLtb(sql, ref ExMsg);

				if (ExMsg != "")
					ExMsgList.Append("<br />" + ExMsg);

				if (dt != null && dt.Rows.Count > 0)
				{
					string Status = Convert.ToString(dt.Rows[0]["Status"]);

					if (Status == "")
					{
						sql = "delete from BudgetPlanHed where Company='" + RadTextBoxCompany.Text + "' and EntryNum='" + RadTextBoxEntryNum.Text + "'";

						int i = main.RunSQL(sql, ref ExMsg);

						if (ExMsg != "")
							ExMsgList.Append("<br />" + ExMsg);

						sql = "delete from BudgetPlanDtl where Company='" + RadTextBoxCompany.Text + "' and EntryNum='" + RadTextBoxEntryNum.Text + "'";

						int j = main.RunSQL(sql, ref ExMsg);

						if (ExMsg != "")
							ExMsgList.Append("<br />" + ExMsg);

						BudgetPlan_GetByID("COMPANY", "EntryNum", "0");

						RadLabelMsg.Text = "EntryNum:" + EntryNum + " has been deleted!";
					}
					else
					{
						RadLabelMsg.Text = "Delete entryNum:" + EntryNum + " is not allowed!";
					}
				}


			}
			catch (Exception ex)
			{
				ExMsgList.Append("<br />" + ex.Message);
			}
			finally
			{
				RadLabelErrorMsg.Text = ExMsgList.ToString();
			}
		}

		protected void RadButtonDownload_Click(object sender, EventArgs e)
		{
			try
			{
				RadGridDtl.ExportSettings.Excel.Format = GridExcelExportFormat.Xlsx;
				RadGridDtl.ExportSettings.ExportOnlyData = true;
				RadGridDtl.ExportSettings.IgnorePaging = true;
				RadGridDtl.ExportSettings.OpenInNewWindow = true;

				RadGridDtl.MasterTableView.ExportToExcel();
			}
			catch (Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
		}

		protected void RadComboBoxGLAccount_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
		{
			RadComboBox rcb = (RadComboBox)sender;

			rcb.DataSource = pGLAccountList;
			rcb.DataBind();
		}

		protected void RadGridDtl_ItemCreated(object sender, GridItemEventArgs e)
		{
			if (e.Item is GridEditableItem && e.Item.IsInEditMode)
			{
				GridEditableItem editItem = (GridEditableItem)e.Item;
				RadComboBox combo = (RadComboBox)editItem.FindControl("RadComboBoxGLAccount");
				combo.EnableLoadOnDemand = true;
				combo.ShowMoreResultsBox = true;
				combo.AutoPostBack = true;
				combo.ItemsRequested += new RadComboBoxItemsRequestedEventHandler(RadComboBoxGLAccount_ItemsRequested);

			}
		}
	}
}