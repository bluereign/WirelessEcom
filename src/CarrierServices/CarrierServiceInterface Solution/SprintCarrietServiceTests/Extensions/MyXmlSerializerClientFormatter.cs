// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MyXmlSerializerClientFormatter.cs" company="">
//   
// </copyright>
// <summary>
//   The my xml serializer client formatter.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Dispatcher;

    /// <summary>The my xml serializer client formatter.</summary>
    public class MyXmlSerializerClientFormatter : IClientMessageFormatter
    {
        #region Fields

        /// <summary>The inner formatter.</summary>
        private readonly IClientMessageFormatter innerFormatter;

        /// <summary>The xml object serializer.</summary>
        private readonly CustomXmlObjectSerializer xmlObjectSerializer;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="MyXmlSerializerClientFormatter"/> class.</summary>
        /// <param name="innerFormatter">The inner formatter.</param>
        public MyXmlSerializerClientFormatter(IClientMessageFormatter innerFormatter)
        {
            
            this.innerFormatter = innerFormatter;
            this.xmlObjectSerializer = new CustomXmlObjectSerializer(typeof(MyRequest));
        }

        ///// <summary>Initializes a new instance of the <see cref="MyXmlSerializerClientFormatter" /> class.</summary>
        //public MyXmlSerializerClientFormatter()
        //{
        //    this.xmlObjectSerializer = new CustomXmlObjectSerializer(typeof(MyRequest));
        //}

        #endregion

        #region Public Methods and Operators

        /// <summary>The deserialize reply.</summary>
        /// <param name="message">The message.</param>
        /// <param name="parameters">The parameters.</param>
        /// <returns>The <see cref="object"/>.</returns>
        /// <exception cref="NotSupportedException"></exception>
        object IClientMessageFormatter.DeserializeReply(Message message, object[] parameters)
        {
            // var reply = this.innerFormatter.DeserializeReply(message, parameters);
            // var flaggedObjects = new List<object>();
            Trace.WriteLine("\nIClientMessageFormatter.DeserializeReply ==> \n");
            return this.innerFormatter.DeserializeReply(message, parameters);
            
        }

        /// <summary>The serialize request.</summary>
        /// <param name="messageVersion">The message version.</param>
        /// <param name="parameters">The parameters.</param>
        /// <returns>The <see cref="Message"/>.</returns>
        Message IClientMessageFormatter.SerializeRequest(MessageVersion messageVersion, object[] parameters)
        {
            //// In our sample, we pass only one parameter to the operation
            //Debug.Assert(parameters.Length == 1, "Only 1 parameter accepted in this implementation");

            //// Serialize the body according to the first parameter
            //var message = Message.CreateMessage(messageVersion, string.Empty, parameters[0], this.xmlObjectSerializer);

            //return message;
            return this.innerFormatter.SerializeRequest(messageVersion, parameters);
        }

        #endregion

        /// <summary>The temporary placeholder class.</summary>
        public class MyRequest
        {
            #region Public Properties

            /// <summary>Gets or sets the meid.</summary>
            public string Meid { get; set; }

            /// <summary>Gets or sets the sprint order id.</summary>
            public string SprintOrderId { get; set; }

            #endregion

            #region Properties

            /// <summary>Gets or sets the transaction order id.</summary>
            internal string TransactionOrderId { get; set; }

            #endregion
        }
    }
}