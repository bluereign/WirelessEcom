// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ErrorHandlerBehavior.cs" company="">
//   
// </copyright>
// <summary>
//   The error handler behavior.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.WCF
{
    using System;
    using System.Diagnostics;
    using System.ServiceModel.Configuration;

    /// <summary>The error handler behavior.</summary>
    public class ErrorHandlerBehavior : BehaviorExtensionElement
    {
        #region Public Properties

        /// <summary>Gets the behavior type.</summary>
        public override Type BehaviorType
        {
            get
            {
                Trace.WriteLine("ErrorHandlerBehavior.BehaviorType Called");
                return typeof(ErrorServiceBehavior);
            }
        }

        #endregion

        #region Methods

        /// <summary>The create behavior.</summary>
        /// <returns>The <see cref="object"/>.</returns>
        protected override object CreateBehavior()
        {
            Trace.WriteLine("ErrorHandlerBehavior.CreateBehavior Called");
            return new ErrorServiceBehavior();
        }

        #endregion
    }
}