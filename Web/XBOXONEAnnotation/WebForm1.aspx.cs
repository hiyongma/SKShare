using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Security.Principal;
using System.Data;

namespace XBOXONEAnnotation
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [System.Web.Services.WebMethod]
        public static string test(string timeid)
        {
            return "test " + timeid;
        }


        [System.Web.Services.WebMethod]
        public static String load(string timeid, string subject)
        {
            DataSet ds;
            WindowsPrincipal wp = new WindowsPrincipal(WindowsIdentity.GetCurrent());
            string fulluser = wp.Identity.Name;
            int idx = fulluser.IndexOf("\\");
            string alias = fulluser.Substring(idx + 1);

            if (timeid != null)
            {

                if (subject != null && subject.ToLower().IndexOf("X1Annotation") >= 0)
                    ds = DBTalk.GetSIDataSet("co2infsrvidb803", "XONE", true, "p_annotation_load", DBTalk.FormulateSqlParameter(new string[2] { timeid, subject }));
                else
                    ds = DBTalk.GetSIDataSet("CO2INFAUDTDB801", "portal", true, "p_annotation_load", DBTalk.FormulateSqlParameter(new string[2] { timeid, subject }));

                if (ds.Tables[0].Rows.Count != 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    //txtAnnotation.Text
                    var annotation = dr[0].ToString();
                    //txtEnter.Text 
                    alias = dr[1].ToString();
                    return annotation + ":$:" + alias;
                }
            }

            return ":$:" + alias;
        }

        [System.Web.Services.WebMethod]
        public static string submit(string timeid, string annotation, string enterby, string subject)
        {
            try
            {
                if (subject != null && subject.ToLower().IndexOf("X1Annotation") >= 0)
                    DBTalk.UpdateData("co2infsrvidb803", "XONE", true, "p_annotation_add", DBTalk.FormulateSqlParameter(new string[4] { timeid, annotation, enterby, subject }));
                else
                    DBTalk.UpdateData("CO2INFAUDTDB801", "portal", true, "p_annotation_add", DBTalk.FormulateSqlParameter(new string[4] { timeid, annotation, enterby, subject }));
            }
            catch
            {
                 //do nothing
            }
            return "ok";
        }

        [System.Web.Services.WebMethod]
        public static string userdelete(string timeid, string annotation, string enterby, string subject)
        {
            try
            {
                if (subject != null && subject.ToLower().IndexOf("X1Annotation") >= 0)
                    DBTalk.UpdateData("co2infsrvidb803", "XONE", true, "p_annotation_add", DBTalk.FormulateSqlParameter(new string[4] { timeid, annotation, enterby, subject }));
                else
                    DBTalk.UpdateData("CO2INFAUDTDB801", "portal", true, "p_annotation_add", DBTalk.FormulateSqlParameter(new string[4] { timeid, annotation, enterby, subject }));
            }
            catch
            {
                //do nothing
            }
            return "ok";
        }
    }
}