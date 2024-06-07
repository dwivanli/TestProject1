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
using System.IO;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx;
//using Telerik.Windows.Documents.Spreadsheet.FormatProviders.Pdf;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.TextBased.Csv;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.TextBased.Txt;
using Telerik.Windows.Documents.Spreadsheet.Model;

namespace BudgetPlan
{
    public partial class BudgetEntry : System.Web.UI.Page
    {
		protected static DataTable pGLAccountList;
		protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{
				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "Budget Entry";

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
				SqlDataSourceSearchPlanHed.SelectParameters["AssignTo"].DefaultValue = RadTextBoxUserID.Text;

				SqlDataSourceCOACode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBookID.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceFiscalYear.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBudgetCode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;

				string COACode = "";
				//Set_SqlDataSourceSegValuePara(RadTextBoxCurrentCompany.Text, COACode);

				string Msg = "";

				string sql = "select replace(GLAccount,'|','-') as GLAccount,AccountDesc,COACode,SegValue1,SegValue2,SegValue3,SegValue4,SegValue5,SegValue6,SegValue7,SegValue8,SegValue9,SegValue10 from erp.GLAccount where Company=@Company";

				ClassEpicor cEpicor = new ClassEpicor();

				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sql;
				cmd.Parameters.Add(new SqlParameter("@Company", RadTextBoxCurrentCompany.Text));

				DataTable dt = cEpicor.GetData(cmd, ref Msg);
				RadLabelMsg.Text = Msg;

				pGLAccountList = dt;

				//RadLabelMsg.Text = pGLAccountList.Rows.Count.ToString();
				//RadLabelMsg.Text = sql;
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


		protected void RadButtonSave_Click(object sender, EventArgs e)
		{
			UpdateData();
		}

		protected void UpdateData()
		{
			try
			{
				bool IsNewHed = false;

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

					IsNewHed = true;
				}

				dtHed.Rows[0]["Company"] = RadTextBoxCompany.Text;
				dtHed.Rows[0]["EntryNum"] = RadTextBoxEntryNum.Text;
				dtHed.Rows[0]["Revision"] = RadTextBoxRevision.Text;
				dtHed.Rows[0]["PreparedBy"] = RadTextBoxPreparedBy.Text;
				//dtHed.Rows[0]["SubmissionDueDate"] = RadTextBoxSubmissionDueDate.Text;
				dtHed.Rows[0]["SubmissionDueDate"] = Convert.ToDateTime(RadDatePickerSubmissionDueDate.SelectedDate);
				//dtHed.Rows[0]["AssignTo"] = RadComboBoxAssignTo.SelectedValue;
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

				if (IsNewHed)
				{
					BudgetPlan_GetByID(RadTextBoxCompany.Text, RadTextBoxEntryNum.Text, RadTextBoxRevision.Text);
				}

				RadTextBoxEntryNum.ReadOnly = true;
			}
			catch (Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
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
			//cmd2.CommandText = "update BudgetPlanHed set [PreparedBy] = @PreparedBy, [SubmissionDueDate] = @SubmissionDueDate, [AssignTo] = @AssignTo, [COACode] = @COACode, [BookID] = @BookID, [FiscalYear] = @FiscalYear, [BudgetCode] = @BudgetCode, [BudgetTitle] = @BudgetTitle, [ChangedBy] = @ChangedBy, [ChangedDate] = @ChangedDate where [Company] = @Company and [EntryNum] = @EntryNum and [Revision] = @Revision";
			cmd2.CommandText = "update BudgetPlanHed set [BudgetCode] = @BudgetCode, [ChangedBy] = @ChangedBy, [ChangedDate] = @ChangedDate where [Company] = @Company and [EntryNum] = @EntryNum and [Revision] = @Revision";
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


		protected void RadButtonConfirmSubmit_Click(object sender, EventArgs e)
		{
			string Status = "Pending Approval";
			string SubmitTo = RadComboBoxSubmitTo.SelectedValue.ToString();

			ClassMain main = new ClassMain();

			SqlCommand cmd2 = new SqlCommand();
			cmd2.CommandText = "update BudgetPlanHed set [SubmitTo] = @SubmitTo, [Status] = @Status where [Company] = @Company and [EntryNum] = @EntryNum and [Revision] = @Revision";
			cmd2.CommandTimeout = 3600;
			cmd2.Parameters.Add(new SqlParameter("@Company", RadTextBoxCompany.Text));
			cmd2.Parameters.Add(new SqlParameter("@EntryNum", RadTextBoxEntryNum.Text));
			cmd2.Parameters.Add(new SqlParameter("@Revision", RadTextBoxRevision.Text));
			cmd2.Parameters.Add(new SqlParameter("@SubmitTo", SubmitTo));
			cmd2.Parameters.Add(new SqlParameter("@Status", Status));

			string Msg2 = "";
			int UpdateRows2 = main.UpdateBySQL(cmd2, ref Msg2);

			if (Msg2 != "")
				RadLabelErrorMsg.Text = "Update Error:" + Msg2;

			RadLabelMsg.Text = "Submitted to " + RadComboBoxSubmitTo.Text;
			RadTextBoxStatus.Text = Status;
		}

		protected void RadGridDtl_ItemDataBound(object sender, GridItemEventArgs e)
		{
			/*
			bool IsDataReadOnly = false;

			if (RadTextBoxStatus.Text == "Pending Budget Entry")
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
			*/
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

		protected void RadButtonDownload_Click(object sender, EventArgs e)
		{
			try
			{
				RadGridDtl.ExportSettings.Excel.Format = GridExcelExportFormat.Xlsx;
				RadGridDtl.ExportSettings.ExportOnlyData = true;
				RadGridDtl.ExportSettings.IgnorePaging = true;
				RadGridDtl.ExportSettings.OpenInNewWindow = true;
				RadGridDtl.ExportSettings.FileName = "BudgetEntry " + RadTextBoxEntryNum.Text;

				RadGridDtl.MasterTableView.Columns.FindByUniqueName("GLAccountForExport").Display = true;
				RadGridDtl.MasterTableView.Columns.FindByUniqueName("GLAccount").Display = false;

				RadGridDtl.MasterTableView.ExportToExcel();
			}
			catch (Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
		}

		protected void RadButtonUpload_Click(object sender, EventArgs e)
		{
			RadLabelMsg.Text = "";
			RadLabelErrorMsg.Text = "";

			if (RadTextBoxEntryNum.Text.Trim() == "")
			{
				RadLabelMsg.Text = "Invalid EntryNum!";
				return;
			}


			foreach (UploadedFile file in RadAsyncUploadDtl.UploadedFiles)
			{
				bool isTempFileThere;
				string tempFileName = string.Empty;

				//accessing the Name property tests the file internally (the stream behavior), so we need to try-catch this
				//try adding a TargetFolder setting to the async upload and you will see the difference in behavior
				try
				{
					// when we cast the stream, we need to dispose in order to be able to manipulate the file
					// otherwise, "The file is being used from another process" error will appear
					using (var filestream = file.InputStream as System.IO.FileStream)
					{
						tempFileName = filestream.Name;
						isTempFileThere = System.IO.File.Exists(tempFileName);

						//RadLabelMsg.Text += tempFileName + "</br>";
					}

					if (isTempFileThere)
					{
						Telerik.Windows.Documents.Spreadsheet.Model.Workbook workbook;
						IWorkbookFormatProvider formatProvider = new Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx.XlsxFormatProvider();


						try
						{
							using (Stream input = new FileStream(tempFileName, FileMode.Open))
							{

								workbook = formatProvider.Import(input);								

								foreach (Worksheet ws in workbook.Worksheets)
								{
									DataTable dtXls = new DataTable();
									dtXls = GetUploadTable();

									List<string> ColNameList = new List<string>();


									CellRange usedCellRange = ws.UsedCellRange;
									for (int rowIndex = usedCellRange.FromIndex.RowIndex; rowIndex <= usedCellRange.ToIndex.RowIndex; rowIndex++)
									{
										//RadLabelMsg.Text += "Row:" + rowIndex + "</br>";

										//build column name list
										if (rowIndex == 0)
										{
											for (int columnIndex = usedCellRange.FromIndex.ColumnIndex; columnIndex <= usedCellRange.ToIndex.ColumnIndex; columnIndex++)
											{
												CellSelection cell = ws.Cells[rowIndex, columnIndex];
												ICellValue cellValue = cell.GetValue().Value;
												ColNameList.Add(cellValue.RawValue);
											}

											continue;
										}


										if (rowIndex > 0)
										{
											CellSelection cell = ws.Cells[rowIndex, 0];
											ICellValue cellValue = cell.GetValue().Value;
											if (cellValue.RawValue == "")
											{
												continue;
											}
										}

										DataRow dr = dtXls.NewRow();

										for (int columnIndex = usedCellRange.FromIndex.ColumnIndex; columnIndex <= usedCellRange.ToIndex.ColumnIndex; columnIndex++)
										{
											CellSelection cell = ws.Cells[rowIndex, columnIndex];

											ICellValue cellValue = cell.GetValue().Value;

											//RadLabelMsg.Text += cellValue.RawValue + "</br>";

											string ColName = ColNameList[columnIndex].ToString();
											if (dtXls.Columns.Contains(ColName))
											{
												dr[ColName] = cellValue.RawValue;
											}

										}

										dtXls.Rows.Add(dr);
									}

									if (dtXls.Rows.Count > 0)
									{
										string Company = RadTextBoxCompany.Text;
										string EntryNum = RadTextBoxEntryNum.Text;
										string Revision = RadTextBoxRevision.Text;
										UploadData(Company, EntryNum, Revision, dtXls);
									}

									//RadLabelMsg.Text += "OK";

									break;
								}

							}
						}
						catch (Exception ex)
						{
							RadLabelErrorMsg.Text = "<br />" + "RadButtonUpload_Click():"+ tempFileName +";" + ex.Message;
						}
					}

				}
				catch (System.IO.FileNotFoundException ex)
				{
					isTempFileThere = false;
					RadLabelErrorMsg.Text = "FileNotFoundException:" + ex.Message.ToString();
				}

				if (isTempFileThere)
				{
					//System.IO.File.Delete(tempFileName);
				}
			}



		}

		private DataTable GetUploadTable()
		{
			DataTable dt = new DataTable();

			dt.Columns.Add("Line", typeof(string));
			dt.Columns.Add("Budget_Item", typeof(string));
			dt.Columns.Add("GLAccount", typeof(string));
			dt.Columns.Add("AccountDesc", typeof(string));
			dt.Columns.Add("SegValue1", typeof(string));
			dt.Columns.Add("SegValue2", typeof(string));
			dt.Columns.Add("SegValue3", typeof(string));
			dt.Columns.Add("SegValue4", typeof(string));
			dt.Columns.Add("SegValue5", typeof(string));
			dt.Columns.Add("SegValue6", typeof(string));
			dt.Columns.Add("SegValue7", typeof(string));
			dt.Columns.Add("SegValue8", typeof(string));
			dt.Columns.Add("SegValue9", typeof(string));
			dt.Columns.Add("SegValue10", typeof(string));
			dt.Columns.Add("Period_1", typeof(string));
			dt.Columns.Add("Period_2", typeof(string));
			dt.Columns.Add("Period_3", typeof(string));
			dt.Columns.Add("Period_4", typeof(string));
			dt.Columns.Add("Period_5", typeof(string));
			dt.Columns.Add("Period_6", typeof(string));
			dt.Columns.Add("Period_7", typeof(string));
			dt.Columns.Add("Period_8", typeof(string));
			dt.Columns.Add("Period_9", typeof(string));
			dt.Columns.Add("Period_10", typeof(string));
			dt.Columns.Add("Period_11", typeof(string));
			dt.Columns.Add("Period_12", typeof(string));

			return dt;
		}

		protected void UploadData(string Company, string EntryNum, string Revision, DataTable dtXls)
		{
			ClassMain main = new ClassMain();

			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");

			try
			{

				string sql = "Update [BudgetPlanDtl] Set [Period_1]=@Period_1, [Period_2]=@Period_2, [Period_3]=@Period_3, [Period_4]=@Period_4, [Period_5]=@Period_5, [Period_6]=@Period_6, [Period_7]=@Period_7, [Period_8]=@Period_8, [Period_9]=@Period_9, [Period_10]=@Period_10, [Period_11]=@Period_11, [Period_12]=@Period_12 Where [Company]=@Company and [EntryNum]=@EntryNum and [Revision]=@Revision and Line=@Line";

				foreach (DataRow dr in dtXls.Rows)
				{
					DataRow[] drsG = pGLAccountList.Select("GLAccount='" + Convert.ToString(dr["GLAccount"]) + "' and COACode='" + Convert.ToString(RadComboBoxCOACode.SelectedValue) + "'");
					if (drsG.Length > 0)
					{
						DataRow drG = drsG[0];

						if (Convert.ToString(dr["AccountDesc"]).Trim() == "")
						{
							dr["AccountDesc"] = Convert.ToString(drG["AccountDesc"]);
						}
						if (Convert.ToString(dr["SegValue1"]).Trim() == "")
						{
							dr["SegValue1"] = Convert.ToString(drG["SegValue1"]);
						}
						if (Convert.ToString(dr["SegValue2"]).Trim() == "")
						{
							dr["SegValue2"] = Convert.ToString(drG["SegValue2"]);
						}
						if (Convert.ToString(dr["SegValue3"]).Trim() == "")
						{
							dr["SegValue3"] = Convert.ToString(drG["SegValue3"]);
						}
						if (Convert.ToString(dr["SegValue4"]).Trim() == "")
						{
							dr["SegValue4"] = Convert.ToString(drG["SegValue4"]);
						}
						if (Convert.ToString(dr["SegValue5"]).Trim() == "")
						{
							dr["SegValue5"] = Convert.ToString(drG["SegValue5"]);
						}
					}


					SqlCommand cmd1 = new SqlCommand();
					cmd1.CommandText = sql;
					cmd1.CommandTimeout = 3600;
					cmd1.Parameters.Add(new SqlParameter("@Company", Company));
					cmd1.Parameters.Add(new SqlParameter("@EntryNum", EntryNum));
					cmd1.Parameters.Add(new SqlParameter("@Revision", Revision));
					cmd1.Parameters.Add(new SqlParameter("@Line", Convert.ToString(dr["Line"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_1", Convert.ToString(dr["Period_1"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_1"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_2", Convert.ToString(dr["Period_2"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_2"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_3", Convert.ToString(dr["Period_3"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_3"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_4", Convert.ToString(dr["Period_4"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_4"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_5", Convert.ToString(dr["Period_5"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_5"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_6", Convert.ToString(dr["Period_6"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_6"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_7", Convert.ToString(dr["Period_7"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_7"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_8", Convert.ToString(dr["Period_8"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_8"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_9", Convert.ToString(dr["Period_9"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_9"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_10", Convert.ToString(dr["Period_10"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_10"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_11", Convert.ToString(dr["Period_11"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_11"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_12", Convert.ToString(dr["Period_12"]).Trim() == "" ? "0" : Convert.ToString(dr["Period_12"])));

					ExMsg = "";
					int UpdateRows = main.UpdateBySQL(cmd1, ref ExMsg);

					if (ExMsg != "")
						ExMsgList.Append("<br />" + "Update Error:" + ExMsg);
				}

				//Load data after upload detail
				BudgetPlan_GetByID(Company, EntryNum, Revision);
			}
			catch (Exception ex)
			{
				ExMsgList.Append("<br />UploadData():" + ex.Message);
			}
			finally
			{
				RadLabelErrorMsg.Text = ExMsgList.ToString();
			}
		}

		protected void RadAsyncUploadDtl_FileUploaded(object sender, FileUploadedEventArgs e)
		{

		}
	}
}