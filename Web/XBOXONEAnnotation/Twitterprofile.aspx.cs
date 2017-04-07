using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.ObjectModel;
using System.Dynamic;
using System.Web.Script.Serialization;
using System.Text;
using System.Net;
using System.IO;


namespace XBOXONEAnnotation
{
    public partial class Twitterprofile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public static void twitAuth(ref TwitAuthenticateResponse twitAuthResponse)
        {
            var oAuthConsumerKey = "ZypQZbZhdSTV3DitjNH5jP608";
            var oAuthConsumerSecret = "dz6iIMjOyCXU1sxOKPWjfmN7DUa8FnhpJ6UnpXLgbEfxLYGM1L";
            var oAuthUrl = "https://api.twitter.com/oauth2/token";

            // Do the Authenticate
            var authHeaderFormat = "Basic {0}";

            var authHeader = string.Format(authHeaderFormat, Convert.ToBase64String(Encoding.UTF8.GetBytes(Uri.EscapeDataString(oAuthConsumerKey) + ":" +
            Uri.EscapeDataString((oAuthConsumerSecret)))));

            var postBody = "grant_type=client_credentials";

            HttpWebRequest authRequest = (HttpWebRequest)WebRequest.Create(oAuthUrl);
            authRequest.Headers.Add("Authorization", authHeader);
            authRequest.Method = "POST";
            authRequest.ContentType = "application/x-www-form-urlencoded;charset=UTF-8";
            authRequest.AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate;

            using (Stream stream = authRequest.GetRequestStream())
            {
                byte[] content = ASCIIEncoding.ASCII.GetBytes(postBody);
                stream.Write(content, 0, content.Length);
            }

            authRequest.Headers.Add("Accept-Encoding", "gzip");
            var objectText = "";
            WebResponse authResponse = authRequest.GetResponse();
            using (authResponse)
            {
                using (var reader = new StreamReader(authResponse.GetResponseStream()))
                {
                    //JavaScriptSerializer js = new JavaScriptSerializer();
                    objectText = reader.ReadToEnd();
                    //twitAuthResponse = JsonConvert.DeserializeObject<TwitAuthenticateResponse>(objectText);
                }
            }
            //JavaScriptSerializer jss = new JavaScriptSerializer();
            //jss.RegisterConverters(new JavaScriptConverter[] { new DynamicJsonConverter() });
            //dynamic batch = jss.Deserialize(objectText, typeof(object)) as dynamic;
            //twitAuthResponse.access_token = batch.Dictionary["access_token"].ToString();
            //twitAuthResponse.access_token = batch.Dictionary["token_type"].ToString();
            twitAuthResponse.access_token = "AAAAAAAAAAAAAAAAAAAAAGJCXgAAAAAAPifZ009iZEL3cbdwidaAMCUgulQ%3DS9sqfh73u20uUl0AU4RkXWq6z64VKwr6bLSyz3NTOwpIKtZG8h";
            twitAuthResponse.access_token = "bearer";
        }

        public static string LoadGeturl(string screenname, TwitAuthenticateResponse twitAuthResponse)
        {
            //var screenname = "@Longxone";
            //var screenname = "@wood206";
            //var screenname = "@123123addonl";
            var timelineFormat = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name={0}&include_rts=1&exclude_replies=1&count=5";
            var timelineUrl = string.Format(timelineFormat, screenname);
            try
            {
                HttpWebRequest timeLineRequest = (HttpWebRequest)WebRequest.Create(timelineUrl);
                var timelineHeaderFormat = "{0} {1}";

                timeLineRequest.Headers.Add("Authorization", string.Format(timelineHeaderFormat, twitAuthResponse.token_type, twitAuthResponse.access_token));
                timeLineRequest.Method = "Get";
                WebResponse timeLineResponse = timeLineRequest.GetResponse();
                var timeLineJson = string.Empty;
                using (timeLineResponse)
                {
                    using (var reader = new StreamReader(timeLineResponse.GetResponseStream()))
                    {
                        timeLineJson = reader.ReadToEnd();
                    }
                }
                JavaScriptSerializer jss = new JavaScriptSerializer();
                jss.RegisterConverters(new JavaScriptConverter[] { new DynamicJsonConverter() });
                dynamic batch = jss.Deserialize(timeLineJson, typeof(object)) as dynamic;
                //return populatedata(batch, timeLineJson);

                return "";
                //twitAuthResponse.access_token = batch.Dictionary["access_token"].ToString();
                //twitAuthResponse.access_token = batch.Dictionary["token_type"].ToString();
            }
            catch (Exception e)
            {
                return null;
            }
        }



