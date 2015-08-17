// --------------------------------------------------------------------------------------------------------------------
// <copyright file="InterceptChannelBindingElementExtensionElement.cs" company="">
//   
// </copyright>
// <summary>
//   The intercept channel binding element extension element.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.WCF
{
    using System;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Configuration;

    /// <summary>The intercept channel binding element extension element.</summary>
    internal class InterceptChannelBindingElementExtensionElement : BindingElementExtensionElement
    {
        #region Public Properties

        /// <summary>Gets the binding element type.</summary>
        public override Type BindingElementType
        {
            get
            {
                return typeof(InterceptChannelBindingElement);
            }
        }

        #endregion

        #region Methods

        /// <summary>The create binding element.</summary>
        /// <returns>The <see cref="BindingElement" />.</returns>
        protected override BindingElement CreateBindingElement()
        {
            return new InterceptChannelBindingElement();
        }

        #endregion
    }
}