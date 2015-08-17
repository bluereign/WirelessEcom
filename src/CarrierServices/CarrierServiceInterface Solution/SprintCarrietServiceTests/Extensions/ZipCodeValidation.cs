// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ZipCodeValidation.cs" company="">
//   
// </copyright>
// <summary>
//   The zip code validation.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;

    /// <summary>The zip code validation.</summary>
    public class ZipCodeValidation : Attribute, IOperationBehavior
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
            var zipCodeInspector = new ZipCodeInspector();
            clientOperation.ParameterInspectors.Add(zipCodeInspector);
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="operationDescription">The operation description.</param>
        /// <param name="dispatchOperation">The dispatch operation.</param>
        void IOperationBehavior.ApplyDispatchBehavior(OperationDescription operationDescription, DispatchOperation dispatchOperation)
        {
            var zipCodeInspector = new ZipCodeInspector();
            dispatchOperation.ParameterInspectors.Add(zipCodeInspector);
        }

        /// <summary>The validate.</summary>
        /// <param name="operationDescription">The operation description.</param>
        void IOperationBehavior.Validate(OperationDescription operationDescription)
        {
        }

        #endregion
    }
}