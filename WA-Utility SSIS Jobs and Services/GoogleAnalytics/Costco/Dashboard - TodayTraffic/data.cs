using System;
using System.IO;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Google.GData.Analytics;
using System.Net.Mail;
using System.Security.Cryptography.X509Certificates;
using Google.Apis.Auth.OAuth2;
using Google.GData.Client;

namespace Dashboard
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


            nData n = null;
            //string rundate = System.DateTime.Now.ToShortDateString();
            string rundate = GetInputDateString(args);

            n = new nData(rundate, DayOfWeek.Friday);
            n.saveToSql(rundate, n.dataPoints);

        }

    }

    public class dataType
    {
        public string VisitsTotals { get; set; }
        public string VisitsUniques { get; set; }
        public string VisitsSearches { get; set; }
        public string VisitsCostcos { get; set; }
        public string VisitsCampaigns { get; set; }
        public string TransCampaigny { get; set; }
        public string TransCostcoy { get; set; }
        public string TransSearchy { get; set; }
        public string PPCommitCheckouty { get; set; }
        public string PPAddtoCarty { get; set; }
        public string PPBillShippy { get; set; }
        public string PPConfirmOrdery { get; set; }
        public string PPCovChecky { get; set; }
        public string PPCarrierTerms { get; set; }
        public string PPTermsCondy { get; set; }
        public string PPCustLettery { get; set; }
        public string BouncyKnowles { get; set; }
        public string ClearCarty { get; set; }
        public string AvgTimey { get; set; }
        public string AvgPages { get; set; }


    }

    public class nData
    {

        public List<dataType> dataPoints = new List<dataType>();

        public nData(string CurrentDate, DayOfWeek EndOfWeek)
        {
            DateTime MyDateTime = DateTime.Parse(CurrentDate);
            DateTime now = MyDateTime;
            string rundate = System.DateTime.Now.ToShortDateString();
            string todaytraffic = now.ToShortDateString();

            decimal Traffic = GetTraffic(todaytraffic, todaytraffic);
            decimal UniqueTraffic = GetUniqueTraffic(todaytraffic, todaytraffic);
            decimal Bounce = GetBounces(todaytraffic, todaytraffic);
            decimal AddCart = GetAddtoCart(todaytraffic, todaytraffic);
            decimal BillShip = GetBillShip(todaytraffic, todaytraffic);
            decimal ConfirmOrder = GetConfirmOrder(todaytraffic, todaytraffic);
            decimal CovCheck = GetCovCheck(todaytraffic, todaytraffic);
            decimal CarrierTerms = GetCarrierTerms(todaytraffic, todaytraffic);
            decimal TermsCond = GetTermsCond(todaytraffic, todaytraffic);
            decimal Letter = GetLetter(todaytraffic, todaytraffic);
            decimal ClearCart = GetClearCart(todaytraffic, todaytraffic);
            decimal AvgTimeonSite = GetAvgTimeonSite(todaytraffic, todaytraffic);
            decimal AvgPagesPerVis = GetPagesPerVis(todaytraffic, todaytraffic);
            decimal VisSearch = GetVisitsSearch(todaytraffic, todaytraffic);
            decimal VisCostco = GetVisitsCostco(todaytraffic, todaytraffic);
            decimal VisCampaign = GetVisitsCampaign(todaytraffic, todaytraffic);
            decimal TransCampaign = GetTransCampaign(todaytraffic, todaytraffic);
            decimal TransCostco = GetTransCostco(todaytraffic, todaytraffic);
            decimal TransSearch = GetTransSearch(todaytraffic, todaytraffic);
            decimal CommitCheck = GetCommitCheck(todaytraffic, todaytraffic);

            dataPoints.Add(new dataType()
            {
                VisitsTotals = Traffic.ToString(),
                VisitsUniques = UniqueTraffic.ToString(),
                VisitsSearches = VisSearch.ToString(),
                VisitsCostcos = VisCostco.ToString(),
                VisitsCampaigns = VisCampaign.ToString(),
                TransCampaigny = TransCampaign.ToString(),
                TransCostcoy = TransCostco.ToString(),
                TransSearchy = TransSearch.ToString(),
                PPCommitCheckouty = CommitCheck.ToString(),
                PPAddtoCarty = AddCart.ToString(),
                PPBillShippy = BillShip.ToString(),
                PPConfirmOrdery = ConfirmOrder.ToString(),
                PPCarrierTerms = CarrierTerms.ToString(),
                PPCovChecky = CovCheck.ToString(),
                PPTermsCondy = TermsCond.ToString(),
                PPCustLettery = Letter.ToString(),
                BouncyKnowles = Bounce.ToString(),
                ClearCarty = ClearCart.ToString(),
                AvgTimey = AvgTimeonSite.ToString(),
                AvgPages = AvgPagesPerVis.ToString()

            });

        }
        private int GetTraffic(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:landingPagePath",                     
                Metrics = "ga:visits",
                Sort = "ga:visits",
                Filters = "ga:hostname==membershipwireless.com",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }


        private int GetUniqueTraffic(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:landingPagePath",                     
                Metrics = "ga:visitors",
                Sort = "ga:visitors",
                Filters = "ga:hostname==membershipwireless.com",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }

        private int GetBounces(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                Dimensions = "ga:visitLength",
                Metrics = "ga:bounces",
                Sort = "ga:bounces",
                Filters = "ga:hostname==membershipwireless.com",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }


        private int GetCommitCheck(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:pagePath",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~index.cfm/go/checkout/do/wirelessAccountForm/bSoftReservationSuccess/1/index.cfm,ga:pagePath=~index.cfm/go/checkout/do/lnpRequest/bSoftReservationSuccess/1/index.cfm,ga:pagePath=~index.cfm/go/checkout/do/billShip/bSoftReservationSuccess/1/index.cfm,ga:pagePath=~index.cfm/go/checkout/do/wirelessAccountForm/bSoftReservationSuccess/1",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }




        private int GetBillShip(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:pagePath",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~index.cfm/go/checkout/do/billShip/index.cfm",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }


        private int GetAddtoCart(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:pagePath",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~cart/do/view/index.cfm",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }




        private int GetConfirmOrder(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:pagePath",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~index.cfm/go/checkout/do/orderConfirmation/index.cfm",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }




        private int GetCovCheck(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:pagePath",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~index.cfm/go/checkout/do/coverageCheck/index.cfm",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }

        private int GetCarrierTerms(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:pagePath",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~index.cfm/go/checkout/do/carrierTerms/index.cfm",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }



        private int GetTermsCond(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:pagePath",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~index.cfm/go/checkout/do/termsConditions/index.cfm",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }

        private int GetLetter(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:hostname==membershipwireless.com,ga:pagePath=/index.cfm/go/checkout/do/CustomerLetter/index.cfm",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~/index.cfm/go/checkout/do/CustomerLetter/index.cfm",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }


        private int GetClearCart(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:hostname==membershipwireless.com,ga:pagePath=/index.cfm/go/checkout/do/CustomerLetter/index.cfm",
                Metrics = "ga:uniquePageviews",
                Sort = "ga:uniquePageviews",
                Filters = "ga:pagePath=~/index.cfm/go/cart/do/clearCart/blnDialog/0/index.cfm",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }


        private decimal GetAvgTimeonSite(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:visitLength",
                Metrics = "ga:avgTimeOnSite",
                //Sort = "ga:visitLength",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            decimal grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                decimal metrics = decimal.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }



        private decimal GetPagesPerVis(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:hostname",
                Metrics = "ga:pageviewsPerVisit",
                //Sort = "ga:hostname",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            decimal grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                decimal metrics = decimal.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }




        private int GetVisitsSearch(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                Dimensions = "ga:source",
                Metrics = "ga:Visits",
                Sort = "ga:Visits",
                Filters = "ga:medium==organic",
                //Segment = "gaid::573625486",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }



        private int GetVisitsCostco(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                Dimensions = "ga:source",
                Metrics = "ga:Visits",
                Sort = "ga:Visits",
                //Filters = "ga:medium=referral",
                //Segment = "gaid::97355614",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }

        private int GetVisitsCampaign(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                Dimensions = "ga:source",
                Metrics = "ga:Visits",
                Sort = "ga:Visits",
                //Filters = "ga:medium=referral",
                //Segment = "gaid::494032585",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }





        private int GetTransCampaign(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                //Dimensions = "ga:source",
                Metrics = "ga:Transactions",
                Sort = "ga:Transactions",
                Filters = "ga:campaign!=(not set)",
                //Segment = "gaid::494032585",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }



        private int GetTransCostco(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                Dimensions = "ga:source",
                Metrics = "ga:Transactions",
                Sort = "ga:Transactions",
                //Filters = "ga:medium=referral",
                //Segment = "gaid::97355614",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }


        private int GetTransSearch(string StartDate, string EndDate)
        {
            DateTime startDate = DateTime.Parse(StartDate);
            DateTime endDate = DateTime.Parse(EndDate);

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            string profileId = "ga:42483618";

            const string dataFeedUrl = "https://www.google.com/analytics/feeds/data";

            var service = GetService();// new AnalyticsService("WebSiteAnalytics");

            service.setUserCredentials(userName, passWord);

            var dataQuery = new DataQuery(dataFeedUrl)
            {
                Ids = profileId,
                Dimensions = "ga:source",
                Metrics = "ga:Transactions",
                Sort = "ga:Transactions",
                //Filters = "ga:medium=referral",
                //Segment = "gaid::1358996621",
                GAStartDate = startDate.ToString("yyyy-MM-dd"),
                GAEndDate = endDate.ToString("yyyy-MM-dd"),
                NumberToRetrieve = 10000
            };

            int grandtotal = 0;
            var dataFeed = service.Query(dataQuery);
            foreach (DataEntry itm in dataFeed.Entries.AsEnumerable())
            {
                int metrics = int.Parse(itm.Metrics[0].Value);
                grandtotal += metrics;
            }

            return grandtotal;
        }


        public void saveToSql(string runDate, List<dataType> dataPoints)
        {

            string conn = "Data Source=10.7.0.221;Initial Catalog=AnalyticsReporting;Integrated Security=True;Persist Security Info=False;";


            SqlConnection sc = new SqlConnection(conn);
            sc.Open();

            string sql = "DELETE FROM dashboard.Analytics WHERE RunDate = '" + runDate + "'";

            SqlCommand cmd = new SqlCommand(sql, sc);
            cmd.ExecuteNonQuery();
            cmd = null;

            foreach (dataType dt in dataPoints)
            {

                string sql2 = "INSERT INTO dashboard.Analytics " +
                    " (RunDate, VisitsTotal, VisitsUnique, VisitsSearch, VisitsCostco, VisitsCampaign, TransCampaign, TransCostco, TransSearch, PPCommitCheckout, PPAddtoCart, PPBillShip, PPConfirmOrder, PPCarrierTerms, PPCovCheck, PPTermsCond, PPCustLetter, Bounces, ClearCart, AvgTime, AvgPages) " +
                    " VALUES ('" + runDate + "','" + dt.VisitsTotals + "','" + dt.VisitsUniques + "','" + dt.VisitsSearches + "','" + dt.VisitsCostcos + "','" + dt.VisitsCampaigns + "','" + dt.TransCampaigny + "','" + dt.TransCostcoy + "','" + dt.TransSearchy + "','" + dt.PPCommitCheckouty + "','" + dt.PPAddtoCarty + "','" + dt.PPBillShippy + "','" + dt.PPConfirmOrdery + "','" + dt.PPCarrierTerms + "','" + dt.PPCovChecky + "','" + dt.PPTermsCondy + "','" + dt.PPCustLettery + "','" + dt.BouncyKnowles + "','" + dt.ClearCarty + "','" + dt.AvgTimey + "','" + dt.AvgPages + "') ";

                cmd = new SqlCommand(sql2, sc);
                cmd.ExecuteNonQuery();
                cmd = null;
            }

            sc.Close();

        }

        private AnalyticsService GetService()
        {
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

            AnalyticsService service = new AnalyticsService("WebSiteAnalytics") { RequestFactory = requestFactory };

            string userName = "wasvcs@gmail.com";
            string passWord = "CHRIS1sawesome!";
            service.setUserCredentials(userName, passWord);
            return service;
            #endregion
        }
    }
}
