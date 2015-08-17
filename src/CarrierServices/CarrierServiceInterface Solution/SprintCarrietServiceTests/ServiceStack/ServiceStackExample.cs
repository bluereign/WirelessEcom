//// --------------------------------------------------------------------------------------------------------------------
//// <copyright file="ServiceStackExample.cs" company="">
////   
//// </copyright>
//// <summary>
////   The using service clients.
//// </summary>
//// --------------------------------------------------------------------------------------------------------------------

//namespace ServiceStack.UsageExamples
//{
//    using ServiceStack.Service;
//    using ServiceStack.ServiceClient.Web;
//    using ServiceStack.ServiceHost;
//    using ServiceStack.ServiceInterface.ServiceModel;

//    using Xunit;

//    /// <summary>The using service clients.</summary>
//    public class UsingServiceClients : TestBase
//    {
//        #region Public Methods and Operators

//        /// <summary>The get_customers_using_ json service client.</summary>
//        [Fact]
//        public void Get_customers_using_JsonServiceClient()
//        {
//            using (IServiceClient client = new JsonServiceClient(base.JsonSyncReplyBaseUri))
//            {
//                var request = new GetCustomers { CustomerIds = new ArrayOfIntId { CustomerId } };
//                var response = client.Send<GetCustomersResponse>(request);

//                Assert.Equal(1, response.Customers.Count);
//                Assert.Equal(CustomerId, response.Customers[0].Id); 
//            }
//        }

//        /// <summary>The get_customers_using_ soap 11 service client.</summary>
//        [Fact]
//        public void Get_customers_using_Soap11ServiceClient()
//        {
//            using (IServiceClient client = new Soap11ServiceClient(base.BasicHttpSyncReplyUri))
//            {
//                var request = new GetCustomers { CustomerIds = new ArrayOfIntId { CustomerId } };
//                var response = client.Send<GetCustomersResponse>(request);

//                Assert.Equal(1, response.Customers.Count);
//                Assert.Equal(CustomerId, response.Customers[0].Id);
//            }
//        }

//        /// <summary>The get_customers_using_ soap 12 service client.</summary>
//        [Fact]
//        public void Get_customers_using_Soap12ServiceClient()
//        {
//            using (IServiceClient client = new Soap12ServiceClient(base.WsSyncReplyUri))
//            {
//                var request = new GetCustomers { CustomerIds = new ArrayOfIntId { CustomerId } };
//                var response = client.Send<GetCustomersResponse>(request);

//                Assert.Equal(1, response.Customers.Count);
//                Assert.Equal(CustomerId, response.Customers[0].Id);
//            }
//        }

//        /// <summary>The get_customers_using_ xml service client.</summary>
//        [Fact]
//        public void Get_customers_using_XmlServiceClient()
//        {
//            using (IServiceClient client = new XmlServiceClient(base.XmlSyncReplyBaseUri))
//            {
//                var request = new GetCustomers { CustomerIds = new ArrayOfIntId { CustomerId } };
//                var response = client.Send<GetCustomersResponse>(request);

//                Assert.Equal(1, response.Customers.Count);
//                Assert.Equal(CustomerId, response.Customers[0].Id);
//            }
//        }

//        #endregion

//        public object CustomerId { get; set; }
//    }

//    public class GetCustomersResponse
//    {
//    }

//    public class GetCustomers : IReturn<GetCustomersResponse>
//    {
//        public ArrayOfIntId CustomerIds { get; set; }
//    }

//    public class TestBase
//    {
//        public string WsSyncReplyUri { get; set; }
//        public string JsonSyncReplyBaseUri { get; set; }
//        public string BasicHttpSyncReplyUri { get; set; }
//        public string XmlSyncReplyBaseUri { get; set; }
//    }
//}