using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Data.SqlClient;
using Telerik.Web.UI;
using System.Text;

namespace BudgetPlan
{
    public partial class UserRegistry : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
			if (!Page.IsPostBack)
			{
				Label labMasterTitle = ((MasterPageSingleMenu)Master).FindControl("LabelMasterTitle") as Label;
				labMasterTitle.Text = "User Registry";

				HttpCookie htcoUserLoginID = Request.Cookies["UserLogin"];
				if (htcoUserLoginID != null)
				{
					RadTextBoxUserID.Text = HttpUtility.UrlDecode(htcoUserLoginID.Values["UserID"].ToString());
				}

				if (RadTextBoxUserID.Text == "")
				{
					Response.Redirect("Login.aspx");
				}

				//check IsSysAdmin
				ClassMain main = new ClassMain();
				string ExMsg = "";
				StringBuilder ExMsgList = new StringBuilder("");
				string sql = "";

				sql = "select * from UserFile where UserID='" + RadTextBoxUserID.Text + "'";

				DataTable dt = main.GetSQLtb(sql, ref ExMsg);

				if (ExMsg != "")
					ExMsgList.Append("<br />" + ExMsg);

				if(dt!=null && dt.Rows.Count>0)
				{
					bool IsSysAdmin = Convert.ToBoolean(dt.Rows[0]["IsSysAdmin"]);

					if(IsSysAdmin==false)
					{
						Response.Redirect("Home.aspx");
					}
				}

				RadLabelErrorMsg.Text = "";
				RadLabelMsg.Text = "";
			}

