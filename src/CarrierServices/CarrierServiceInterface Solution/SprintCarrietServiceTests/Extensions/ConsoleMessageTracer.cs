// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConsoleMessageTracer.cs" company="">
//   
// </copyright>
// <summary>
//   The console message tracer.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Dispatcher;

    /// <summary>The console message tracer.</summary>
    public class ConsoleMessageTracer : IDispatchMessageInspector, IClientMessageInspector
    {
        #region Public Methods and Operators

        /// <summary>The after receive reply.</summary>
        /// <param name="reply">The reply.</param>
        /// <param name="correlationState">The correlation state.</param>
        void IClientMessageInspector.AfterReceiveReply(ref Message reply, object correlationState)
        {
            reply = this.TraceMessage(reply.CreateBufferedCopy(int.MaxValue));
        }

        /// <summary>The after receive request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="channel">The channel.</param>
        /// <param name="instanceContext">The instance context.</param>
        /// <returns>The <see cref="object"/>.</returns>
        object IDispatchMessageInspector.AfterReceiveRequest(ref Message request, IClientChannel channel, InstanceContext instanceContext)
        {
            request = this.TraceMessage(request.CreateBufferedCopy(int.MaxValue));
            return null;
        }

        /// <summary>The before send reply.</summary>
        /// <param name="reply">The reply.</param>
        /// <param name="correlationState">The correlation state.</param>
        void IDispatchMessageInspector.BeforeSendReply(ref Message reply, object correlationState)
        {
            reply = this.TraceMessage(reply.CreateBufferedCopy(int.MaxValue));
        }

        /// <summary>The before send request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="channel">The channel.</param>
        /// <returns>The <see cref="object"/>.</returns>
        object IClientMessageInspector.BeforeSendRequest(ref Message request, IClientChannel channel)
        {
            request = this.TraceMessage(request.CreateBufferedCopy(int.MaxValue));
            return null;
        }

        #endregion

        #region Methods

        /// <summary>The trace message.</summary>
        /// <param name="buffer">The buffer.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        private Message TraceMessage(MessageBuffer buffer)
        {
            var msg = buffer.CreateMessage();
            Console.WriteLine("\n{0}\n", msg);
            return buffer.CreateMessage();
        }

        #endregion
    }
}