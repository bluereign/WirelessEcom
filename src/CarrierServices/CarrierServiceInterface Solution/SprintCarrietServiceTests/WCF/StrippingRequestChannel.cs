// --------------------------------------------------------------------------------------------------------------------
// <copyright file="StrippingRequestChannel.cs" company="">
//   
// </copyright>
// <summary>
//   The stripping request channel.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.WCF
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.Xml;
    using System.Xml.XPath;

    /// <summary>The stripping request channel.</summary>
    internal class StrippingRequestChannel : IRequestChannel
    {
        #region Fields

        /// <summary>The _inner channel.</summary>
        private readonly IRequestChannel innerChannel;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="StrippingRequestChannel"/> class.</summary>
        /// <param name="innerchannel">The innerchannel.</param>
        public StrippingRequestChannel(IRequestChannel innerchannel)
        {
            this.innerChannel = innerchannel;

            // hook up event handlers
            innerchannel.Closed += (sender, e) =>
                {
                    if (this.Closed != null)
                    {
                        this.Closed(sender, e);
                    }
                };
            innerchannel.Closing += (sender, e) =>
                {
                    if (this.Closing != null)
                    {
                        this.Closing(sender, e);
                    }
                };
            innerchannel.Faulted += (sender, e) =>
                {
                    if (this.Faulted != null)
                    {
                        this.Faulted(sender, e);
                    }
                };
            innerchannel.Opened += (sender, e) =>
                {
                    if (this.Opened != null)
                    {
                        this.Opened(sender, e);
                    }
                };
            innerchannel.Opening += (sender, e) =>
                {
                    if (this.Opening != null)
                    {
                        this.Opening(sender, e);
                    }
                };
        }

        #endregion

        #region Public Events

        /// <summary>The closed.</summary>
        public event EventHandler Closed;

        /// <summary>The closing.</summary>
        public event EventHandler Closing;

        /// <summary>The faulted.</summary>
        public event EventHandler Faulted;

        /// <summary>The opened.</summary>
        public event EventHandler Opened;

        /// <summary>The opening.</summary>
        public event EventHandler Opening;

        #endregion

        #region Public Properties

        /// <summary>Gets the remote address.</summary>
        public EndpointAddress RemoteAddress
        {
            get
            {
                return this.innerChannel.RemoteAddress;
            }
        }

        /// <summary>Gets the state.</summary>
        public CommunicationState State
        {
            get
            {
                return this.innerChannel.State;
            }
        }

        // here must we process the request

        /// <summary>Gets the via.</summary>
        public Uri Via
        {
            get
            {
                return this.innerChannel.Via;
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The abort.</summary>
        public void Abort()
        {
            this.innerChannel.Abort();
        }

        /// <summary>The begin close.</summary>
        /// <param name="timeout">The timeout.</param>
        /// <param name="callback">The callback.</param>
        /// <param name="state">The state.</param>
        /// <returns>The <see cref="IAsyncResult"/>.</returns>
        public IAsyncResult BeginClose(TimeSpan timeout, AsyncCallback callback, object state)
        {
            return this.innerChannel.BeginClose(timeout, callback, state);
        }

        /// <summary>The begin close.</summary>
        /// <param name="callback">The callback.</param>
        /// <param name="state">The state.</param>
        /// <returns>The <see cref="IAsyncResult"/>.</returns>
        public IAsyncResult BeginClose(AsyncCallback callback, object state)
        {
            return this.innerChannel.BeginClose(callback, state);
        }

        /// <summary>The begin open.</summary>
        /// <param name="timeout">The timeout.</param>
        /// <param name="callback">The callback.</param>
        /// <param name="state">The state.</param>
        /// <returns>The <see cref="IAsyncResult"/>.</returns>
        public IAsyncResult BeginOpen(TimeSpan timeout, AsyncCallback callback, object state)
        {
            return this.innerChannel.BeginOpen(timeout, callback, state);
        }

        /// <summary>The begin open.</summary>
        /// <param name="callback">The callback.</param>
        /// <param name="state">The state.</param>
        /// <returns>The <see cref="IAsyncResult"/>.</returns>
        public IAsyncResult BeginOpen(AsyncCallback callback, object state)
        {
            return this.innerChannel.BeginOpen(callback, state);
        }

        /// <summary>The begin request.</summary>
        /// <param name="message">The message.</param>
        /// <param name="timeout">The timeout.</param>
        /// <param name="callback">The callback.</param>
        /// <param name="state">The state.</param>
        /// <returns>The <see cref="IAsyncResult"/>.</returns>
        public IAsyncResult BeginRequest(Message message, TimeSpan timeout, AsyncCallback callback, object state)
        {
            return this.innerChannel.BeginRequest(message, timeout, callback, state);
        }

        /// <summary>The begin request.</summary>
        /// <param name="message">The message.</param>
        /// <param name="callback">The callback.</param>
        /// <param name="state">The state.</param>
        /// <returns>The <see cref="IAsyncResult"/>.</returns>
        public IAsyncResult BeginRequest(Message message, AsyncCallback callback, object state)
        {
            return this.innerChannel.BeginRequest(message, callback, state);
        }

        /// <summary>The close.</summary>
        /// <param name="timeout">The timeout.</param>
        public void Close(TimeSpan timeout)
        {
            this.innerChannel.Close(timeout);
        }

        /// <summary>The close.</summary>
        public void Close()
        {
            this.innerChannel.Close();
        }

        /// <summary>The dispose.</summary>
        public void Dispose()
        {
            var d = this.innerChannel as IDisposable;
            if (d != null)
            {
                d.Dispose();
            }
        }

        /// <summary>The end close.</summary>
        /// <param name="result">The result.</param>
        public void EndClose(IAsyncResult result)
        {
            this.innerChannel.EndClose(result);
        }

        /// <summary>The end open.</summary>
        /// <param name="result">The result.</param>
        public void EndOpen(IAsyncResult result)
        {
            this.innerChannel.EndOpen(result);
        }

        /// <summary>The end request.</summary>
        /// <param name="result">The result.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        public Message EndRequest(IAsyncResult result)
        {
            return this.innerChannel.EndRequest(result);
        }

        /// <summary>The get property.</summary>
        /// <typeparam name="T"></typeparam>
        /// <returns>The <see cref="T"/>.</returns>
        public T GetProperty<T>() where T : class
        {
            return this.innerChannel.GetProperty<T>();
        }

        /// <summary>The open.</summary>
        /// <param name="timeout">The timeout.</param>
        public void Open(TimeSpan timeout)
        {
            this.innerChannel.Open(timeout);
        }

        /// <summary>The open.</summary>
        public void Open()
        {
            this.innerChannel.Open();
        }

        /// <summary>The request.</summary>
        /// <param name="message">The message.</param>
        /// <param name="timeout">The timeout.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        public Message Request(Message message, TimeSpan timeout)
        {
            // get response first
            var ret = this.innerChannel.Request(message, timeout);
            Trace.WriteLine("StrippingRequestChannel ==> " + ret);
            // need to create a copy first
            var buffer = ret.CreateBufferedCopy(int.MaxValue);

            var stream = new MemoryStream(1024);
            buffer.WriteMessage(stream);
            stream.Position = 0;

            // process XML using XmlDocument and XPathNavigator
            // note that this is not the most efficient way, but it's the simplest to demonstrate
            var doc = new XmlDocument();
            doc.Load(stream);

            var n = doc.CreateNavigator();

            // if (n.MoveToFollowing("BinarySecurityToken", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"))
            // n.DeleteSelf();

            // if (n.MoveToFollowing("Signature", "http://www.w3.org/2000/09/xmldsig#"))
            // n.DeleteSelf();
            if (n.MoveToFollowing("Timestamp", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"))
            {
                n.DeleteSelf();
            }

            n.MoveToRoot();
            var reader = n.ReadSubtree();

            // create message
            var strippedMessage = Message.CreateMessage(reader, int.MaxValue, ret.Version);
            return strippedMessage;
        }

        /// <summary>The request.</summary>
        /// <param name="message">The message.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        public Message Request(Message message)
        {
            var ret = this.Request(message, new TimeSpan(0, 1, 30));
            return ret;
        }

        #endregion
    }
}