// --------------------------------------------------------------------------------------------------------------------
// <copyright file="QueryPlansAndOptionsService.cs" company="">
//   
// </copyright>
// <summary>
//   The query plans and options service.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.APIHelper
{
    using SprintCarrierServiceTests.QueryPlansAndOptionsService;

    /// <summary>The query plans and options service.</summary>
    internal class QueryPlansAndOptionsService
    {
        #region Methods

        /// <summary>The build validate plans and options.</summary>
        private void BuildValidatePlansAndOptions()
        {
            var request = new QueryAvailableOptionsRequest();
            var response = new QueryAvailableOptionsResponse();

            var service = new QueryPlansAndOptionsPortTypeClient();

            // request.wsMessageHeader = Common.GetMessageHeader<QueryPlansAndOptionsService>("9999");
            service.Open();
            WsMessageHeaderType wsMessageHeader = null;
            ValidationErrorInfoType validationErrorInfo;
            SuggestionGroupInfoType[] suggestionGroupList;
            SecondaryBundleSubPricePlanChangeRequiredInfo[] secBundleSubPricePlanChangeRequiredList;
            PricePlanInfoType3 pricePlanInfo, expiredPricePlanInfo;
            string ltsRemainingSubscribers;
            LegacyPlanInfoType[] legacyPlanList;
            bool familySubscribersPricePlanChangeRequiredInd, dataSocInd, messagingSocInd, voiceControlValidInd;
            ResourceInfoType[] expiredResourceList, resourceList;
            ChangedSocInfoType[] changedSocList;
            AddOnSocInfoResponseType[] addOnSocList, expiredAddOnSocList;

            bool fred = service.ValidatePlansAndOptions(
                ref wsMessageHeader, 
                null, 
                null, 
                out familySubscribersPricePlanChangeRequiredInd, 
                out secBundleSubPricePlanChangeRequiredList, 
                out ltsRemainingSubscribers, 
                out pricePlanInfo, 
                out addOnSocList, 
                out expiredPricePlanInfo, 
                out expiredAddOnSocList, 
                out expiredResourceList, 
                out changedSocList, 
                out legacyPlanList, 
                out resourceList, 
                out suggestionGroupList, 
                out dataSocInd, 
                out messagingSocInd, 
                out validationErrorInfo, 
                out voiceControlValidInd);
        }

        #endregion
    }
}