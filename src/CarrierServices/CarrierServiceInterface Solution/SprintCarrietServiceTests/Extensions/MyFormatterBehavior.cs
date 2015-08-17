// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MyFormatterBehavior.cs" company="">
//   
// </copyright>
// <summary>
//   The my formatter behavior.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.Extensions
{
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;

    /// <summary>The my formatter behavior.</summary>
    public class MyFormatterBehavior : IOperationBehavior
    {
        #region Public Methods and Operators

        /// <summary>The add binding parameters.</summary>
        /// <param name="operationDescription">The operation description.</param>
        /// <param name="bindingParameters">The binding parameters.</param>
        void IOperationBehavior.AddBindingParameters(OperationDescription operationDescription, BindingParameterCollection bindingParameters)
        {
        }

        /// <summary>The apply client behavior.</summary>
        /// <param name="operationDescription">The operation description.</param>
        /// <param name="clientOperation">The client operation.</param>
        void IOperationBehavior.ApplyClientBehavior(OperationDescription operationDescription, ClientOperation clientOperation)
        {
            clientOperation.Formatter = new MyXmlSerializerClientFormatter(clientOperation.Formatter);
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="operationDescription">The operation description.</param>
        /// <param name="dispatchOperation">The dispatch operation.</param>
        void IOperationBehavior.ApplyDispatchBehavior(OperationDescription operationDescription, DispatchOperation dispatchOperation)
        {
        }

        /// <summary>The validate.</summary>
        /// <param name="operationDescription">The operation description.</param>
        void IOperationBehavior.Validate(OperationDescription operationDescription)
        {
        }

        #endregion
    }
}