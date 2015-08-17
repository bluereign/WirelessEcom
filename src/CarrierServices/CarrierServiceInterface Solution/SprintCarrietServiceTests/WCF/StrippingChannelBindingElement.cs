// --------------------------------------------------------------------------------------------------------------------
// <copyright file="StrippingChannelBindingElement.cs" company="">
//   
// </copyright>
// <summary>
//   The stripping channel binding element.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.WCF
{
    using System.ServiceModel.Channels;

    /// <summary>The stripping channel binding element.</summary>
    internal class StrippingChannelBindingElement : BindingElement
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="StrippingChannelBindingElement" /> class.</summary>
        public StrippingChannelBindingElement()
        {
        }

        /// <summary>Initializes a new instance of the <see cref="StrippingChannelBindingElement"/> class.</summary>
        /// <param name="other">The other.</param>
        protected StrippingChannelBindingElement(StrippingChannelBindingElement other)
            : base(other)
        {
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The build channel factory.</summary>
        /// <param name="context">The context.</param>
        /// <typeparam name="TChannel"></typeparam>
        /// <returns>The <see cref="IChannelFactory"/>.</returns>
        public override IChannelFactory<TChannel> BuildChannelFactory<TChannel>(BindingContext context)
        {
            var cachecf = new StrippingChannelFactory<TChannel> { InnerChannelFactory = context.BuildInnerChannelFactory<TChannel>() };
            return cachecf;
        }

        /// <summary>The clone.</summary>
        /// <returns>The <see cref="BindingElement" />.</returns>
        public override BindingElement Clone()
        {
            var other = new StrippingChannelBindingElement(this);
            return other;
        }

        /// <summary>The get property.</summary>
        /// <param name="context">The context.</param>
        /// <typeparam name="T"></typeparam>
        /// <returns>The <see cref="T"/>.</returns>
        public override T GetProperty<T>(BindingContext context)
        {
            return context.GetInnerProperty<T>();
        }

        #endregion
    }
}