			RadTextBoxUserID.Visible = false;
		}

		protected void RadButtonSearch_Click(object sender, EventArgs e)
		{
			RadLabelErrorMsg.Text = "";
			RadLabelMsg.Text = "";

			this.SqlDataSourceUserList.DataBind();
			this.RadGridSearch.Rebind();

			RadGridSearch.Visible = true;
		}

		protected void RadGridSearch_ItemCommand(object sender, GridCommandEventArgs e)
		{
			if (e.CommandName == "RadButtonSearchOK")
			{
				foreach (GridDataItem item in RadGridSearch.SelectedItems)
				{
					string UserID = item.GetDataKeyValue("UserID").ToString();

					UserReg_GetByID(UserID);
				}

				RadGridSearch.Visible = false;
			}

			if (e.CommandName == "RadButtonSearchCancel")
			{
				RadGridSearch.Visible = false;
			}
		}

		protected void UserReg_GetByID(string UserID)
		{
			string sql = "";

			sql = "select * from UserFile where UserID='" + UserID + "'";

			try
			{
				ClassMain main = new ClassMain();
				string ExMsg = "";

				DataTable dtHed = main.GetSQLtb(sql, ref ExMsg);
				RadLabelErrorMsg.Text = ExMsg;

				if (dtHed != null && dtHed.Rows.Count == 0)
				{
					DataRow dr = dtHed.NewRow();
					dtHed.Rows.Add(dr);
				}

				RadTextBoxCreateUserID.Text = Convert.ToString(dtHed.Rows[0]["UserID"]);
				RadTextBoxName.Text = Convert.ToString(dtHed.Rows[0]["Name"]);

				RadCheckBoxIsSysAdmin.Checked = false;
				if (Convert.ToBoolean(dtHed.Rows[0]["IsSysAdmin"]))
					RadCheckBoxIsSysAdmin.Checked = true;

				RadCheckBoxIsBudgetTemplate.Checked = false;
				if (Convert.ToBoolean(dtHed.Rows[0]["IsBudgetTemplate"]))
					RadCheckBoxIsBudgetTemplate.Checked = true;

				RadCheckBoxIsBudgetPlan.Checked = false;
				if (Convert.ToBoolean(dtHed.Rows[0]["IsBudgetPlan"]))
					RadCheckBoxIsBudgetPlan.Checked = true;

				RadCheckBoxIsBudgetEntry.Checked = false;
				if (Convert.ToBoolean(dtHed.Rows[0]["IsBudgetEntry"]))
					RadCheckBoxIsBudgetEntry.Checked = true;

				RadCheckBoxIsBudgetApproval.Checked = false;
				if (Convert.ToBoolean(dtHed.Rows[0]["IsBudgetApproval"]))
					RadCheckBoxIsBudgetApproval.Checked = true;

				RadCheckBoxInactive.Checked = false;
				if (Convert.ToBoolean(dtHed.Rows[0]["Inactive"]))
					RadCheckBoxInactive.Checked = true;

				RadTextBoxCreateUserID.ReadOnly = true;
			}
			catch(Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}
			

		}

		protected void RadButtonNew_Click(object sender, EventArgs e)
		{
			UserReg_GetNewHed();
		}

		protected void UserReg_GetNewHed()
		{
			try
			{
				string sql = "";

				sql = "select * from UserFile where 1=2";

				ClassMain main = new ClassMain();
				string Msg = "";

				DataTable dtHed = main.GetSQLtb(sql, ref Msg);
				RadLabelErrorMsg.Text = Msg;

				if (dtHed != null && dtHed.Rows.Count == 0)
				{
					DataRow dr = dtHed.NewRow();
					dtHed.Rows.Add(dr);

					dtHed.Rows[0]["IsSysAdmin"] = false;
					dtHed.Rows[0]["IsBudgetTemplate"] = false;
					dtHed.Rows[0]["IsBudgetPlan"] = false;
					dtHed.Rows[0]["IsBudgetEntry"] = false;
					dtHed.Rows[0]["IsBudgetApproval"] = false;
					dtHed.Rows[0]["Inactive"] = false;
				}

				RadTextBoxCreateUserID.Text = Convert.ToString(dtHed.Rows[0]["UserID"]);
				RadTextBoxName.Text = Convert.ToString(dtHed.Rows[0]["Name"]);
				RadCheckBoxIsSysAdmin.Checked = Convert.ToBoolean(dtHed.Rows[0]["IsSysAdmin"]);
				RadCheckBoxIsBudgetTemplate.Checked = Convert.ToBoolean(dtHed.Rows[0]["IsBudgetTemplate"]);
				RadCheckBoxIsBudgetPlan.Checked = Convert.ToBoolean(dtHed.Rows[0]["IsBudgetPlan"]);
				RadCheckBoxIsBudgetEntry.Checked = Convert.ToBoolean(dtHed.Rows[0]["IsBudgetEntry"]);
				RadCheckBoxIsBudgetApproval.Checked = Convert.ToBoolean(dtHed.Rows[0]["IsBudgetApproval"]);
				RadCheckBoxInactive.Checked = Convert.ToBoolean(dtHed.Rows[0]["Inactive"]);

				RadTextBoxCreateUserID.ReadOnly = false;
			}
			catch(Exception ex)
			{
				RadLabelErrorMsg.Text = ex.Message;
			}

			
		}

		protected void RadButtonSave_Click(object sender, EventArgs e)
		{
			RadLabelMsg.Text = "";

			if (RadTextBoxCreateUserID.Text.Trim() == "")
			{
				RadLabelMsg.Text = "Invalid UserID!";
				return;
			}

			if (RadTextBoxName.Text.Trim() == "")
			{
				RadLabelMsg.Text = "Invalid Name!";
				return;
			}

			string sql = "";

			sql = "select * from UserFile where UserID=''";

			ClassMain main = new ClassMain();
			string Msg = "";

			DataTable dtHed = main.GetSQLtb(sql, ref Msg);
			RadLabelErrorMsg.Text = Msg;

			if (dtHed != null && dtHed.Rows.Count == 0)
			{
				DataRow dr = dtHed.NewRow();
				dtHed.Rows.Add(dr);
			}

			dtHed.Rows[0]["UserID"] = RadTextBoxCreateUserID.Text;
			dtHed.Rows[0]["Name"] = RadTextBoxName.Text;
			dtHed.Rows[0]["PassWord"] = "";


			bool IsSysAdmin = false, Inactive = false;

			if (Convert.ToBoolean(RadCheckBoxIsSysAdmin.Checked))
				IsSysAdmin = true;

			if (Convert.ToBoolean(RadCheckBoxInactive.Checked))
				Inactive = true;

			dtHed.Rows[0]["IsSysAdmin"] = IsSysAdmin;
			dtHed.Rows[0]["IsBudgetTemplate"] = Convert.ToBoolean(RadCheckBoxIsBudgetTemplate.Checked);
			dtHed.Rows[0]["IsBudgetPlan"] = Convert.ToBoolean(RadCheckBoxIsBudgetPlan.Checked);
			dtHed.Rows[0]["IsBudgetEntry"] = Convert.ToBoolean(RadCheckBoxIsBudgetEntry.Checked);
			dtHed.Rows[0]["IsBudgetApproval"] = Convert.ToBoolean(RadCheckBoxIsBudgetApproval.Checked);
			dtHed.Rows[0]["Inactive"] = Inactive;

			Msg = "";
			BudgetTemplate_UpdateHed(dtHed.Rows[0], ref Msg);
			RadLabelErrorMsg.Text = Msg;

			RadLabelMsg.Text = "Entry# saved.";

			RadTextBoxCreateUserID.ReadOnly = true;
		}

		protected void BudgetTemplate_UpdateHed(DataRow drSave, ref string Msg)
		{
			string sql = "", UserID = "", Name = "", IsSysAdmin = "0", Inactive = "0";
			DateTime CreatedDate;

			UserID = Convert.ToString(drSave["UserID"]);
			Name = Convert.ToString(drSave["Name"]);

			if (Convert.ToBoolean(drSave["IsSysAdmin"]))
				IsSysAdmin = "1";

			if (Convert.ToBoolean(drSave["Inactive"]))
				Inactive = "1";

				sql = "select * from UserFile where UserID='" + UserID + "'";

			ClassMain main = new ClassMain();

			DataTable dtHed = main.GetSQLtb(sql, ref Msg);

			if (dtHed != null && dtHed.Rows.Count == 0)
			{
				SqlCommand cmd1 = new SqlCommand();
				cmd1.CommandText = "insert into UserFile(UserID) Values (@UserID)";	//insert key field value
				cmd1.CommandTimeout = 3600;
				cmd1.Parameters.Add(new SqlParameter("@UserID", UserID));

				string Msg1 = "";
				int UpdateRows1 = main.UpdateBySQL(cmd1, ref Msg1);

				if (Msg1 != "")
					Msg += "Insert Error:" + Msg1;

			}

			//update others field value by key
			SqlCommand cmd2 = new SqlCommand();
			cmd2.CommandText = "update UserFile set [Name] = @Name, [PassWord] = @PassWord, [IsSysAdmin] = @IsSysAdmin, [IsBudgetTemplate] = @IsBudgetTemplate, [IsBudgetPlan] = @IsBudgetPlan, [IsBudgetEntry] = @IsBudgetEntry, [IsBudgetApproval] = @IsBudgetApproval, [Inactive] = @Inactive where [UserID] = @UserID";
			cmd2.CommandTimeout = 3600;
			cmd2.Parameters.Add(new SqlParameter("@UserID", Convert.ToString(drSave["UserID"])));
			cmd2.Parameters.Add(new SqlParameter("@Name", Convert.ToString(drSave["Name"])));
			cmd2.Parameters.Add(new SqlParameter("@PassWord", Convert.ToString(drSave["PassWord"])));
			cmd2.Parameters.Add(new SqlParameter("@IsSysAdmin", IsSysAdmin));
			cmd2.Parameters.Add(new SqlParameter("@IsBudgetTemplate", Convert.ToBoolean(drSave["IsBudgetTemplate"])));
			cmd2.Parameters.Add(new SqlParameter("@IsBudgetPlan", Convert.ToBoolean(drSave["IsBudgetPlan"])));
			cmd2.Parameters.Add(new SqlParameter("@IsBudgetEntry", Convert.ToBoolean(drSave["IsBudgetEntry"])));
			cmd2.Parameters.Add(new SqlParameter("@IsBudgetApproval", Convert.ToBoolean(drSave["IsBudgetApproval"])));
			cmd2.Parameters.Add(new SqlParameter("@Inactive", Inactive));

			string Msg2 = "";
			int UpdateRows2 = main.UpdateBySQL(cmd2, ref Msg2);

			if (Msg2 != "")
				Msg += "Update Error:" + Msg2;

		}

		protected void RadButtonDelete_Click(object sender, EventArgs e)
		{
			string UserID = RadTextBoxCreateUserID.Text;

			ClassMain main = new ClassMain();
			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");
			string sql = "";

			try
			{
				sql = "delete from UserFile where UserID='" + UserID + "'";

				int i = main.RunSQL(sql, ref ExMsg);

				if (ExMsg != "")
					ExMsgList.Append("<br />" + ExMsg);

				UserReg_GetByID("");

				RadLabelMsg.Text = "UserID:" + UserID + " has been deleted!";
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

		protected void RadButtonResetPassword_Click(object sender, EventArgs e)
		{
			string UserID = RadTextBoxCreateUserID.Text;

			ClassMain main = new ClassMain();
			string ExMsg = "";
			StringBuilder ExMsgList = new StringBuilder("");
			string sql = "";

			try
			{
				sql = "update UserFile set PassWord='' where UserID='" + UserID + "'";

				int i = main.RunSQL(sql, ref ExMsg);

				if (ExMsg != "")
					ExMsgList.Append("<br />" + ExMsg);

				RadLabelMsg.Text = "UserID:" + UserID + " password has been reseted!";
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
	}
}