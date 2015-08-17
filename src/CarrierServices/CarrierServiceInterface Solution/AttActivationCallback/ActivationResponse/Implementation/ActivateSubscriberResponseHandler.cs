// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivateSubscriberResponseHandler.cs" company="">
//   
// </copyright>
// <summary>
//   The activate subscriber response handler.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace ActivationResponse
{
    using System;
    using System.Linq;

    using AttCarrierServiceInterface;
    using AttCarrierServiceInterface.Interfaces.AttProxy;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;
    using WirelessAdvocates.SalesOrder;

    /// <summary>The activate subscriber response handler.</summary>
    public class ActivateSubscriberResponseHandler : AttServiceBase
    {
        #region Constants

        /// <summary>The object name.</summary>
        private const string ObjectName = "ActivateSubscriberResponseHandler";

        #endregion

        #region Fields

        /// <summary>The _wireless order.</summary>
        private WirelessOrder wirelessOrder;

        #endregion

        #region Public Methods and Operators

        /// <summary>The handle.</summary>
        /// <param name="request">The request.</param>
        public void Handle(ActivateSubscriberResponseInfo request)
        {
            var response = new RequestAcknowledgementInfo();
            try
            {
                this.wirelessOrder = new WirelessOrder(
                    request.billingAccountNumber, 
                    (int)ActivationStatus.RequestSubmitted);

                this.ReferenceNumber = this.wirelessOrder.CheckoutReferenceNumber;

                foreach (ActivateSubscriberResponseInfoSubscriber subscriber in request.Subscriber)
                {
                    WirelessLine line = this.wirelessOrder.GetWirelessLine(subscriber.subscriberNumber);
                    if (subscriber.subscriberStatus == SubscriberStatusInfo.A)
                    {
                        if (line.NewMDN != null)
                        {
                            line.CurrentMDN = line.NewMDN;
                        }

                        line.ActivationStatus = ActivationStatus.Success;
                    }

                    if (subscriber.subscriberStatus == SubscriberStatusInfo.C)
                    {
                        line.ActivationStatus = ActivationStatus.Failure;
                    }
                }

                // Have all lines received a response (if not, don't change the order status)
                if (!this.wirelessOrder.WirelessLines.Any(s => s.ActivationStatus == ActivationStatus.RequestSubmitted))
                {
                    bool failures =
                        this.wirelessOrder.WirelessLines.Any(s => s.ActivationStatus == ActivationStatus.Failure);
                    bool success =
                        this.wirelessOrder.WirelessLines.Any(s => s.ActivationStatus == ActivationStatus.Success);
                    if (success)
                    {
                        if (failures)
                        {
                            this.wirelessOrder.ActivationStatus = (int)ActivationStatus.PartialSuccess;
                        }
                        else
                        {
                            this.wirelessOrder.ActivationStatus = (int)ActivationStatus.Success;
                        }
                    }
                }

                this.wirelessOrder.Save();
            }
            catch (Exception ex)
            {
                new Log().LogException(
                    ex.Message, 
                    "Att", 
                    "ActivateSubscriberResponse", 
                    this.wirelessOrder.CheckoutReferenceNumber);
                throw;
            }
            finally
            {
                this.LogRequest(request, ObjectName);
            }
        }

        #endregion
    }
}