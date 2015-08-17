// --------------------------------------------------------------------------------------------------------------------
// <copyright file="InterceptChannelBindingElement.cs" company="">
//   
// </copyright>
// <summary>
//   The stripping channel binding element.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.WCF
{
    using System.ServiceModel.Channels;

    /// <summary>The intercept channel binding element.</summary>
    internal class InterceptChannelBindingElement : BindingElement
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="InterceptChannelBindingElement" /> class.</summary>
        public InterceptChannelBindingElement()
        {
        }

        /// <summary>Initializes a new instance of the <see cref="InterceptChannelBindingElement"/> class.</summary>
        /// <param name="other">The other.</param>
        protected InterceptChannelBindingElement(InterceptChannelBindingElement other)
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
            var cachecf = new InterceptChannelFactory<TChannel> { InnerChannelFactory = context.BuildInnerChannelFactory<TChannel>() };
            return cachecf;
        }

        /// <summary>The clone.</summary>
        /// <returns>The <see cref="BindingElement" />.</returns>
        public override BindingElement Clone()
        {
            var other = new InterceptChannelBindingElement(this);
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