        public static DataSet GetSIDataSet()
        {
            string constring = "Server=CO2INFAUDTDB802; Database=twitterDB; User ID=Webapi; Password=abc-!@#-123;";
            DataSet ds = new DataSet("SIDATA");
            SqlConnection con = new SqlConnection(constring);
            SqlCommand com = new SqlCommand("p_readscreenname");
            com.CommandType = CommandType.StoredProcedure;
            com.CommandTimeout = 0;
            com.Connection = con;
            if (con.State != ConnectionState.Open)
                con.Open();
            SqlDataAdapter da = new SqlDataAdapter(com);
            try
            {
                da.Fill(ds);
            }
            catch (SqlException ex)
            {
                ds = null;
            }
            finally
            {
                con.Close();
            }

            return ds;
        }
        [System.Web.Services.WebMethod]
        public static String calltwitterapi(string screenname, string viewdata)
        {
            StringBuilder dt = new StringBuilder();
            TwitAuthenticateResponse auth = new TwitAuthenticateResponse();
            twitAuth(ref auth);
            LoadGeturl("@Longxone", auth);
            return "";
        }

        [System.Web.Services.WebMethod]
        public static String getscreenname()
        {
            string result = "";
            DataRow dr;
            DataSet ds= GetSIDataSet();
            if (ds.Tables[0].Rows.Count != 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    dr = ds.Tables[0].Rows[i];
                    result += dr[0].ToString() + ":$:";
                }
            }

            return result;
        }
    }

    public class TwitAuthenticateResponse
    {
        public string token_type { get; set; }
        public string access_token { get; set; }
    }

    public class JSONClass
    {
    }
    public class DynamicJsonObject : DynamicObject
    {
        public IDictionary<string, object> Dictionary { get; set; }
        public DynamicJsonObject(IDictionary<string, object> dictionary)
        { this.Dictionary = dictionary; }
        public override bool TryGetMember(GetMemberBinder binder, out object result)
        {
            result = this.Dictionary[binder.Name];
            if (result is IDictionary<string, object>)
            {
                result = new DynamicJsonObject(result as IDictionary<string, object>);
            }
            else if (result is ArrayList && (result as ArrayList) is IDictionary<string, object>)
            {
                result = new List<DynamicJsonObject>((result as ArrayList).ToArray().Select(x => new DynamicJsonObject(x as IDictionary<string, object>)));
            }
            else if (result is ArrayList)
            {
                result = new List<object>((result as ArrayList).ToArray());
            }
            return this.Dictionary.ContainsKey(binder.Name);
        }
    }
    public class DynamicJsonConverter : JavaScriptConverter
    {
        public override object Deserialize(IDictionary<string, object> dictionary, Type type, JavaScriptSerializer serializer)
        {
            if (dictionary == null)
                throw new ArgumentNullException("dictionary");
            if (type == typeof(object))
            {
                return new DynamicJsonObject(dictionary);
            }
            return null;
        }
        public override IDictionary<string, object> Serialize(object obj, JavaScriptSerializer serializer)
        {
            throw new NotImplementedException();
        }
        public override IEnumerable<Type> SupportedTypes
        {
            get
            {
                return new ReadOnlyCollection<Type>(new List<Type>(new Type[] { typeof(object) }));
            }
        }
    }
}