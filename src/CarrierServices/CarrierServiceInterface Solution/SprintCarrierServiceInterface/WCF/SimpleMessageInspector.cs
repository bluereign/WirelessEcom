// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SimpleMessageInspector.cs" company="">
//   
// </copyright>
// <summary>
//   The simple message inspector.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.WCF
{
    using System;
    using System.Diagnostics;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Dispatcher;
    using System.Xml;
    using System.Xml.Linq;

    using SprintCSI.Utils;

    /// <summary>The simple message inspector.</summary>
    public class SimpleMessageInspector : IClientMessageInspector, IDispatchMessageInspector
    {
        #region Public Events

        /// <summary>The simple event.</summary>
        public static event EventHandler<ErrorEventArgs> ErrorEvent;

        /// <summary>The request event.</summary>
        public static event EventHandler<RequestEventArgs> RequestEvent;

        /// <summary>The response event.</summary>
        public static event EventHandler<ResponseEventArgs> ResponseEvent;

        #endregion

        #region Public Methods and Operators

        /// <summary>The after receive reply.</summary>
        /// <param name="reply">The reply.</param>
        /// <param name="correlationState">The correlation state.</param>
        void IClientMessageInspector.AfterReceiveReply(ref Message reply, object correlationState)
        {
            // Console.WriteLine("====SimpleMessageInspector+AfterReceiveReply is called=====");
            //if (null != ResponseEvent)
            //{
            //    ResponseEvent(null, new ResponseEventArgs(reply.ToString()));
            //}

            MessageBuffer buffer = reply.CreateBufferedCopy(int.MaxValue);

            //if (!reply.IsFault)
            //{
            //    // This code prevents the InvalidOperationException - This message cannot support the operation because it has been copied
            //    reply = buffer.CreateMessage();
            //    buffer.Close();
            //    return;
            //}

            //XmlDictionaryReader xdr = buffer.CreateMessage().GetReaderAtBodyContents();

            //var xmlHelper = new XmlHelper { XmlString = XNode.ReadFrom(xdr).ToString() };

            //Trace.WriteLine("\nxmlString ==> " + xmlHelper.XmlString);

            //string errorDetailItem = xmlHelper.GetXmlValue("errorDetailItem", false);

            //// Trace.WriteLine("\nerrorDetailItem ==> " + errorDetailItem);
            //if (errorDetailItem != null)
            //{
            //    string providerErrorCode = xmlHelper.GetXmlValue("providerErrorCode", false);
            //    string providerErrorText = xmlHelper.GetXmlValue("providerErrorText", false);
            //    Trace.WriteLine("\nproviderErrorCode ==> " + providerErrorCode);
            //    Trace.WriteLine("\nproviderErrorText ==> " + providerErrorText);

            //    // Inform subscriber that error information is available
            //    if (null != ErrorEvent)
            //    {
            //        ErrorEvent(null, new ErrorEventArgs(providerErrorCode, providerErrorText));
            //    }
            //}

            // This code prevents the InvalidOperationException - This message cannot support the operation because it has been copied
            reply = buffer.CreateMessage();
            buffer.Close();
        }

        /// <summary>The after receive request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="channel">The channel.</param>
        /// <param name="instanceContext">The instance context.</param>
        /// <returns>The <see cref="object"/>.</returns>
        object IDispatchMessageInspector.AfterReceiveRequest(ref Message request, IClientChannel channel, InstanceContext instanceContext)
        {
            return null;
        }

        /// <summary>The before send reply.</summary>
        /// <param name="reply">The reply.</param>
        /// <param name="correlationState">The correlation state.</param>
        void IDispatchMessageInspector.BeforeSendReply(ref Message reply, object correlationState)
        {
        }

        /// <summary>The before send request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="channel">The channel.</param>
        /// <returns>The <see cref="object"/>.</returns>
        object IClientMessageInspector.BeforeSendRequest(ref Message request, IClientChannel channel)
        {
            // Console.WriteLine("====SimpleMessageInspector+BeforeSendRequest is called=====");

            // modify the request send from client(only customize message body)
            // request = this.TransformMessage2(request);

            // may modify the entire message
            // request = TransformMessage(request);
            if (null != RequestEvent)
            {
                RequestEvent(null, new RequestEventArgs(request.ToString()));
            }

            return null;
        }

        #endregion

        // helper method
        // reformat the entire  message
    }
}