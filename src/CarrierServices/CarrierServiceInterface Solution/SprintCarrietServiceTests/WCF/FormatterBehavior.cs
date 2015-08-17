// --------------------------------------------------------------------------------------------------------------------
// <copyright file="FormatterBehavior.cs" company="">
//   
// </copyright>
// <summary>
//   The formatter behavior.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests
{
    using System;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;
    using System.Xml.XPath;

    // This operation behavior changes the formatter for a specific set of operations in a web service. 
    /// <summary>The formatter behavior.</summary>
    public class FormatterBehavior : IOperationBehavior
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
            // The client should use a different, custom formatter depending upon which operation is called.
            switch (operationDescription.Name)
            {
                case "ValidateDeviceV8":
                    clientOperation.Formatter = new MyCustomFormatter1(clientOperation.Formatter);
                    break;
                case "getSomethingElse":

                    // clientOperation.Formatter = new MyCustomFormatter2(clientOperation.Formatter);
                    break;
            }
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

    // This customized formatter intercepts the deserialization process and handles it manually.
    /// <summary>The my custom formatter 1.</summary>
    public class MyCustomFormatter1 : IClientMessageFormatter
    {
        // Hold on to the original formatter so we can use it to return values for method calls we don't need.
        #region Fields

        /// <summary>The inner formatter.</summary>
        private readonly IClientMessageFormatter innerFormatter;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="MyCustomFormatter1"/> class.</summary>
        /// <param name="innerFormatter">The inner formatter.</param>
        public MyCustomFormatter1(IClientMessageFormatter innerFormatter)
        {
            // Save the original formatter
            this.innerFormatter = innerFormatter;
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The deserialize reply.</summary>
        /// <param name="message">The message.</param>
        /// <param name="parameters">The parameters.</param>
        /// <returns>The <see cref="object"/>.</returns>
        object IClientMessageFormatter.DeserializeReply(Message message, object[] parameters)
        {
            // Create a new response object.
            var retVal = new MyCustomResponseObject();
            var doc = new XPathDocument(message.GetReaderAtBodyContents());
            XPathNavigator nav = doc.CreateNavigator();

            //// Pulling out the data we need from the XML
            // foreach (XPathNavigator item in nav.Select...())
            // {
            // // Populate retVal with the data we need from the XML
            // }

            // IMPORTANT: Be sure to change the return type of the operation (and also its interface) in
            // the service's Reference.cs file to object or you will get a cast error.
            return retVal;
        }

        /// <summary>The serialize request.</summary>
        /// <param name="messageVersion">The message version.</param>
        /// <param name="parameters">The parameters.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        Message IClientMessageFormatter.SerializeRequest(MessageVersion messageVersion, object[] parameters)
        {
            // Use the inner formatter for this so we don't have to rebuild it.
            return this.innerFormatter.SerializeRequest(messageVersion, parameters);
        }

        #endregion
    }

    /// <summary>The my custom formatter 2.</summary>
    public class MyCustomFormatter2 : IClientMessageFormatter
    {
        // ...
        #region Public Methods and Operators

        /// <summary>The deserialize reply.</summary>
        /// <param name="message">The message.</param>
        /// <param name="parameters">The parameters.</param>
        /// <returns>The <see cref="object"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        object IClientMessageFormatter.DeserializeReply(Message message, object[] parameters)
        {
            throw new NotImplementedException();
        }

        /// <summary>The serialize request.</summary>
        /// <param name="messageVersion">The message version.</param>
        /// <param name="parameters">The parameters.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        Message IClientMessageFormatter.SerializeRequest(MessageVersion messageVersion, object[] parameters)
        {
            throw new NotImplementedException();
        }

        #endregion
    }
}

/// <summary>The my custom response object.</summary>
public class MyCustomResponseObject
{
    #region Public Properties

    /// <summary>Gets or sets the demo.</summary>
    public string demo { get; set; }

    #endregion
}