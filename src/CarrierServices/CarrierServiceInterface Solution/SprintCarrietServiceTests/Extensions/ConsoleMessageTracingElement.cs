// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConsoleMessageTracingElement.cs" company="">
//   
// </copyright>
// <summary>
//   The console message tracing element.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.ServiceModel.Configuration;

    /// <summary>The console message tracing element.</summary>
    public class ConsoleMessageTracingElement : BehaviorExtensionElement
    {
        #region Public Properties

        /// <summary>Gets the behavior type.</summary>
        public override Type BehaviorType
        {
            get
            {
                return typeof(ConsoleMessageTracing);
            }
        }

        #endregion

        #region Methods

        /// <summary>The create behavior.</summary>
        /// <returns>The <see cref="object"/>.</returns>
        protected override object CreateBehavior()
        {
            return new ConsoleMessageTracing();
        }

        #endregion
    }
}