// --------------------------------------------------------------------------------------------------------------------
// <copyright file="XMLHelperFacts.cs" company="">
//   
// </copyright>
// <summary>
//   The xml helper facts.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;
    using System.ServiceModel;

    using SprintCarrierServiceTests.Annotations;
    using SprintCarrierServiceTests.Properties;

    using SprintCSI.Utils;

    using XmlUnit.Xunit;

    using Xunit;
    using Xunit.Extensions;

    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The xml helper facts.</summary>
    public class XMLHelperFacts
    {
        #region Constants

        /// <summary>The activation response active or fraudulent id.</summary>
        private const string ActivationResponseActiveOrFraudulentId = "259";

        #endregion

        #region Static Fields

        /// <summary>The activation response active or fraudulent.</summary>
        private static readonly string ActivationResponseActiveOrFraudulent = Resources.XMLHelperFacts_activationResponseActiveOrFraudulent;

        /// <summary>The activation response active or fraudulent.</summary>
        private static readonly string SoapFault = Resources.XmlHelperFacts_SoapFault;

        #endregion

        #region Public Properties

        /// <summary>Gets the xml input for helper for activation upgrade.</summary>
        public static IEnumerable<object[]> XmlInputForHelperForActivationUpgrade
        {
            get
            {
                yield return new object[] { ActivationResponseActiveOrFraudulent, ActivationResponseActiveOrFraudulentId, string.Format("{0}{1}", DateTime.Now.Ticks, "101") };
            }
        }

        /// <summary>Gets the xml input for helper for activation upgrade.</summary>
        public static IEnumerable<object[]> XmlInputForHelperForSoapFault
        {
            get
            {
                yield return new object[] { SoapFault, string.Format("{0}{1}", DateTime.Now.Ticks, "101") };
            }
        }


        #endregion

        #region Public Methods and Operators

        /// <summary>The xml deserializer does right thing for activation upgrade.</summary>
        /// <param name="sprintResponse">The sprint response.</param>
        /// <param name="errorCode">The error code.</param>
        /// <param name="uniqueId">The unique id.</param>
        [Theory]
        [PropertyData("XmlInputForHelperForActivationUpgrade")]
        public void AssertXMLDeserializerDoesRightThingForActivationUpgrade(string sprintResponse, string errorCode, string uniqueId)
        {
            var expected = errorCode;

            var obj = (NEW_RESPONSE.ovm)(new XmlHelper()).DeserializeOvmXMLResponse(sprintResponse);

            var sprintActivationResponse = (NEW_RESPONSE.ActivationResponse)obj.ovmresponse.Item;

            var service = sprintActivationResponse.service;

            var plan = (NEW_RESPONSE.ActivationResponsePlan)service[0];

            var meid = this.GetMeid(plan);

            var errorInfo = obj.ovmerrorinfo[0];

            var actual = errorInfo.errorcode;

            Trace.WriteLine("meid                  ==> " + meid);

            Assert.True(actual == expected, string.Format("Error ==> {0} {1}", errorInfo.errorsubname, errorInfo.errordetails));
        }

        /// <summary>The xml helper finds options.</summary>
        [Fact]
        public void AssertXMLHelperFindsOptions()
        {
            const int Expected = 5;
            var xmlHelper = new XmlHelper { XmlString = Resources.XMLHelperFacts_accountValidationResponse };
            var actual = xmlHelper.GetXmlValues("option");

            // string actual = xmlHelper.GetXmlAttributeValue(Resources.activationRequestOrder, Resources.activationRequestOrderType);
            Trace.WriteLine("actual ==> " + actual.Count);

            Assert.True(actual.Count == Expected, string.Format("Error ==> {0}  {1}", Expected, actual.Count));
        }

        /// <summary>The xml helper finds options with non zero mrc.</summary>
        [Fact]
        public void AssertXMLHelperFindsOptionsWithNonZeroMrc()
        {
            const int Expected = 1;
            var xmlHelper = new XmlHelper { XmlString = Resources.XMLHelperFacts_accountValidationResponse };

            var options = xmlHelper.GetXmlValues(Resources.accountValidationResponseOption);

            var query = from option in options where xmlHelper.GetXmlValue(option, Resources.accountValidationResponseOptionPrice) != "0.0" select xmlHelper.GetXmlValue(option, Resources.accountValidationResponseOptionCode);

            var actual = query.ToList();

            // string actual = xmlHelper.GetXmlAttributeValue(Resources.activationRequestOrder, Resources.activationRequestOrderType);
            Trace.WriteLine("actual ==> " + actual.Count);

            Assert.True(actual.Count == Expected, string.Format("Error ==> {0}  {1}", Expected, actual.Count));
        }

        /// <summary>The xml helper finds options with non zero mrc.</summary>
        [Fact]
        public void AssertXMLHelperReplacesFeatureCode() 
        {
            const bool Expected = true;
            var requestXmlHelper = new XmlHelper { XmlString = Resources.XmlHelperFacts_activationRequestUPGRADE };
             
            var inquiryXmlHelper = new XmlHelper { XmlString = Resources.XMLHelperFacts_accountValidationResponse };

            var options = inquiryXmlHelper.GetXmlValues(Resources.accountValidationResponseOption);

            // requestXmlHelper.DeleteOldFeatureCode();
            requestXmlHelper.DeleteElement(Resources.activationRequestFeature);


            var query = from option in options where inquiryXmlHelper.GetXmlValue(option, Resources.accountValidationResponseOptionPrice) != "0.0" select requestXmlHelper.GetXmlValue(option, Resources.accountValidationResponseOptionCode);

            var optionsToBeAdded = query.ToList();

            var actual = false;

            foreach (var optionToBeAdded in optionsToBeAdded)
            {
                actual = requestXmlHelper.InsertNewFeatureCode(optionToBeAdded);
            }

            // string actual = xmlHelper.GetXmlAttributeValue(Resources.activationRequestOrder, Resources.activationRequestOrderType);
            Trace.WriteLine("actual ==> " + actual);

            Assert.True(actual == Expected, string.Format("Error ==> {0}  {1}", Expected, actual));
        }


        /// <summary>The xml helper changes upgrade to replace.</summary>
        [Fact]
        public void AssertXMLHelperChangesUpgradeToReplace()
        {
            const string Expected = "REPLACE";
            var xmlHelper = new XmlHelper { XmlString = Resources.XmlHelperFacts_activationRequestUPGRADE };
            xmlHelper.SetOrderTypeToReplace();
            var actual = xmlHelper.GetXmlAttributeValue(Resources.activationRequestOrder, Resources.activationRequestOrderType);

            Trace.WriteLine("actual ==> " + actual);

            Assert.True(actual == Expected, string.Format("Error ==> {0} {1}", Expected, actual));
        }

        /// <summary>The xml helper generates xml from XDocument.</summary>
        [Fact]
        public void AssertXMLHelperGeneratesXmlFromXDocument()
        {
            var expected = Resources.XmlHelperFacts_activationRequestUPGRADE;
            var xmlHelper = new XmlHelper { XmlString = Resources.XmlHelperFacts_activationRequestUPGRADE };
            var actual = xmlHelper.GenerateXml();

            Trace.WriteLine("actual ==> " + actual);

            Assert.True(actual.Contains("<order type=\"UPGRADE\""), string.Format("Error ==> {0} {1}", expected, actual));
        }

        /// <summary>The xml helper gets error code.</summary>
        /// <param name="sprintResponse">The sprint response.</param>
        /// <param name="errorCode">The error code.</param>
        /// <param name="uniqueId">The unique id.</param>
        [Theory]
        [PropertyData("XmlInputForHelperForActivationUpgrade")]
        public void AssertXMLHelperGetsErrorCodeAndMeid([NotNull] string sprintResponse, [NotNull] string errorCode, [NotNull] string uniqueId)
        {
            var xmlHelper = new XmlHelper { XmlString = sprintResponse };
            var actual = xmlHelper.GetXmlValue(Resources.errorCode);
            xmlHelper.XmlObj = sprintResponse;
            var meid = xmlHelper.GetXmlValue(Resources.meid);

            var expected = errorCode;

            Trace.WriteLine("meid                  ==> " + meid);

            Assert.True(actual == expected, string.Format("Error ==> {0} {1}", expected, actual));
        }

        /// <summary>The assert xml helper gets soap error.</summary>
        /// <param name="soapFault">The soap fault.</param>
        /// <param name="uniqueId">The unique id.</param>
        [Theory]
        [PropertyData("XmlInputForHelperForSoapFault")]
        public void AssertXMLHelperGetsSoapError([NotNull] string soapFault, [NotNull] string uniqueId)
        {
            const string Expected = "Client.705";
            var xmlHelper = new XmlHelper { XmlString = soapFault };

            Trace.WriteLine("xml ==> " + xmlHelper.XmlString);

            var actual = xmlHelper.GetXmlValue("faultcode", false);

            Trace.WriteLine("providerErrorCode ==> " + xmlHelper.GetXmlValue("providerErrorCode", false));
            Trace.WriteLine("providerErrorText ==> " + xmlHelper.GetXmlValue("providerErrorText", false));

            Assert.True(actual == Expected, string.Format("Error ==> {0} {1}", Expected, actual));
        }

        /// <summary>The assert xml helper identifies failing element.</summary>
        [Fact]
        public void AssertXMLHelperIdentifiesFailingElement()
        {
            var xmlHelper = new XmlHelper();
            var actual = xmlHelper.ExtractFailingElement(Resources.XmlHelperFacts_DeserializeXmlFailedMessage, Resources.XMLHelperFacts_AcccountValidationResponseForError);

            const string Expected = "mult-vbs-soc-ind";  

            Trace.WriteLine("actual                  ==> " + actual);
            Assert.True(Expected == actual);
        }

        /// <summary>The assert xml helper deletes element.</summary>
        [Fact]
        public void AssertXMLHelperDeletesElement()
        {
            var xmlHelper = new XmlHelper { XmlString = Resources.XMLHelperFacts_AcccountValidationResponseForError };

            xmlHelper.DeleteElement("mult-vbs-soc-ind");

            var actual = xmlHelper.GenerateXml();

            Trace.WriteLine("actual                  ==> " + actual);

            // NOTE [pcrawford,20140220] 
            // The correct way to test for this inequality is through the use of an XmlAssertion,
            // but I have not had time to figure out why it does not work correctly

            // XmlAssertion.AssertXmlEquals(actual, Resources.XMLHelperFacts_AcccountValidationResponseForError);
            // XmlAssertion.AssertXmlNotIdentical(new XmlDiff(actual, Resources.XMLHelperFacts_AcccountValidationResponseForError));

            // It is true that the xml strings are not equal, but this is not the correct way to check
            Assert.NotEqual(actual, Resources.XMLHelperFacts_AcccountValidationResponseForError);
        }

        #endregion

        #region Methods

        /// <summary>The get meid.</summary>
        /// <param name="plan">The plan.</param>
        /// <returns>The <see cref="string"/>.</returns>
        [NotNull]
        private string GetMeid([NotNull] NEW_RESPONSE.ActivationResponsePlan plan)
        {
            var meid = string.Empty;
            var i = 0;

            foreach (var item in plan.phone[0].Items)
            {
                var type3Value = plan.phone[0].ItemsElementName[i];
                if (type3Value == NEW_RESPONSE.ItemsChoiceType3.meid)
                {
                    meid = item;
                }

                i++;
            }

            return meid;
        }

        #endregion
    }
}