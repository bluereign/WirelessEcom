// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationReplaceFacts.cs" company="">
//   
// </copyright>
// <summary>
//   The activation replace facts.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.ServiceImplementation
{
    using System.Diagnostics;

    using SprintCarrierServiceTests.Properties;

    using SprintCSI.ServiceImplementation;
    using SprintCSI.ServiceImplementation.DTO;

    using XmlUnit.Xunit;

    using Xunit;

    /// <summary>The activation replace facts.</summary>
    public class ActivationReplaceFacts
    {
        #region Constants

        /// <summary>The my solar system.</summary>
        private const string MySolarSystem = "<solar-system><planet name='Earth' position='3' supportsLife='yes'/><planet name='Venus' position='4'/></solar-system>";

        #endregion

        #region Public Methods and Operators     

        /// <summary>The assert string equal and identical to self.</summary>
        [Fact]
        public void AssertStringEqualAndIdenticalToSelf()
        {
            const string Control = "<assert>true</assert>";
            const string Test = "<assert>true</assert>";
            XmlAssertion.AssertXmlIdentical(Control, Test);
            XmlAssertion.AssertXmlEquals(Control, Test);
        }

        /// <summary>The assert x path evaluates to works for matching expression.</summary>
        [Fact]
        public void AssertXPathEvaluatesToWorksForMatchingExpression()
        {
            XmlAssertion.AssertXPathEvaluatesTo("//planet[@position='3']/@supportsLife", MySolarSystem, "yes");
        }

        /// <summary>The assert x path exists works for existent x path.</summary>
        [Fact]
        public void AssertXPathExistsWorksForExistentXPath()
        {
            XmlAssertion.AssertXPathExists("//planet[@name='Earth']", MySolarSystem);
        }

        /// <summary>The assert map request works for single subscriber order.</summary>
        [Fact]
        public void AssertMapRequestWorksForSingleSubscriberOrder() 
        {
            var activationReplaceRequest = new ActivationReplaceRequest
                                               {
                                                   ActivationRequestXml = Resources.XmlHelperFacts_activationRequestUPGRADE, 
                                                   SprintCustomerInquiryResponseXml = Resources.XMLHelperFacts_accountValidationResponse
                                               };
            var activationReplace = new ActivationReplace();
            activationReplace.MapRequest(activationReplaceRequest);
            string activationReplaceRequestXml = activationReplace.RequestXmlHelper.GenerateXml();
            XmlAssertion.AssertXmlIdentical(activationReplaceRequestXml, Resources.XmlHelperFacts_ExpectedActivationReplaceRequestForOneLine);
        }

        /// <summary>The assert map request works for multi subscriber order.</summary>
        [Fact]
        public void AssertMapRequestWorksForMultiSubscriberOrder()
        {
            var activationReplaceRequest = new ActivationReplaceRequest
                                               {
                                                   ActivationRequestXml = Resources.XmlHelperFacts_activationRequestUPGRADE, 
                                                   SprintCustomerInquiryResponseXml = Resources.XmlHelperFacts_MultiSubscriber_accountValidationResponse
                                               };
            var activationReplace = new ActivationReplace();
            activationReplace.MapRequest(activationReplaceRequest);
            string activationReplaceRequestXml = activationReplace.RequestXmlHelper.GenerateXml();
            XmlAssertion.AssertXmlIdentical(activationReplaceRequestXml, Resources.XmlHelperFacts_ExpectedActivationReplaceRequestForOneLine);
        }

        #endregion
    }
}