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

            DataFeed feed = service.Query(pageViewQuery);
            for (int i = 0; i < 20; i++)
            {
                DataEntry pvEntry = (DataEntry)feed.Entries[i];
                string page = pvEntry.Dimensions[0].Value.Substring(1);
                string visits = pvEntry.Metrics[0].Value;

                Console.WriteLine(page + ": " + visits);
            }

            Console.ReadLine();
        }
    }
}