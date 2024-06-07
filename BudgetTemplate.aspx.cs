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
    public partial class BudgetTemplate : System.Web.UI.Page
    {
		protected static DataTable pGLAccountList;

        protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{
				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "Budget Template";

				//RadTextBoxUserID.Text = "epicor";
				//RadTextBoxCurrentCompany.Text = "BGCA";
				//RadTextBoxCurrentCompanyName.Text = "BGCA";

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

				BudgetTemplate_GetByID("COMPANY", "TemplateNum");

				SqlDataSourceSearchTemplateHed.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceSearchTemplateHed.SelectParameters["CreatedBy"].DefaultValue = RadTextBoxUserID.Text;
				SqlDataSourceCOACode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBookID.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceFiscalYear.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBudgetCode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;

				//string COACode = "MAIN";
				//Set_SqlDataSourceSegValuePara(RadTextBoxCurrentCompany.Text, COACode);
				//this.RadGridDtl.DataBind();

				string Msg = "";

				string sql = "select replace(GLAccount,'|','-') as GLAccount,AccountDesc,COACode,SegValue1,SegValue2,SegValue3,SegValue4,SegValue5,SegValue6,SegValue7,SegValue8,SegValue9,SegValue10 from erp.GLAccount where Company=@Company";

				ClassEpicor cEpicor = new ClassEpicor();

				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sql;
				cmd.Parameters.Add(new SqlParameter("@Company", RadTextBoxCurrentCompany.Text));

				DataTable dt = cEpicor.GetData(cmd, ref Msg);
				RadLabelMsg.Text = Msg;				

				pGLAccountList = dt;

				
			}
		}

		protected void RadButtonSearch_Click(object sender, EventArgs e)
		{
			RadLabelErrorMsg.Text = "";
			RadLabelMsg.Text = "";

			this.SqlDataSourceSearchTemplateHed.DataBind();
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
					string TemplateNum = item.GetDataKeyValue("TemplateNum").ToString();

					BudgetTemplate_GetByID(Company, TemplateNum);
				}

				RadGridSearch.Visible = false;
			}

			if (e.CommandName == "RadButtonSearchCancel")
			{
				RadGridSearch.Visible = false;
			}
		}

		protected void BudgetTemplate_GetByID(string Company, string TemplateNum)
		{
			string sql = "";

			sql = "select * from BudgetTemplateHed where Company='" + Company + "' and TemplateNum='" + TemplateNum + "'" ;

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
			RadTextBoxTemplateNum.Text = Convert.ToString(dtHed.Rows[0]["TemplateNum"]);
			RadTextBoxCreatedBy.Text = Convert.ToString(dtHed.Rows[0]["CreatedBy"]);
			RadComboBoxCOACode.Text = "";
			RadComboBoxCOACode.SelectedValue = Convert.ToString(dtHed.Rows[0]["COACode"]);
			RadComboBoxBookID.Text = "";
			RadComboBoxBookID.SelectedValue = Convert.ToString(dtHed.Rows[0]["BookID"]);
			RadComboBoxFiscalYear.Text = "";
			RadComboBoxFiscalYear.SelectedValue = Convert.ToString(dtHed.Rows[0]["FiscalYear"]);
			RadComboBoxBudgetCode.Text = "";
			RadComboBoxBudgetCode.SelectedValue = Convert.ToString(dtHed.Rows[0]["BudgetCode"]);
			
			this.SqlDataSourceDtl.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceDtl.SelectParameters["TemplateNum"].DefaultValue = TemplateNum;

			this.SqlDataSourceDtl.DataBind();

			//Set_SqlDataSourceSegValuePara(RadTextBoxCompany.Text, RadComboBoxCOACode.SelectedValue.ToString());

			this.RadGridDtl.DataBind();

			RadTextBoxTemplateNum.ReadOnly = true;
		}

		

		protected void RadButtonNew_Click(object sender, EventArgs e)
		{
			string Company = "Company";
			string TemplateNum = "TemplateNum";
			BudgetTemplate_GetNewHed(Company, TemplateNum);
		}

		protected void BudgetTemplate_GetNewHed(string Company, string TemplateNum)
		{
			string sql = "";

			sql = "select * from BudgetTemplateHed where Company='" + Company + "' and TemplateNum='" + TemplateNum + "'";

			ClassMain main = new ClassMain();
			string Msg = "";

			DataTable dtHed = main.GetSQLtb(sql, ref Msg);
			RadLabelErrorMsg.Text = Msg;

			//get default COA, select MasterCOA,* from erp.GLSyst where Company='epic06'
			string DefCOA = "", DefBookID = "";

			sql = "select A.Company,A.MasterCOA,B.BookID from erp.GLSyst A, erp.GLBook B where A.Company=B.Company and B.MainBook=1 and A.Company=@Company";

			ClassEpicor cEpicor = new ClassEpicor();

			SqlCommand cmd = new SqlCommand();
			cmd.CommandText = sql;
			cmd.Parameters.Add(new SqlParameter("@Company", RadTextBoxCurrentCompany.Text));

			DataTable dtEpicor = cEpicor.GetData(cmd, ref Msg);
			RadLabelErrorMsg.Text += Msg;

			if(dtEpicor !=null && dtEpicor.Rows.Count>0)
			{
				DefCOA = dtEpicor.Rows[0]["MasterCOA"].ToString();
				DefBookID = dtEpicor.Rows[0]["BookID"].ToString();
			}

			if (dtHed != null && dtHed.Rows.Count == 0)
			{
				DataRow dr = dtHed.NewRow();
				dr["Company"] = RadTextBoxCurrentCompany.Text;
				dr["CreatedBy"] = RadTextBoxUserID.Text;

				dr["COACode"] = DefCOA;
				dr["BookID"] = DefBookID;

				dtHed.Rows.Add(dr);
			}

			RadTextBoxCompany.Text = Convert.ToString(dtHed.Rows[0]["Company"]);
			RadTextBoxTemplateNum.Text = Convert.ToString(dtHed.Rows[0]["TemplateNum"]);
			RadTextBoxCreatedBy.Text = Convert.ToString(dtHed.Rows[0]["CreatedBy"]);
			RadComboBoxCOACode.Text = "";
			RadComboBoxCOACode.SelectedValue = Convert.ToString(dtHed.Rows[0]["COACode"]);
			RadComboBoxBookID.Text = "";
			RadComboBoxBookID.SelectedValue = Convert.ToString(dtHed.Rows[0]["BookID"]);
			RadComboBoxFiscalYear.Text = "";
			RadComboBoxFiscalYear.SelectedValue = Convert.ToString(dtHed.Rows[0]["FiscalYear"]);
			RadComboBoxBudgetCode.SelectedValue = Convert.ToString(dtHed.Rows[0]["BudgetCode"]);

			this.SqlDataSourceDtl.SelectParameters["Company"].DefaultValue = Company;
			this.SqlDataSourceDtl.SelectParameters["TemplateNum"].DefaultValue = TemplateNum;

			this.SqlDataSourceDtl.DataBind();
			this.RadGridDtl.DataBind();

			//string COACode = "MAIN";
			//Set_SqlDataSourceSegValuePara(RadTextBoxCurrentCompany.Text, COACode);
			

			RadTextBoxTemplateNum.ReadOnly = false;
		}

		protected void RadButtonSave_Click(object sender, EventArgs e)
		{
			try
			{
				if(RadTextBoxTemplateNum.Text.Trim()=="")
				{
					RadLabelMsg.Text = "Invalid TemplateNum!";
					return;
				}

				bool IsNewHed = false;

				string sql = "";

				sql = "select * from BudgetTemplateHed where Company='' and TemplateNum=''";

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
				dtHed.Rows[0]["TemplateNum"] = RadTextBoxTemplateNum.Text;
				dtHed.Rows[0]["COACode"] = RadComboBoxCOACode.SelectedValue;
				dtHed.Rows[0]["BookID"] = RadComboBoxBookID.SelectedValue;
				dtHed.Rows[0]["FiscalYear"] = RadComboBoxFiscalYear.SelectedValue;
				dtHed.Rows[0]["BudgetCode"] = RadComboBoxBudgetCode.SelectedValue;
				dtHed.Rows[0]["CreatedBy"] = RadTextBoxUserID.Text;
				dtHed.Rows[0]["CreatedDate"] = DateTime.Now.Date;
				dtHed.Rows[0]["ChangedBy"] = RadTextBoxUserID.Text;
				dtHed.Rows[0]["ChangedDate"] = DateTime.Now.Date;


				Msg = "";
				BudgetTemplate_UpdateHed(dtHed.Rows[0], ref Msg);
				RadLabelErrorMsg.Text = Msg;

				RadLabelMsg.Text = "Entry# saved.";

				if(IsNewHed)
				{
					BudgetTemplate_GetByID(RadTextBoxCompany.Text, RadTextBoxTemplateNum.Text);
				}

				RadTextBoxTemplateNum.ReadOnly = true;
			}
			catch(Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
			
		}

		protected void BudgetTemplate_UpdateHed(DataRow drSave, ref string Msg)
		{
			try
			{
				string sql = "", Company = "", TemplateNum = "", CreatedBy = "";
				DateTime CreatedDate;

				Company = Convert.ToString(drSave["Company"]);
				TemplateNum = Convert.ToString(drSave["TemplateNum"]);
				CreatedBy = Convert.ToString(drSave["CreatedBy"]);
				CreatedDate = Convert.ToDateTime(drSave["CreatedDate"]);

				sql = "select * from BudgetTemplateHed where Company='" + Company + "' and TemplateNum='" + TemplateNum + "'";

				ClassMain main = new ClassMain();

				DataTable dtHed = main.GetSQLtb(sql, ref Msg);

				if (dtHed != null && dtHed.Rows.Count == 0)
				{
					
					SqlCommand cmd1 = new SqlCommand();
					cmd1.CommandText = "insert into BudgetTemplateHed(Company,TemplateNum,CreatedBy,CreatedDate) Values (@Company,@TemplateNum,@CreatedBy,@CreatedDate)";
					cmd1.CommandTimeout = 3600;
					cmd1.Parameters.Add(new SqlParameter("@Company", Company));
					cmd1.Parameters.Add(new SqlParameter("@TemplateNum", TemplateNum));
					cmd1.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
					cmd1.Parameters.Add(new SqlParameter("@CreatedDate", CreatedDate.ToString("yyyy-MM-dd")));

					string Msg1 = "";
					int UpdateRows1 = main.UpdateBySQL(cmd1, ref Msg1);
					
					/*
					string Msg1 = "";
					sql = "insert into BudgetTemplateHed(Company,TemplateNum,CreatedBy,CreatedDate) Values ('"+ Company + "','"+ TemplateNum + "','"+ CreatedBy + "','"+ CreatedDate.ToString("yyyy-MM-dd") + "')";
					main.RunSQL(sql, ref Msg1);
					*/

					if (Msg1 != "")
						Msg += "Insert Error:" + Msg1;

				}


				
				SqlCommand cmd2 = new SqlCommand();
				cmd2.CommandText = "update BudgetTemplateHed set [COACode] = @COACode, [BookID] = @BookID, [FiscalYear] = @FiscalYear, [BudgetCode] = @BudgetCode, [ChangedBy] = @ChangedBy, [ChangedDate] = @ChangedDate where [Company] = @Company and [TemplateNum] = @TemplateNum";
				cmd2.CommandTimeout = 3600;
				cmd2.Parameters.Add(new SqlParameter("@Company", Convert.ToString(drSave["Company"])));
				cmd2.Parameters.Add(new SqlParameter("@TemplateNum", Convert.ToString(drSave["TemplateNum"])));
				cmd2.Parameters.Add(new SqlParameter("@COACode", Convert.ToString(drSave["COACode"])));
				cmd2.Parameters.Add(new SqlParameter("@BookID", Convert.ToString(drSave["BookID"])));
				cmd2.Parameters.Add(new SqlParameter("@FiscalYear", Convert.ToString(drSave["FiscalYear"])));
				cmd2.Parameters.Add(new SqlParameter("@BudgetCode", Convert.ToString(drSave["BudgetCode"])));
				cmd2.Parameters.Add(new SqlParameter("@ChangedBy", Convert.ToString(drSave["ChangedBy"])));
				cmd2.Parameters.Add(new SqlParameter("@ChangedDate", Convert.ToDateTime(drSave["ChangedDate"]).ToString("yyyy-MM-dd")));
				

				string Msg2 = "";
				int UpdateRows2 = main.UpdateBySQL(cmd2, ref Msg2);
				
				/*
				string Msg2 = "";
				sql = "update BudgetTemplateHed set [COACode] = '"+ Convert.ToString(drSave["COACode"]) + "', [BookID] = '"+ Convert.ToString(drSave["BookID"]) + "', [FiscalYear] = "+ Convert.ToString(drSave["FiscalYear"]) + ", [BudgetCode] = '"+ Convert.ToString(drSave["BudgetCode"]) + "', [ChangedBy] = '"+ Convert.ToString(drSave["ChangedBy"]) + "', [ChangedDate] = '"+ Convert.ToDateTime(drSave["ChangedDate"]).ToString("yyyy-MM-dd") + "' where [Company] = '"+ Convert.ToString(drSave["Company"]) + "' and [TemplateNum] = '"+ Convert.ToString(drSave["TemplateNum"]) + "'";				
				main.RunSQL(sql, ref Msg2);
				*/

				/*
				Msg = "";
				//string debugTxt = "update DebugTest set TestValue='" + sql.Replace("'","''") + "'";
				string debugTxt = "insert DebugTest(ID,TestValue)values('Tempupdate','" + sql.Replace("'", "''") + "')";
				main.RunSQL(debugTxt, ref Msg);
				*/

				if (Msg2 != "")
					Msg += "Update Error:" + Msg2;
			}
			catch(Exception ex)
			{
				Msg += "Update Error:" + ex.Message;
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
				/*
				foreach (DataRow dr in pGLAccountList.Rows)
				{
					if (paramGLA == Convert.ToString(dr["GLAccount"]) && paramCOACode == Convert.ToString(dr["COACode"]))
					{
						//AccountDesc = Convert.ToString(dr["AccountDesc"]);
						rtValueList = Convert.ToString(dr["AccountDesc"]) + "~" + Convert.ToString(dr["SegValue1"]) + "~" + Convert.ToString(dr["SegValue2"]) + "~" + Convert.ToString(dr["SegValue3"]);
						break;
					}

				}
				*/

				DataRow[] drs = pGLAccountList.Select("GLAccount='" + paramGLA + "' and COACode='" + paramCOACode + "'");
				if (drs.Length > 0)
				{
					DataRow dr = drs[0];
					rtValueList = Convert.ToString(dr["AccountDesc"]) + "~" + Convert.ToString(dr["SegValue1"]) + "~" + Convert.ToString(dr["SegValue2"]) + "~" + Convert.ToString(dr["SegValue3"]);
				}
				else
				{
					rtValueList = "GLAccount not found~~~";
				}
			}
			else
			{
				rtValueList = "GLAccount List Null~~~";
			}

			//return AccountDesc;
			return rtValueList;
		}

		protected void RadComboBoxCOACode_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
		{
			//OnSelectedIndexChanged="RadComboBoxCOACode_SelectedIndexChanged"

			//Set_SqlDataSourceSegValuePara(RadTextBoxCompany.Text, RadComboBoxCOACode.SelectedValue.ToString());
			//this.RadGridDtl.DataBind();
		}

		protected void Set_SqlDataSourceSegValuePara(string Company, string COACode)
		{
			/*
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
			*/
			//this.RadGridDtl.DataBind();
		}



		protected void RadButtonDelete_Click(object sender, EventArgs e)
		{
			string TemplateNum = RadTextBoxTemplateNum.Text;

			ClassMain main = new ClassMain();
			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");
			string sql = "";

			try
			{
				sql = "delete from BudgetTemplateHed where Company='" + RadTextBoxCompany.Text + "' and TemplateNum='" + RadTextBoxTemplateNum.Text + "'";

				int i = main.RunSQL(sql, ref ExMsg);

				if (ExMsg != "")
					ExMsgList.Append("<br />" + ExMsg);

				sql = "delete from BudgetTemplateDtl where Company='" + RadTextBoxCompany.Text + "' and TemplateNum='" + RadTextBoxTemplateNum.Text + "'";

				int j = main.RunSQL(sql, ref ExMsg);

				if (ExMsg != "")
					ExMsgList.Append("<br />" + ExMsg);

				BudgetTemplate_GetByID("COMPANY", "TemplateNum");

				RadLabelMsg.Text = "TemplateNum:"+ TemplateNum + " has been deleted!";
			}
			catch(Exception ex)
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
				RadGridDtl.ExportSettings.FileName = "BudgetTemplate " + RadTextBoxTemplateNum.Text;

				RadGridDtl.MasterTableView.Columns.FindByUniqueName("GLAccountForExport").Display = true;
				RadGridDtl.MasterTableView.Columns.FindByUniqueName("GLAccount").Display = false;

				RadGridDtl.MasterTableView.ExportToExcel();
			}
			catch(Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
			
		}

		protected void RadButtonUpload_Click(object sender, EventArgs e)
		{
			RadLabelMsg.Text = "";
			RadLabelErrorMsg.Text = "";

			if (RadTextBoxTemplateNum.Text.Trim()=="")
			{
				RadLabelMsg.Text = "Invalid TemplateNum!";
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

					if(isTempFileThere)
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
										string TemplateNum = RadTextBoxTemplateNum.Text;
										UploadData(Company, TemplateNum, dtXls);
									}

									//RadLabelMsg.Text += "OK";

									break;
								}

							}
						}
						catch (Exception ex)
						{
							RadLabelErrorMsg.Text = "<br />" + "RadButtonUpload_Click():" + ex.Message;
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

		protected void UploadData(string Company,string TemplateNum,DataTable dtXls)
		{
			ClassMain main = new ClassMain();

			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");

			try
			{
				string sqlDel = "delete from BudgetTemplateDtl where Company=@Company and TemplateNum=@TemplateNum";

				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sqlDel;
				cmd.CommandTimeout = 3600;
				cmd.Parameters.Add(new SqlParameter("@Company", Company));
				cmd.Parameters.Add(new SqlParameter("@TemplateNum", TemplateNum));

				int UpdateRows = main.UpdateBySQL(cmd, ref ExMsg);

				if (ExMsg != "")
					ExMsgList.Append("<br />" + "Delete Error:" + ExMsg);

				string sql = "INSERT INTO [BudgetTemplateDtl] ([Company], [TemplateNum], [Line], [Budget_Item], [Period_1], [Period_2], [Period_3], [Period_4], [Period_5], [Period_6], [Period_7], [Period_8], [Period_9], [Period_10], [Period_11], [Period_12], [GLAccount], [AccountDesc], [SegValue1], [SegValue2], [SegValue3], [SegValue4], [SegValue5], [SegValue6], [SegValue7], [SegValue8], [SegValue9], [SegValue10]) VALUES (@Company, @TemplateNum, @Line, @Budget_Item, @Period_1, @Period_2, @Period_3, @Period_4, @Period_5, @Period_6, @Period_7, @Period_8, @Period_9, @Period_10, @Period_11, @Period_12, @GLAccount, @AccountDesc, @SegValue1, @SegValue2, @SegValue3, @SegValue4, @SegValue5, @SegValue6, @SegValue7, @SegValue8, @SegValue9, @SegValue10)";

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
					cmd1.Parameters.Add(new SqlParameter("@TemplateNum", TemplateNum));
					cmd1.Parameters.Add(new SqlParameter("@Line", Convert.ToString(dr["Line"])));
					cmd1.Parameters.Add(new SqlParameter("@Budget_Item", Convert.ToString(dr["Budget_Item"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_1", Convert.ToString(dr["Period_1"]) == "" ? "0" : Convert.ToString(dr["Period_1"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_2", Convert.ToString(dr["Period_2"]) == "" ? "0" : Convert.ToString(dr["Period_2"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_3", Convert.ToString(dr["Period_3"]) == "" ? "0" : Convert.ToString(dr["Period_3"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_4", Convert.ToString(dr["Period_4"]) == "" ? "0" : Convert.ToString(dr["Period_4"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_5", Convert.ToString(dr["Period_5"]) == "" ? "0" : Convert.ToString(dr["Period_5"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_6", Convert.ToString(dr["Period_6"]) == "" ? "0" : Convert.ToString(dr["Period_6"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_7", Convert.ToString(dr["Period_7"]) == "" ? "0" : Convert.ToString(dr["Period_7"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_8", Convert.ToString(dr["Period_8"]) == "" ? "0" : Convert.ToString(dr["Period_8"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_9", Convert.ToString(dr["Period_9"]) == "" ? "0" : Convert.ToString(dr["Period_9"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_10", Convert.ToString(dr["Period_10"]) == "" ? "0" : Convert.ToString(dr["Period_10"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_11", Convert.ToString(dr["Period_11"]) == "" ? "0" : Convert.ToString(dr["Period_11"])));
					cmd1.Parameters.Add(new SqlParameter("@Period_12", Convert.ToString(dr["Period_12"]) == "" ? "0" : Convert.ToString(dr["Period_12"])));
					cmd1.Parameters.Add(new SqlParameter("@GLAccount", Convert.ToString(dr["GLAccount"])));
					cmd1.Parameters.Add(new SqlParameter("@AccountDesc", Convert.ToString(dr["AccountDesc"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue1", Convert.ToString(dr["SegValue1"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue2", Convert.ToString(dr["SegValue2"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue3", Convert.ToString(dr["SegValue3"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue4", Convert.ToString(dr["SegValue4"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue5", Convert.ToString(dr["SegValue5"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue6", Convert.ToString(dr["SegValue6"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue7", Convert.ToString(dr["SegValue7"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue8", Convert.ToString(dr["SegValue8"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue9", Convert.ToString(dr["SegValue9"])));
					cmd1.Parameters.Add(new SqlParameter("@SegValue10", Convert.ToString(dr["SegValue10"])));

					ExMsg = "";
					UpdateRows = main.UpdateBySQL(cmd1, ref ExMsg);

					if (ExMsg != "")
						ExMsgList.Append("<br />" + "Insert Error:" + ExMsg);
				}

				//Load data after upload detail
				BudgetTemplate_GetByID(Company, TemplateNum);
			}
			catch(Exception ex)
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