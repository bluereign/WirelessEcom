// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WcfEventHelper.cs" company="">
//   
// </copyright>
// <summary>
//   The wcf event helper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.Utils
{
    using System;
    using System.Reactive;
    using System.Reactive.Linq;

    using SprintCSI.WCF;

    /// <summary>The wcf event helper.</summary>
    public class WcfEventHelper
    {
        #region Fields

        /// <summary>The event subscription.</summary>
        private readonly IDisposable errorEventSubscription;

        /// <summary>The event subscription.</summary>
        private readonly IDisposable interceptErrorEventSubscription;

        /// <summary>The intercept response subscription.</summary>
        private readonly IDisposable interceptResponseSubscription;

        /// <summary>The request subscription.</summary>
        private readonly IDisposable requestSubscription;

        /// <summary>The response subscription.</summary>
        private readonly IDisposable responseSubscription;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="WcfEventHelper"/> class.</summary>
        public WcfEventHelper()
        {
            // Setup to receive Event from Message Inspector
            // The Message Inspector code is a workaround for the failure of the proxy generator to correctly generate the fault class
            var errorEventAsObservable = Observable.FromEventPattern<ErrorEventArgs>(
                ev => SimpleMessageInspector.ErrorEvent += ev,
                ev => SimpleMessageInspector.ErrorEvent -= ev);

            this.errorEventSubscription = errorEventAsObservable.Subscribe(this.OnFaultExceptionEvent);

            // Setup to receive Event from Message Inspector
            // The Message Inspector code is a workaround for the failure of the proxy generator to correctly generate the fault class
            var interceptEventAsObservable = Observable.FromEventPattern<ErrorEventArgs>(
                ev => InterceptResponseChannel.ErrorEvent += ev, 
                ev => InterceptResponseChannel.ErrorEvent -= ev);

            this.interceptErrorEventSubscription = interceptEventAsObservable.Subscribe(this.OnFaultExceptionEvent);

            // Setup to receive Event from Message Inspector
            var requestAsObservable = Observable.FromEventPattern<RequestEventArgs>(
                ev => SimpleMessageInspector.RequestEvent += ev, 
                ev => SimpleMessageInspector.RequestEvent -= ev);

            this.requestSubscription = requestAsObservable.Subscribe(this.OnRequestEvent);

            // Setup to receive Event from Message Inspector
            var responseAsObservable = Observable.FromEventPattern<ResponseEventArgs>(
                ev => SimpleMessageInspector.ResponseEvent += ev, 
                ev => SimpleMessageInspector.ResponseEvent -= ev);

            this.responseSubscription = responseAsObservable.Subscribe(this.OnResponseEvent);

            // Setup to receive Event from Intercept Response Channel
            var interceptResponseAsObservable = Observable.FromEventPattern<ResponseEventArgs>(
                ev => InterceptResponseChannel.ResponseEvent += ev, 
                ev => InterceptResponseChannel.ResponseEvent -= ev);

            this.interceptResponseSubscription = interceptResponseAsObservable.Subscribe(this.OnResponseEvent);
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the provider error code.</summary>
        public string ProviderErrorCode { get; private set; }

        /// <summary>The provider error text.</summary>
        public string ProviderErrorText { get; private set; }

        /// <summary>Gets the request xml.</summary>
        public string RequestXml { get; private set; }

        /// <summary>Gets the response xml.</summary>
        public string ResponseXml { get; private set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The dispose subscriptions.</summary>
        public void DisposeSubscriptions()
        {
            this.errorEventSubscription.Dispose();
            this.interceptErrorEventSubscription.Dispose();
            this.requestSubscription.Dispose();
            this.responseSubscription.Dispose();
            this.interceptResponseSubscription.Dispose();
        }

        #endregion

        #region Methods

        /// <summary>The on fault exception event.</summary>
        /// <param name="args">The args.</param>
        private void OnFaultExceptionEvent(EventPattern<ErrorEventArgs> args)
        {
            var localArgs = args;
            this.ProviderErrorCode = localArgs.EventArgs.ProviderErrorCode;
            this.ProviderErrorText = localArgs.EventArgs.ProviderErrorText;

            Console.WriteLine("\nEvent Received For ProviderErrorCode " + this.ProviderErrorCode);
            Console.WriteLine("\nEvent Received For ProviderErrorText " + this.ProviderErrorText);
        }

        /// <summary>The on Request Xml event.</summary>
        /// <param name="args">The args.</param>
        private void OnRequestEvent(EventPattern<RequestEventArgs> args)
        {
            var localArgs = args;
            this.RequestXml = localArgs.EventArgs.RequestXml;

            Console.WriteLine("\nEvent Received For RequestXml " + this.RequestXml);
        }

        /// <summary>The on Request Xml event.</summary>
        /// <param name="args">The args.</param>
        private void OnResponseEvent(EventPattern<ResponseEventArgs> args)
        {
            var localArgs = args;
            this.ResponseXml = localArgs.EventArgs.ResponseXml;

            Console.WriteLine("\nEvent Received For ResponseXml " + this.ResponseXml);
        }

        #endregion
    }
}