// --------------------------------------------------------------------------------------------------------------------
// <copyright file="StubServiceFacts.cs" company="">
//   
// </copyright>
// <summary>
//   The unit test 1.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests
{
    using System;
    using System.Collections.Generic;

    using Moq;

    using SprintCarrierServiceTests.APIHelper;

    using Xunit;

    /// <summary>The unit test 1.</summary>
    public class StubServiceFacts 
    {
        #region Fields

        /// <summary>The reference number.</summary>
        private string ReferenceNumber = "12345676";

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the collection.</summary>
        public static IEnumerable<string> Collection { get; set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The fred.</summary>
        [Fact]
        public static void SampleWcfServiceStub() 
        {
            var config = new WebServiceConfig { Binding = "MyBinding", Endpoint = "http://service.com/Service.svc" };

            //var wcfClient = new Mock<IManagementService>();
            //wcfClient.Setup(wcf => wcf.GetResponse()).Returns("Hello!");

            //var stubClientWrapper =
            //    new StubServiceClientWrapper<ManagementServiceClient, IManagementService>(wcfClient.Object);

            //// var service = new Service(config, stubClientWrapper);
            //var response = this._serviceClientWrapper.Execute(
            //    config, 
            //    service => service.GetUnreliableResponse(), 
            //    commsException => SendMeAnEmailAboutThis(commsException), 
            //    numberOfTimesToRetry: 3);

            //var serviceResponse = service.GetResponse();

            //Assert.Equal("Hello!", serviceResponse);
        }

        /// <summary>The service returns false when bad data.</summary>
        [Fact]
        public void ServiceReturnsFalseWhenBadData()
        {
            const int Expected = 1;
        }

        #endregion

        #region Methods

        /// <summary>The get app setting.</summary>
        /// <param name="apiversion">The apiversion.</param>
        /// <returns>The <see cref="object"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        private object GetAppSetting(string apiversion)
        {
            throw new NotImplementedException("GetAppSetting");
        }

        #endregion
    }
}