// --------------------------------------------------------------------------------------------------------------------
// <copyright file="StrippingChannelFactory.cs" company="">
//   
// </copyright>
// <summary>
//   The stripping channel factory.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.WCF
{
    using System;
    using System.ServiceModel;
    using System.ServiceModel.Channels;

    /// <summary>The stripping channel factory.</summary>
    /// <typeparam name="TChannel"></typeparam>
    internal class StrippingChannelFactory<TChannel> : ChannelFactoryBase<TChannel>
    {
        #region Fields

        /// <summary>The inner channel factory.</summary>
        private IChannelFactory<TChannel> innerChannelFactory;

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the inner channel factory.</summary>
        public IChannelFactory<TChannel> InnerChannelFactory
        {
            get
            {
                return this.innerChannelFactory;
            }

            set
            {
                this.innerChannelFactory = value;
            }
        }

        #endregion

        #region Methods

        /// <summary>The on begin open.</summary>
        /// <param name="timeout">The timeout.</param>
        /// <param name="callback">The callback.</param>
        /// <param name="state">The state.</param>
        /// <returns>The <see cref="IAsyncResult"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        protected override IAsyncResult OnBeginOpen(TimeSpan timeout, AsyncCallback callback, object state)
        {
            throw new NotImplementedException();
        }

        /// <summary>The on create channel.</summary>
        /// <param name="to">The to.</param>
        /// <param name="via">The via.</param>
        /// <returns>The <see cref="TChannel"/>.</returns>
        protected override TChannel OnCreateChannel(EndpointAddress to, Uri via)
        {
            TChannel innerchannel = this.innerChannelFactory.CreateChannel(to, via);
            if (typeof(TChannel) == typeof(IRequestChannel))
            {
                var cachereqCnl = new StrippingRequestChannel((IRequestChannel)innerchannel);
                return (TChannel)(object)cachereqCnl;
            }

            return innerchannel;
        }

        /// <summary>The on end open.</summary>
        /// <param name="result">The result.</param>
        /// <exception cref="NotImplementedException"></exception>
        protected override void OnEndOpen(IAsyncResult result)
        {
            throw new NotImplementedException();
        }

        /// <summary>The on open.</summary>
        /// <param name="timeout">The timeout.</param>
        protected override void OnOpen(TimeSpan timeout)
        {
            this.innerChannelFactory.Open(timeout);
        }

        #endregion
    }
}