// --------------------------------------------------------------------------------------------------------------------
// <copyright file="XsdValidationInspector.cs" company="">
//   
// </copyright>
// <summary>
//   The xsd validation inspector.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Dispatcher;
    using System.Xml;
    using System.Xml.Schema;

    /// <summary>The xsd validation inspector.</summary>
    public class XsdValidationInspector : IDispatchMessageInspector
    {
        #region Fields

        /// <summary>The schemas.</summary>
        private readonly XmlSchemaSet schemas;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="XsdValidationInspector"/> class.</summary>
        /// <param name="schemas">The schemas.</param>
        public XsdValidationInspector(XmlSchemaSet schemas)
        {
            this.schemas = schemas;
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The after receive request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="channel">The channel.</param>
        /// <param name="instanceContext">The instance context.</param>
        /// <returns>The <see cref="object"/>.</returns>
        /// <exception cref="FaultException"></exception>
        object IDispatchMessageInspector.AfterReceiveRequest(ref Message request, IClientChannel channel, InstanceContext instanceContext)
        {
            var buffer = request.CreateBufferedCopy(int.MaxValue);

            try
            {
                var settings = new XmlReaderSettings();
                settings.Schemas.Add(this.schemas);
                settings.ValidationType = ValidationType.Schema;

                var msgToValidate = buffer.CreateMessage();
                var reader = XmlReader.Create(msgToValidate.GetReaderAtBodyContents().ReadSubtree(), settings);

                while (reader.Read())
                {
                    ; // do nothing, just validate
                }

                request = buffer.CreateMessage();
            }
            catch (Exception e)
            {
                throw new FaultException(e.Message);
            }

            return null;
        }

        /// <summary>The before send reply.</summary>
        /// <param name="reply">The reply.</param>
        /// <param name="correlationState">The correlation state.</param>
        void IDispatchMessageInspector.BeforeSendReply(ref Message reply, object correlationState)
        {
        }

        #endregion
    }
}