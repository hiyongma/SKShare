using System;
using System.Data;
using System.Data.SqlClient;

namespace XBOXONEAnnotation
{
    class DBTalk
    {

        public static DataSet GetSIDataSet(string servername, string dbname,  bool isStoredProcedure, string commandtext, SqlParameter[] sqlparameter)
        {
            //string constring= string.Format("Data Source={0};Initial Catalog={1};Integrated Security=True", servername, dbname);/
            string constring;
            constring =  string.Format("Data Source={0};Initial Catalog={1};Integrated Security=True", servername, dbname);
            DataSet ds = new DataSet("SIDATA");
            SqlConnection con = new SqlConnection(constring);
            SqlCommand com = new SqlCommand(commandtext);
            com.CommandType = (isStoredProcedure == true) ? (CommandType.StoredProcedure) : (CommandType.Text);
            com.CommandTimeout = 0;
            com.Connection = con;
            if (con.State != ConnectionState.Open)
                con.Open();
            if ((sqlparameter != null) && (isStoredProcedure))
            {
                for (int ii = 0; ii < sqlparameter.Length; ii++)
                {
                    com.Parameters.Add(sqlparameter[ii]);
                }
            }
            SqlDataAdapter da = new SqlDataAdapter(com);
            try
            {
                da.Fill(ds);
            }
            catch (SqlException ex)
            {
                ds = null;
            }

            return ds;
        }
        public static void UpdateData(string servername, string dbname, bool isStoredProcedure, string commandtext, SqlParameter[] sqlpar)
        {
            //string constring = string.Format("Data Source={0};Initial Catalog={1};Integrated Security=True", servername, dbname);
            string constring;

            //if (servername.CompareTo("co2infsrvidb803") == 0)
            //    constring = string.Format("Server={0}; Database={1}; User ID=Webapi; Password=abc-!@#-123;", servername, dbname);
            //else
            //    constring = string.Format("Server={0}; Database={1}; User ID=Webapi; Password=abc-!@#-123;", servername, dbname);
            constring = string.Format("Data Source={0};Initial Catalog={1};Integrated Security=True", servername, dbname);

            SqlConnection con = new SqlConnection(constring);
            SqlCommand com = new SqlCommand(commandtext);
            com.CommandType = (isStoredProcedure == true) ? (CommandType.StoredProcedure) : (CommandType.Text);
            com.CommandTimeout = 0;
            com.Connection = con;
            if (con.State != ConnectionState.Open)
                con.Open();

            if ((sqlpar != null) && (isStoredProcedure))
            {
                for (int ii = 0; ii < sqlpar.Length; ii++)
                {
                    com.Parameters.Add(sqlpar[ii]);
                }
            }

            try
            {
                com.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                throw ex;
            }
        }

        // load error 

        public static SqlParameter[] FormulateSqlParameter(string[] strvalues)
        {
            if (strvalues == null)
                return null;

            SqlParameter[] sqlparameters = new SqlParameter[strvalues.Length];

            for (int ii = 0; ii < strvalues.Length; ii++)
            {
                sqlparameters[ii] = new SqlParameter("parameter" + ii.ToString(), strvalues[ii]);
            }
            return sqlparameters;
        }
        public static string IntToClumn(int columnint)
        {
            string col = "";
            if (columnint < 1)
                return col;
            int jj = columnint % 26;
            if (jj == 0)
                jj = 26;
            columnint = (columnint - 1) / 26;
            while (columnint > 0)
            {
                col = IntToClumn(columnint) + col;
                columnint = (columnint - 1) / 26;
            }
            col = col + (Convert.ToChar(jj + 64)).ToString();
            return col;
        }
    }
}
