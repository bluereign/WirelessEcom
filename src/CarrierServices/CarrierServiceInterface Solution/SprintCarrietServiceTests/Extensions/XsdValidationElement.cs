// --------------------------------------------------------------------------------------------------------------------
// <copyright file="XsdValidationElement.cs" company="">
//   
// </copyright>
// <summary>
//   The xsd validation element.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.ServiceModel.Configuration;

    /// <summary>The xsd validation element.</summary>
    public class XsdValidationElement : BehaviorExtensionElement
    {
        #region Public Properties

        /// <summary>Gets the behavior type.</summary>
        public override Type BehaviorType
        {
            get
            {
                return typeof(XsdValidation);
            }
        }

        #endregion

        #region Methods

        /// <summary>The create behavior.</summary>
        /// <returns>The <see cref="object"/>.</returns>
        protected override object CreateBehavior()
        {
            return new XsdValidation();
        }

        #endregion
    }
}