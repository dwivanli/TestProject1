using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Telerik.Web.UI;

using System.Data;
using System.Data.SqlClient;

using Ice.Core;
using Ice.Lib.Framework;
using Ice.Lib;
using Erp.BO;
using Erp.Adapters;
using Telerik.Web.UI.com.hisoftware.api2;
using System.Text;
using Telerik.Web.UI.Skins;

namespace BudgetPlan
{
    public partial class UploadToEpicor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{
				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "UploadToEpicor";

				HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
				if (htcoUserLoginID != null)
				{
					RadTextBoxUserID.Text = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
					
				}

				if(RadTextBoxUserID.Text == "")
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

				SqlDataSourceSearchPlanHed.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceSearchPlanHed.SelectParameters["FiscalYear"].DefaultValue = "0";
				SqlDataSourceSearchPlanHed.SelectParameters["BudgetCode"].DefaultValue = "ZZZZZZZ";

				SqlDataSourceFiscalYear.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceBudgetCode.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;

				SqlDataSourceDtl.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
				SqlDataSourceDtl.SelectParameters["FiscalYear"].DefaultValue = "0";
				SqlDataSourceDtl.SelectParameters["BudgetCode"].DefaultValue = "ZZZZZZZ";


			}
		}

		protected void RadButtonSearch_Click(object sender, EventArgs e)
		{
			RadLabelErrorMsg.Text = "";
			RadLabelMsg.Text = "";
			RadLabelUploadToEpicorMsg.Text = "";

			SqlDataSourceSearchPlanHed.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
			SqlDataSourceSearchPlanHed.SelectParameters["FiscalYear"].DefaultValue = RadComboBoxFiscalYear.SelectedValue.ToString();
			SqlDataSourceSearchPlanHed.SelectParameters["BudgetCode"].DefaultValue = RadComboBoxBudgetCode.SelectedValue.ToString();

			this.SqlDataSourceSearchPlanHed.DataBind();
			this.RadGridSearch.Rebind();

			SqlDataSourceDtl.SelectParameters["Company"].DefaultValue = RadTextBoxCurrentCompany.Text;
			SqlDataSourceDtl.SelectParameters["FiscalYear"].DefaultValue = RadComboBoxFiscalYear.SelectedValue.ToString();
			SqlDataSourceDtl.SelectParameters["BudgetCode"].DefaultValue = RadComboBoxBudgetCode.SelectedValue.ToString();

			this.SqlDataSourceDtl.DataBind();
			this.RadGridDtl.Rebind();


			StringBuilder MsgList = new StringBuilder("");
			string Msg = "";


			string sql = "";

			sql = "select * from vw_BudgetApprovedSummary where Company='" + RadTextBoxCurrentCompany.Text + "' and BudgetCode='" + RadComboBoxBudgetCode.SelectedValue.ToString() + "' and FiscalYear=" + RadComboBoxFiscalYear.SelectedValue.ToString();
			ClassMain main = new ClassMain();
			DataTable dtBGSum = main.GetSQLtb(sql, ref Msg);
			if (Msg != "")
				MsgList.Append("<br />" + Msg.ToString());

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
				}

			}

		}

		protected void RadButtonUploadToEpicor_Click(object sender, EventArgs e)
		{
			ProcUploadToEpicor();

		}

		protected void ProcUploadToEpicor()
		{
			RadLabelMsg.Text = "";
			RadLabelErrorMsg.Text = "";
			RadLabelUploadToEpicorMsg.Text = "";


			StringBuilder MsgList = new StringBuilder("");
			string Msg = "";


			string sql = "";

			sql = "select * from vw_BudgetApprovedSummary where Company='" + RadTextBoxCurrentCompany.Text + "' and BudgetCode='" + RadComboBoxBudgetCode.SelectedValue.ToString() + "' and FiscalYear=" + RadComboBoxFiscalYear.SelectedValue.ToString() + " Order by FiscalYear,BudgetCode,AccountCode";
			ClassMain main = new ClassMain();
			DataTable dtBGSum = main.GetSQLtb(sql, ref Msg);
			if (Msg != "")
				MsgList.Append("<br />" + Msg.ToString());

			if (dtBGSum != null && dtBGSum.Rows.Count == 0)
			{
				RadLabelMsg.Text = "No budget summary need to upload to epicor.";
				return;
			}

			ILaunch IL = null;
			Ice.Core.Session newSession = null;

			string userID = System.Configuration.ConfigurationManager.AppSettings["EpicorUserID"];
			string password = System.Configuration.ConfigurationManager.AppSettings["EpicorPassword"];
			string appServerUrl = System.Configuration.ConfigurationManager.AppSettings["EpicorAppServerUrl"];

			try
			{
				//string pathToConfigurationFile = "D:\\Epicor\\ERP10\\LocalClients\\EPICORTRAIN\\Config\\EPICORTRAIN.sysconfig";
				string pathToConfigurationFile = System.Configuration.ConfigurationManager.AppSettings["pathToConfigurationFile"];
				newSession = new Session(userID, password, appServerUrl, Ice.Core.Session.LicenseType.WebService, pathToConfigurationFile);

				newSession.CompanyID = RadTextBoxCurrentCompany.Text;

				IL = new ILauncher(newSession);

				string bookID = Convert.ToString(dtBGSum.Rows[0]["BookID"]), balanceAcct = "1020|00|00", balanceType = "D", fiscalYearSuffix = "", fiscalCalendarID = "Main", budgetCodeID = Convert.ToString(dtBGSum.Rows[0]["BudgetCode"]);
				int fiscalYear = Convert.ToInt32(dtBGSum.Rows[0]["FiscalYear"]);
				fiscalCalendarID = System.Configuration.ConfigurationManager.AppSettings["fiscalCalendarID"];

				StringBuilder BOErrorMsg = new StringBuilder("");

				/*
				foreach (DataRow dr in dtBGSum.Rows)
				{
					bookID = Convert.ToString(dr["BookID"]);
					balanceAcct = Convert.ToString(dr["AccountCode"]).Replace("-","|");
					budgetCodeID = Convert.ToString(dr["BudgetCode"]);

					CreateAccountBudget(IL, dr, bookID, balanceAcct, balanceType, fiscalYear, fiscalYearSuffix, fiscalCalendarID, budgetCodeID, ref BOErrorMsg);

					if (BOErrorMsg.ToString() != "")
					{
						MsgList.Append("<br />" + BOErrorMsg.ToString());
					}

					PrgCount += 1;
					ValueProgressBar.Value = PrgCount;
				}
				*/

				string UploadMsg = "";
				DateTime StartTime = DateTime.Now;

				CreateAccountBudget2(IL, dtBGSum, bookID, balanceAcct, balanceType, fiscalYear, fiscalYearSuffix, fiscalCalendarID, budgetCodeID, ref BOErrorMsg, ref UploadMsg);
				//TestProgressBar(dtBGSum, fiscalYear, budgetCodeID, ref BOErrorMsg, ref UploadMsg);

				DateTime EndTime = DateTime.Now;

				TimeSpan minuteSpan = new TimeSpan(StartTime.Ticks - EndTime.Ticks);
				double DiffMinutes = minuteSpan.TotalMinutes;

				if (BOErrorMsg.ToString() != "")
				{
					MsgList.Append("<br />" + BOErrorMsg.ToString());
				}

				if (BOErrorMsg.ToString() == "")
				{
					RadLabelUploadToEpicorMsg.Text = "Upload Done. " + UploadMsg + "    Elapsed time: " + StartTime.ToString("yyyy-MM-dd HH:mm:ss") + " >>> " + EndTime.ToString("yyyy-MM-dd HH:mm:ss");
				}

			}
			catch (Exception ex)
			{
				//RadLabelErrorMsg.Text = ex.Message.ToString();
				//MsgList.Append("<br />" + ex.Message.ToString());
				MsgList.Append("<br />" + "ProcUploadToEpicor() Exception:" + ex.ToString());
			}
			finally
			{

				if (newSession != null)
				{
					newSession.OnSessionClosing();
					newSession.Dispose();
				}

				RadLabelErrorMsg.Text = "<br />" + MsgList.ToString();
			}
		}

		protected void CreateAccountBudget2(ILaunch IL, DataTable dtBGSum, string bookID, string balanceAcct, string balanceType, int fiscalYear, string fiscalYearSuffix, string fiscalCalendarID, string budgetCodeID, ref StringBuilder BOErrorMsg, ref string UploadMsg)
		{
			RadProgressContext progress = RadProgressContext.Current;

			progress.CurrentOperationText = "Ready to start......";
			progress.PrimaryTotal = dtBGSum.Rows.Count;
			progress.PrimaryValue = 0;

			progress.SecondaryTotal = dtBGSum.Rows.Count;
			progress.SecondaryValue = 0;

			progress.PrimaryPercent = 0;
			progress.SecondaryPercent = 0;

			System.Threading.Thread.Sleep(5000); //5 second

			ClassMain main = new ClassMain();
			ClassEpicor mainEpicor = new ClassEpicor();
			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");
			string sql = "";

			AccountBudgetAdapter ABAdp = new AccountBudgetAdapter(IL);
			ABAdp.BOConnect();

			string ProcRecordText = "";

			string LogSQLStr = "insert UploadToEpicorLog (BatchNum,BatchLine,Company,FiscalYear,BudgetCode,AccountNum,Comment,UploadBy,UploadRuntime) values (";

			string BatchNum = DateTime.Now.ToString("yyyyMMdd-HHmmss");
			int line = 0;
			string Comment = "";

			try
			{
				

				sql = "select * from erp.GLBudgetHd where Company=@Company and BookID=@BookID and FiscalYear=@FiscalYear and FiscalYearSuffix=@FiscalYearSuffix and BudgetCodeID=@BudgetCodeID";

				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sql;
				cmd.CommandType = CommandType.Text;
				cmd.CommandTimeout = 3600;
				cmd.Parameters.AddWithValue("@Company", RadTextBoxCurrentCompany.Text);
				cmd.Parameters.AddWithValue("@BookID", bookID);
				cmd.Parameters.AddWithValue("@FiscalYear", fiscalYear.ToString());
				cmd.Parameters.AddWithValue("@FiscalYearSuffix", fiscalYearSuffix);
				cmd.Parameters.AddWithValue("@BudgetCodeID", budgetCodeID);

				DataTable dt = mainEpicor.GetData(cmd, ref ExMsg);

				if (ExMsg != "")
					BOErrorMsg.Append(ExMsg + "<br />" + sql + "<br />");

				if (dt.Rows.Count > 0)
				{
					progress.CurrentOperationText = "Clear existing budget......";
					ABAdp.DeleteBudget(bookID, budgetCodeID, fiscalYear, fiscalYearSuffix);
				}

				decimal p = 0;
				int PrgCount = 1, pi = 0, UploadedCount = 1;
				//RadProgressContext progress = RadProgressContext.Current;
				progress.Speed = "N/A";
				int Total = dtBGSum.Rows.Count;

				foreach (DataRow dr in dtBGSum.Rows)
				{
					bookID = Convert.ToString(dr["BookID"]);
					balanceAcct = Convert.ToString(dr["AccountCode"]).Replace("-", "|");
					budgetCodeID = Convert.ToString(dr["BudgetCode"]);

					ProcRecordText = balanceAcct;
					progress.CurrentOperationText = "Row " + PrgCount.ToString() + "  AccountCode:" + ProcRecordText;

					decimal budgetAmt = 0, budgetStatAmt = 0;
					
					Comment = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss fff") + " Start," ;

					ABAdp.GetNewGLBudgetHd(bookID, balanceAcct, balanceType, fiscalYear, fiscalYearSuffix, fiscalCalendarID, budgetCodeID);
					Comment += DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss fff")+" GetNewGLBudgetHd,";
					ABAdp.ValidateGLAccount(bookID, budgetCodeID, balanceAcct, balanceType, fiscalYear, fiscalYearSuffix, budgetAmt, budgetStatAmt);
					Comment += DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss fff") + " ValidateGLAccount,";
					ABAdp.ChangeBalanceAcct();
					Comment += DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss fff")+" ChangeBalanceAcct,";
					ABAdp.Update();
					Comment += DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss fff")+" ABAdp.Update() GetNewGLBudgetHd,";
					Comment += "GLBudgetDtl Rows: " + ABAdp.AccountBudgetData.Tables["GLBudgetDtl"].Rows.Count.ToString() + ",";

					DataRow[] drDs = null;
					string wClause = string.Format("BookID='{0}' and BalanceAcct='{1}' and BalanceType='D' and FiscalYear='{2}' and  FiscalYearSuffix='{3}' and BudgetCodeID='{4}'", new object[] { bookID, balanceAcct, fiscalYear, fiscalYearSuffix, budgetCodeID });
					drDs = ABAdp.AccountBudgetData.Tables["GLBudgetDtl"].Select(wClause);
					foreach (DataRow drD in drDs)
					{
						if (Convert.ToInt32(drD["FiscalPeriod"]) <= 12)
						{
							drD["BudgetAmt"] = dr["Period_" + Convert.ToInt32(drD["FiscalPeriod"]).ToString()];
							//drD["RowMod"] = "U";
							ABAdp.ChangeDtlBudgetAmt();
							Comment += DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss fff") + " P" + Convert.ToString(drD["FiscalPeriod"]) + " ABAdp.ChangeDtlBudgetAmt(),";
							ABAdp.Update();
							Comment += DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss fff")+" ABAdp.Update() GLBudgetDtl,";
						}
					}

					ABAdp.ClearData();

					//write log
					line++;
					sql = LogSQLStr + "'" + BatchNum + "'," + line.ToString() + ",'" + RadTextBoxCurrentCompany.Text + "'," + fiscalYear.ToString() + ",'" + budgetCodeID + "','" + balanceAcct + "','" + Comment + "','" + RadTextBoxUserID.Text + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')";
					int i = main.RunSQL(sql, ref ExMsg);
					if (ExMsg != "")
					{
						ExMsgList.Append(ExMsg + "<br />" + sql + "<br />");
						break;
					}


					UploadedCount = PrgCount;

					progress.PrimaryTotal = Total;
					progress.PrimaryValue = PrgCount;					

					progress.SecondaryTotal = Total;
					progress.SecondaryValue = PrgCount;					

					//cal percent count num
					p = Convert.ToDecimal(PrgCount) / Convert.ToDecimal(Total) * 100m;
					pi = Convert.ToInt32(Math.Floor(p));

					progress.PrimaryPercent = pi;
					progress.SecondaryPercent = pi;

					PrgCount += 1;

					//for RadProgressArea1 cancel button
					if (!Response.IsClientConnected)
					{
						//Cancel button was clicked or the browser was closed, so stop processing
						break;
					}

					//Stall the current thread for 0.1 seconds
					System.Threading.Thread.Sleep(100);
				}

				UploadMsg = "Uploaded total rows: " + UploadedCount.ToString();

				progress.OperationComplete = true;

				if(ExMsgList.ToString()!="")
					BOErrorMsg.Append("<br />" + ExMsgList.ToString());

			}
			catch (Exception x)
			{
				//RadLabelErrorMsg.Text += "<br />" + x.Message.ToString();
				BOErrorMsg.Append("<br />" + "CreateAccountBudget() Exception:" + ProcRecordText  + " "+ x.ToString());
			}
			finally
			{
				ABAdp.Dispose();
			}
		}

		protected void CreateAccountBudget(ILaunch IL, DataRow dr, string bookID, string balanceAcct, string balanceType, int fiscalYear, string fiscalYearSuffix, string fiscalCalendarID, string budgetCodeID, ref StringBuilder BOErrorMsg)
		{


			ClassEpicor main = new ClassEpicor();
			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");
			string sql = "";

			AccountBudgetAdapter ABAdp = new AccountBudgetAdapter(IL);
			ABAdp.BOConnect();

			try
			{
				sql = "select * from erp.GLBudgetHd where Company=@Company and BookID=@BookID and BalanceAcct=@BalanceAcct and BalanceType=@BalanceType and FiscalYear=@FiscalYear and FiscalYearSuffix=@FiscalYearSuffix and FiscalCalendarID=@FiscalCalendarID and BudgetCodeID=@BudgetCodeID";

				SqlCommand cmd = new SqlCommand();
				cmd.CommandText = sql;
				cmd.CommandType = CommandType.Text;
				cmd.CommandTimeout = 3600;
				cmd.Parameters.AddWithValue("@Company", RadTextBoxCurrentCompany.Text);
				cmd.Parameters.AddWithValue("@BookID", bookID);
				cmd.Parameters.AddWithValue("@BalanceAcct", balanceAcct);
				cmd.Parameters.AddWithValue("@BalanceType", balanceType);
				cmd.Parameters.AddWithValue("@FiscalYear", fiscalYear.ToString());
				cmd.Parameters.AddWithValue("@FiscalYearSuffix", fiscalYearSuffix);
				cmd.Parameters.AddWithValue("@FiscalCalendarID", fiscalCalendarID);
				cmd.Parameters.AddWithValue("@BudgetCodeID", budgetCodeID);

				DataTable dt = main.GetData(cmd, ref ExMsg);

				if (ExMsg != "")
					BOErrorMsg.Append(ExMsg + "<br />" + sql + "<br />");

				if(dt.Rows.Count==0)
				{
					decimal budgetAmt = 0, budgetStatAmt = 0;
					ABAdp.GetNewGLBudgetHd(bookID, balanceAcct, balanceType, fiscalYear, fiscalYearSuffix, fiscalCalendarID, budgetCodeID);
					ABAdp.ValidateGLAccount(bookID, budgetCodeID, balanceAcct, balanceType, fiscalYear, fiscalYearSuffix, budgetAmt, budgetStatAmt);
					ABAdp.ChangeBalanceAcct();
					ABAdp.Update();
				}

				foreach(DataRow drD in ABAdp.AccountBudgetData.Tables["GLBudgetDtl"].Rows)
				{
					if (Convert.ToInt32(drD["FiscalPeriod"]) <= 12)
					{
						drD["BudgetAmt"] = dr["Period_" + Convert.ToInt32(drD["FiscalPeriod"]).ToString()];
						//drD["RowMod"] = "U";
						ABAdp.ChangeDtlBudgetAmt();
						ABAdp.Update();

					}
				}

			}
			catch (Exception x)
			{
				RadLabelErrorMsg.Text += "<br />" + x.Message.ToString();
				BOErrorMsg.Append("<br />" + x.Message.ToString());
			}
			finally
			{
				ABAdp.Dispose();
			}
		}

		protected void RadButtonDownload_Click(object sender, EventArgs e)
		{
			try
			{
				RadGridSearch.ExportSettings.Excel.Format = GridExcelExportFormat.Xlsx;
				RadGridSearch.ExportSettings.ExportOnlyData = true;
				RadGridSearch.ExportSettings.IgnorePaging = true;
				RadGridSearch.ExportSettings.OpenInNewWindow = true;
				RadGridSearch.ExportSettings.FileName = "BudgetDetails " + Convert.ToString(RadComboBoxFiscalYear.SelectedValue) + " " + Convert.ToString(RadComboBoxBudgetCode.SelectedValue);

				RadGridSearch.MasterTableView.ExportToExcel();
			}
			catch (Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
		}

		protected void RadButtonDownloadSummary_Click(object sender, EventArgs e)
		{
			try
			{
				RadGridDtl.ExportSettings.Excel.Format = GridExcelExportFormat.Xlsx;
				RadGridDtl.ExportSettings.ExportOnlyData = true;
				RadGridDtl.ExportSettings.IgnorePaging = true;
				RadGridDtl.ExportSettings.OpenInNewWindow = true;
				RadGridDtl.ExportSettings.FileName = "BudgetSummary " + Convert.ToString(RadComboBoxFiscalYear.SelectedValue) + " " + Convert.ToString(RadComboBoxBudgetCode.SelectedValue);

				RadGridDtl.MasterTableView.ExportToExcel();
			}
			catch (Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
		}

		private void Init_RadProgressArea1()
		{
			RadProgressArea1.Localization.UploadedFiles = "Completed Rows: ";
			RadProgressArea1.Localization.CurrentFileName = "Process ";
			RadProgressArea1.Localization.TotalFiles = "Total Rows:";
		}

        //<asp:Button ID = "Button1" runat="server" Text="Button" OnClick="Button1_Click"/>
        //<asp:TextBox ID = "TextBox1" runat="server"></asp:TextBox>
		/*
		protected void Button1_Click(object sender, EventArgs e)
		{
			for (int i = 0; i < 1; i++)
			{
				System.Threading.Thread.Sleep(1000);
			}

			TextBox1.Text = "OK";
		}
		*/

		protected void TestProgressBar(DataTable dtBGSum, int FiscalYear, string BudgetCodeID, ref StringBuilder BOErrorMsg, ref string UploadMsg)
		{
			RadProgressContext progress = RadProgressContext.Current;

			ClassEpicor mainEpicor = new ClassEpicor();
			ClassMain main = new ClassMain();
			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");
			string sql = "";


			progress.CurrentOperationText = "Ready to start......";
			progress.PrimaryTotal = 1;
			progress.PrimaryValue = 0;

			progress.SecondaryTotal = 1;
			progress.SecondaryValue = 0;

			progress.PrimaryPercent = 0;
			progress.SecondaryPercent = 0;

			System.Threading.Thread.Sleep(10000); //10 second

			string ProcRecordText = "";

			try
			{

				decimal p = 0;
				int PrgCount = 1, pi = 0, UploadedCount = 1;
				//RadProgressContext progress = RadProgressContext.Current;
				progress.Speed = "N/A";
				int Total = dtBGSum.Rows.Count;

				string balanceAcct = "";

				string LogSQLStr = "insert UploadToEpicorLog (BatchNum,BatchLine,Company,FiscalYear,BudgetCode,AccountNum,UploadBy,UploadRuntime) values (";

				string BatchNum = DateTime.Now.ToString("yyyyMMdd-HHmmss");
				int line = 0;

				foreach (DataRow dr in dtBGSum.Rows)
				{

					balanceAcct = Convert.ToString(dr["AccountCode"]).Replace("-", "|");


					ProcRecordText = balanceAcct;
					progress.CurrentOperationText = "Row " + PrgCount.ToString() + "  AccountCode:" + ProcRecordText;

					//Epicor BO upload
					line++;
					sql = LogSQLStr + "'"+ BatchNum + "',"+ line.ToString()+",'"+ RadTextBoxCurrentCompany.Text + "',"+ FiscalYear.ToString()+",'"+ BudgetCodeID+"','"+balanceAcct+"','"+RadTextBoxUserID.Text+"','"+ DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+"')";

					int i = main.RunSQL(sql, ref ExMsg);

					if (ExMsg != "")
					{
						ExMsgList.Append(ExMsg + "<br />" + sql + "<br />");
						break;
					}						


					UploadedCount = PrgCount;

					progress.PrimaryTotal = Total;
					progress.PrimaryValue = PrgCount;

					progress.SecondaryTotal = Total;
					progress.SecondaryValue = PrgCount;

					//cal percent count num
					p = Convert.ToDecimal(PrgCount) / Convert.ToDecimal(Total) * 100m;
					pi = Convert.ToInt32(Math.Floor(p));

					progress.PrimaryPercent = pi;
					progress.SecondaryPercent = pi;

					PrgCount += 1;

					//for RadProgressArea1 cancel button
					if (!Response.IsClientConnected)
					{
						//Cancel button was clicked or the browser was closed, so stop processing
						break;
					}

					//Stall the current thread for 0.1 seconds
					System.Threading.Thread.Sleep(100);
				}

				UploadMsg = "Uploaded total rows: " + UploadedCount.ToString();

				progress.OperationComplete = true;

				if (ExMsgList.ToString() != "")
					BOErrorMsg.Append("<br />" + ExMsgList.ToString());

			}
			catch (Exception x)
			{
				//RadLabelErrorMsg.Text += "<br />" + x.Message.ToString();
				BOErrorMsg.Append("<br />" + "Upload AccountCode error:" + ProcRecordText + " " + x.Message.ToString());
			}
			finally
			{
				
			}
		}

	}
}