using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Security.Cryptography;
using System.IO;

using System.Data;
using System.Data.SqlClient;

namespace BudgetPlan
{
    public class ClassMain
    {
		protected static string ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BudgetPlanConnectionString"].ConnectionString;
		public string Encode(string data)
		{
			string KEY_64 = "DataWrld";
			string IV_64 = "NplMd5Cd";
			try
			{
				byte[] byKey = System.Text.ASCIIEncoding.ASCII.GetBytes(KEY_64);
				byte[] byIV = System.Text.ASCIIEncoding.ASCII.GetBytes(IV_64);

				DESCryptoServiceProvider cryptoProvider = new DESCryptoServiceProvider();
				int i = cryptoProvider.KeySize;
				MemoryStream ms = new MemoryStream();
				CryptoStream cst = new CryptoStream(ms, cryptoProvider.CreateEncryptor(byKey, byIV), CryptoStreamMode.Write);
				StreamWriter sw = new StreamWriter(cst);
				sw.Write(data);
				sw.Flush();
				cst.FlushFinalBlock();
				sw.Flush();
				return Convert.ToBase64String(ms.GetBuffer(), 0, (int)ms.Length);
			}
			catch (Exception x)
			{
				return x.Message;
			}
		}

		public string Decode(string data)
		{
			string KEY_64 = "DataWrld";
			string IV_64 = "NplMd5Cd";

			try
			{
				byte[] byKey = System.Text.ASCIIEncoding.ASCII.GetBytes(KEY_64);
				byte[] byIV = System.Text.ASCIIEncoding.ASCII.GetBytes(IV_64);
				byte[] byEnc;
				byEnc = Convert.FromBase64String(data);
				DESCryptoServiceProvider cryptoProvider = new DESCryptoServiceProvider();
				MemoryStream ms = new MemoryStream(byEnc);
				CryptoStream cst = new CryptoStream(ms, cryptoProvider.CreateDecryptor(byKey, byIV), CryptoStreamMode.Read);
				StreamReader sr = new StreamReader(cst);
				return sr.ReadToEnd();
			}
			catch (Exception x)
			{
				return x.Message;
			}
		}
		public DataTable GetData(SqlCommand cmd, ref string Msg)
		{
			Msg = "";

			DataTable rtDt = null;

			SqlConnection sqlCon = new SqlConnection(ConnectionString);

			try
			{
				sqlCon.Open();

				cmd.Connection = sqlCon;
				SqlDataAdapter sqlAdp = new SqlDataAdapter(cmd);
				sqlAdp.SelectCommand.CommandTimeout = 3600;     //Command.SelectCommand.CommandTimeout = 0; Cancel default setting, default is 30s
				DataSet ds = new DataSet();
				sqlAdp.Fill(ds);
				if (ds.Tables.Count > 0)
				{
					rtDt = ds.Tables[0];
				}

			}
			catch (Exception ex)
			{
				//MessageBox.Show(ex.Message);
				//RadLabelErrorMsg.Text = ex.ToString();
				//Msg = ex.ToString();
				Msg = ex.Message;
			}
			finally
			{
				sqlCon.Close();
			}

			return rtDt;
		}


		public DataTable GetSQLtb(string SQLStr, ref string Msg)
		{
			Msg = "";

			DataTable rtDt = null;

			SqlConnection sqlCon = new SqlConnection(ConnectionString);

			try
			{
				sqlCon.Open();
				string commTxt = SQLStr;
				SqlDataAdapter sqlAdp = new SqlDataAdapter(commTxt, sqlCon);
				sqlAdp.SelectCommand.CommandTimeout = 3600;     //Command.SelectCommand.CommandTimeout = 0; Cancel default setting, default is 30s
				DataSet ds = new DataSet();
				sqlAdp.Fill(ds);
				if (ds.Tables.Count > 0)
				{
					rtDt = ds.Tables[0];
				}

			}
			catch (Exception ex)
			{
				//MessageBox.Show(ex.Message);
				//RadLabelErrorMsg.Text = ex.ToString();
				//Msg = ex.ToString();
				Msg = ex.Message;
			}
			finally
			{
				sqlCon.Close();
			}

			return rtDt;
		}

		public int RunSQL(string SQLStr, ref string ExMsg)
		{
			ExMsg = "";

			int rtValue = -99;

			SqlConnection sqlCon = new SqlConnection(ConnectionString);

			try
			{
				sqlCon.Open();
				SqlCommand sqlCom = new SqlCommand(SQLStr, sqlCon);
				sqlCom.CommandTimeout = 3600;
				sqlCom.Connection = sqlCon;
				int count = sqlCom.ExecuteNonQuery();   //return effected rows, "-1" is for select cmd, ">=0" is for update cmd (update data rows)

				rtValue = count;

			}
			catch (Exception ex)
			{
				//MessageBox.Show(ex.Message);
				//RadLabelErrorMsg.Text = ex.ToString();
				//Msg = ex.ToString();
				ExMsg = "RunSQL() Error:" + ex.Message;
			}
			finally
			{
				sqlCon.Close();
			}

			return rtValue;
		}

		public int UpdateBySQL(SqlCommand cmd, ref string Msg)
		{
			Msg = "";

			int rtValue = -99;

			SqlConnection sqlCon = new SqlConnection(ConnectionString);

			try
			{
				sqlCon.Open();
				cmd.Connection = sqlCon;
				int count = cmd.ExecuteNonQuery();   //return effected rows, "-1" is for select cmd, ">=0" is for update cmd (update data rows)

				rtValue = count;
			}
			catch (Exception ex)
			{
				//MessageBox.Show(ex.Message);
				//RadLabelErrorMsg.Text = ex.ToString();
				//Msg = ex.ToString();
				Msg = ex.Message;
			}
			finally
			{
				sqlCon.Close();
			}

			return rtValue;
		}
		public DataTable ExecStoreProc(SqlCommand cmd, ref string Msg)
		{
			Msg = "";

			DataTable rtDt = null;

			SqlConnection conn = new SqlConnection(ConnectionString);

			try
			{
				conn.Open();
				cmd.Connection = conn;
				//cmd.ExecuteNonQuery();	//no return result

				//return dataset
				SqlDataAdapter adp = new SqlDataAdapter(cmd);
				DataSet ds = new DataSet();
				adp.Fill(ds);

				rtDt = ds.Tables[0];

			}
			catch (Exception ex)
			{
				//MessageBox.Show(ex.ToString());
				//RadLabelErrorMsg.Text = ex.ToString();
				//Msg = ex.ToString();
				Msg = ex.Message;
			}
			finally
			{
				conn.Close();
			}

			return rtDt;
		}

		public string GetConnectionString()
		{
			return ConnectionString;
		}
	}
}