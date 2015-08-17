// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SimpleBehaviorExtensionElement.cs" company="">
//   
// </copyright>
// <summary>
//   The simple behavior extension element.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.WCF
{
    using System;
    using System.ServiceModel.Configuration;

    /// <summary>The simple behavior extension element.</summary>
    public class SimpleBehaviorExtensionElement : BehaviorExtensionElement
    {
        #region Public Properties

        /// <summary>Gets the behavior type.</summary>
        public override Type BehaviorType
        {
            get
            {
                return typeof(SimpleEndpointBehavior);
            }
        }

        #endregion

        #region Methods

        /// <summary>The create behavior.</summary>
        /// <returns>The <see cref="object"/>.</returns>
        protected override object CreateBehavior()
        {
            // Create the  endpoint behavior that will insert the message
            // inspector into the client runtime
            return new SimpleEndpointBehavior();
        }

        #endregion
    }
}