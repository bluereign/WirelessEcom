// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SimpleMessageInspector.cs" company="">
//   
// </copyright>
// <summary>
//   The simple message inspector.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Dispatcher;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.XPath;

    using SprintCSI.Utils;

    using ErrorEventArgs = SprintCarrierServiceTests.WCF.ErrorEventArgs;

    /// <summary>The simple message inspector.</summary>
    public class SimpleMessageInspector : IClientMessageInspector, IDispatchMessageInspector
    {
        // <summary>The simple event.</summary>
        #region Public Events

        /// <summary>The error event.</summary>
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
        public void AfterReceiveReply(ref Message reply, object correlationState)
        {
            if (null != ResponseEvent)
            {
                ResponseEvent(null, new ResponseEventArgs(reply.ToString()));
            }

            // Console.WriteLine("====SimpleMessageInspector+AfterReceiveReply is called=====");
            if (!reply.IsFault)
            {
                return;
            }

            MessageBuffer buffer = reply.CreateBufferedCopy(int.MaxValue);
            XmlDictionaryReader xdr = buffer.CreateMessage().GetReaderAtBodyContents();

            var xmlHelper = new XmlHelper { XmlString = XNode.ReadFrom(xdr).ToString() };

            Trace.WriteLine("\nAfterReceiveReply xmlString ==> " + xmlHelper.XmlString);

            string errorDetailItem = xmlHelper.GetXmlValue("errorDetailItem", false);

            // Trace.WriteLine("\nerrorDetailItem ==> " + errorDetailItem);
            if (errorDetailItem != null)
            {
                string providerErrorCode = xmlHelper.GetXmlValue("providerErrorCode", false);
                string providerErrorText = xmlHelper.GetXmlValue("providerErrorText", false);
                Trace.WriteLine("\nAfterReceiveReply providerErrorCode ==> " + providerErrorCode);
                Trace.WriteLine("\nAfterReceiveReply providerErrorText ==> " + providerErrorText);

                // Inform subscriber that error information is available
                if (null != ErrorEvent)
                {
                    ErrorEvent(null, new ErrorEventArgs(providerErrorCode, providerErrorText));
                }
            }

            // This code prevents the InvalidOperationException - This message cannot support the operation because it has been copied
            reply = buffer.CreateMessage();
            buffer.Close();
        }

        /// <summary>The after receive request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="channel">The channel.</param>
        /// <param name="instanceContext">The instance context.</param>
        /// <returns>The <see cref="object"/>.</returns>
        public object AfterReceiveRequest(ref Message request, IClientChannel channel, InstanceContext instanceContext)
        {
            return null;
        }

        /// <summary>The before send reply.</summary>
        /// <param name="reply">The reply.</param>
        /// <param name="correlationState">The correlation state.</param>
        public void BeforeSendReply(ref Message reply, object correlationState)
        {
        }

        /// <summary>The before send request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="channel">The channel.</param>
        /// <returns>The <see cref="object"/>.</returns>
        public object BeforeSendRequest(ref Message request, IClientChannel channel)
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
        #region Methods

        /// <summary>The transform message.</summary>
        /// <param name="oldMessage">The old message.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        private Message TransformMessage(Message oldMessage)
        {
            Message newMessage;
            MessageBuffer msgbuf = oldMessage.CreateBufferedCopy(int.MaxValue);
            XPathNavigator nav = msgbuf.CreateNavigator();

            // load the old message into xmldocument
            var ms = new MemoryStream();
            XmlWriter xw = XmlWriter.Create(ms);
            nav.WriteSubtree(xw);
            xw.Flush();
            xw.Close();

            ms.Position = 0;
            XDocument xdoc = XDocument.Load(XmlReader.Create(ms));

            // perform transformation
            IEnumerable<XElement> strElms = xdoc.Descendants(XName.Get("StringValue", "urn:test:datacontracts"));
            foreach (XElement strElm in strElms)
            {
                strElm.Value = "[Modified in SimpleMessageInspector]" + strElm.Value;
            }

            xw = XmlWriter.Create(ms);
            ms.Position = 0;
            xdoc.Save(xw);
            xw.Flush();
            xw.Close();

            ms.Position = 0;
            var sr = new StreamReader(ms);
            Console.WriteLine(sr.ReadToEnd());

            // create the new message
            ms.Position = 0;
            XmlDictionaryReader xdr = XmlDictionaryReader.CreateTextReader(ms, new XmlDictionaryReaderQuotas());
            newMessage = Message.CreateMessage(xdr, int.MaxValue, oldMessage.Version);

            return newMessage;
        }

        // only read and modify the Message Body part
        /// <summary>The transform message 2.</summary>
        /// <param name="oldMessage">The old message.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        private Message TransformMessage2(Message oldMessage)
        {
            // load the old message into XML
            MessageBuffer msgbuf = oldMessage.CreateBufferedCopy(int.MaxValue);

            Message tmpMessage = msgbuf.CreateMessage();
            XmlDictionaryReader xdr = tmpMessage.GetReaderAtBodyContents();

            var xdoc = new XmlDocument();
            xdoc.Load(xdr);
            xdr.Close();

            // transform the xmldocument
            var nsmgr = new XmlNamespaceManager(xdoc.NameTable);
            nsmgr.AddNamespace("a", "urn:test:datacontracts");

            XmlNode node = xdoc.SelectSingleNode("//a:StringValue", nsmgr);
            if (node != null)
            {
                node.InnerText = "[Modified in SimpleMessageInspector]" + node.InnerText;
            }

            var ms = new MemoryStream();
            XmlWriter xw = XmlWriter.Create(ms);
            xdoc.Save(xw);
            xw.Flush();
            xw.Close();

            ms.Position = 0;
            XmlReader xr = XmlReader.Create(ms);

            // create new message from modified XML document
            Message newMessage = Message.CreateMessage(oldMessage.Version, null, xr);
            newMessage.Headers.CopyHeadersFrom(oldMessage);
            newMessage.Properties.CopyProperties(oldMessage.Properties);

            return newMessage;
        }

        #endregion
    }
}