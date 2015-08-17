using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Google.GData.Analytics;

namespace GoogleAnalytics
{
    class Program
    {
        static void Main(string[] args)
        {


            AccountQuery feedQuery = new AccountQuery();
            AnalyticsService service = new AnalyticsService("NaomiAnalytics");
            service.setUserCredentials("wasvcs@gmail.com", "CHRIS1sawesome!");

            DataQuery pageViewQuery = new DataQuery("https://www.google.com/analytics/feeds/data");
            pageViewQuery.Ids = "ga:42483618";
            pageViewQuery.Metrics = "ga:visits";
            pageViewQuery.Dimensions = "ga:pagePath";
            pageViewQuery.Sort = "-ga:visits";
            pageViewQuery.GAStartDate = DateTime.Now.ToString("yyyy-MM-dd");
            pageViewQuery.GAEndDate = DateTime.Now.ToString("yyyy-MM-dd");

            string conn = "Data Source=10.7.0.220;Initial Catalog=AnalyticsReportingPGM;Integrated Security=True;Persist Security Info=False;";

            SqlConnection sc = new SqlConnection(conn);
            sc.Open();

            string sql = "DELETE FROM dashboard.Pageviews WHERE RunDate = '" + DateTime.Now.ToString("yyyy-MM-dd") + "'";

            SqlCommand cmd = new SqlCommand(sql, sc);
            cmd.ExecuteNonQuery();
            cmd = null;

            sc.Close();

            DataFeed feed = service.Query(VarCharFeed);
            for (int i = 0; i < 500; i++)
            {
                DataEntry pvEntry = (DataEntry)feed.Entries[i];
                string page = pvEntry.Dimensions[0].Value.Substring(1);
                string views = pvEntry.Metrics[0].Value;
                string visits = pvEntry.Metrics[1].Value;
                string bounces = pvEntry.Metrics[2].Value;
                string entrances = pvEntry.Metrics[3].Value;
                string exits = pvEntry.Metrics[4].Value;
                string transactions = pvEntry.Metrics[5].Value;
                string timeonpage = pvEntry.Metrics[6].Value;


                string conn2 = "Data Source=10.7.0.220;Initial Catalog=AnalyticsReportingPGM;Integrated Security=True;Persist Security Info=False;";

                SqlConnection sc2 = new SqlConnection(conn2);
                sc2.Open();


                string sql2 = "INSERT INTO dashboard.Pageviews " +
                        " (RunDate, PageURL, Views, Visits, Entrances, Bounces, Exits, Transactions, AvgTime) " +
                        " VALUES ('" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + page + "','" + views + "','" + visits + "','" + bounces + "','" + entrances + "','" + exits + "','" + transactions + "','" + timeonpage + "')";

                SqlCommand cmd2 = new SqlCommand(sql2, sc2);
                cmd2.ExecuteNonQuery();
                cmd2 = null;

                sc2.Close();
            }
        }
    }
}