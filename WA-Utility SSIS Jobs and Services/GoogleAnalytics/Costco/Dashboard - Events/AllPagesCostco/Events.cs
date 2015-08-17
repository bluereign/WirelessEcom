using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Google.GData.Analytics;
using Google.GData.Extensions;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Data;
using System.Collections;
using System.Security.Cryptography.X509Certificates;
using Google.Apis.Auth.OAuth2;
using Google.GData.Client;

namespace GoogleAnalytics
{


    class Program
    {
       //for now copy and move in the refactoring
       static string GetInputDateString(string[] args)
       {
          var defaultDate = DateTime.Now;
          var returnDate = defaultDate;

          if (!(args == null || args.Length < 1))
          {
             DateTime parsedDate;
             if (!DateTime.TryParse(args[0], out parsedDate))
             {
                parsedDate = defaultDate;
             }

             returnDate = parsedDate;
          }

          return returnDate.ToString("yyyy-MM-dd");
       }
        static void Main(string[] args)
        {


            //DateTime dt = new DateTime(2014, 12, 08);


            #region new OAuth code
            string ServiceAccountEmail = "324055957972-gugi2s667i945br29n7fslulvla2dqe6@developer.gserviceaccount.com";
            var certificate = new X509Certificate2("Key.p12", "notasecret", X509KeyStorageFlags.Exportable);

            var serviceAccountCredentialInitializer = new ServiceAccountCredential.Initializer(ServiceAccountEmail)
            {
                Scopes = new[] { "https://www.google.com/analytics/feeds/data" }
            }.FromCertificate(certificate);

            var credential = new ServiceAccountCredential(serviceAccountCredentialInitializer);

            if (!credential.RequestAccessTokenAsync(System.Threading.CancellationToken.None).Result)
                throw new InvalidOperationException("Access token request failed.");

            var requestFactory = new GDataRequestFactory(null);
            requestFactory.CustomHeaders.Add("Authorization: Bearer " + credential.Token.AccessToken);

            AnalyticsService service = new AnalyticsService("NaomiAnalytics") { RequestFactory = requestFactory };
            AccountQuery feedQuery = new AccountQuery();

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            service.setUserCredentials(userName, passWord);
            #endregion

            DataQuery VarCharFeed = new DataQuery("https://www.google.com/analytics/feeds/data");
            VarCharFeed.Ids = "ga:42483618";
            VarCharFeed.Dimensions = "ga:eventCategory,ga:eventLabel,ga:eventAction";
            VarCharFeed.Metrics = "ga:totalEvents,ga:uniqueEvents,ga:eventValue";
            //VarCharFeed.Metrics = "ga:searchUniques";
            VarCharFeed.Sort = "-ga:eventLabel";

            var date = GetInputDateString(args);

            VarCharFeed.GAStartDate = date;
            VarCharFeed.GAEndDate = date;

            //VarCharFeed.GAStartDate = String.Format("{0:yyyy-MM-dd}", dt);
            //VarCharFeed.GAEndDate = String.Format("{0:yyyy-MM-dd}", dt); 

            string conn = "Data Source=10.7.0.221;Initial Catalog=AnalyticsReporting;Integrated Security=True;Persist Security Info=False;";

            SqlConnection sc = new SqlConnection(conn);
            sc.Open();

            string sql = "DELETE FROM dashboard.Events WHERE RunDate = '" + date + "'";
            //string sql = "DELETE FROM dashboard.Events WHERE RunDate = '" + String.Format("{0:yyyy-MM-dd}", dt) + "'";

            SqlCommand cmd = new SqlCommand(sql, sc);
            cmd.ExecuteNonQuery();
            cmd = null;

            sc.Close();

            DataFeed feed = service.Query(VarCharFeed);
            //for (int i = 0; i < feed.Entries.Count; i++)
            foreach (DataEntry pvEntry in feed.Entries)
            {
//                DataEntry pvEntry = (DataEntry)feed.Entries[i];
                string category = pvEntry.Dimensions[0].Value.Substring(0);
                string label = pvEntry.Dimensions[1].Value.Substring(0);
                string action = pvEntry.Dimensions[2].Value.Substring(0);
                string total = pvEntry.Metrics[0].Value;
                string unique = pvEntry.Metrics[1].Value;
                string value = pvEntry.Metrics[1].Value;


            string conn2 = "Data Source=10.7.0.221;Initial Catalog=AnalyticsReporting;Integrated Security=True;Persist Security Info=False;";
            
            SqlConnection sc2 = new SqlConnection(conn2);
            sc2.Open();


            string sql2 = "INSERT INTO dashboard.Events " +
                    " (RunDate, Category, Label, Action, TotalClicks, UniqueClicks, ValueClicks) " +
                    //" (RunDate, SearchTerm, UniqueSearches) " +
                    " VALUES ('" + date + "','" + category + "','" + label + "','" + action + "','" + total + "','" + unique + "','" + value + "')";
                    //" VALUES ('" + String.Format("{0:yyyy-MM-dd}", dt) + "','" + category + "','" + label + "','" + action + "','" + total + "','" + unique + "','" + value + "')";

            SqlCommand cmd2 = new SqlCommand(sql2, sc2);
                cmd2.ExecuteNonQuery();
                cmd2 = null;

                sc2.Close();

            }

                
                
                
            }

       }
    }
