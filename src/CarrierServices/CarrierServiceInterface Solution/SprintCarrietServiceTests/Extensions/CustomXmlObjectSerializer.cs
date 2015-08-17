// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CustomXmlObjectSerializer.cs" company="">
//   
// </copyright>
// <summary>
//   The custom xml object serializer.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.Runtime.Serialization;
    using System.Xml;
    using System.Xml.Serialization;

    using SprintCarrierServiceTests.Annotations;

    /// <summary>The custom xml object serializer.</summary>
    public class CustomXmlObjectSerializer : XmlObjectSerializer
    {
        #region Fields

        /// <summary>The root name.</summary>
        private string rootName;

        /// <summary>The root namespace.</summary>
        private string rootNamespace;

        /// <summary>The serializer.</summary>
        private XmlSerializer serializer;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="CustomXmlObjectSerializer"/> class.</summary>
        /// <param name="typeToSerialize">The type to serialize.</param>
        public CustomXmlObjectSerializer(Type typeToSerialize)
        {
            this.Initialize(typeToSerialize, null, null);
        }

        /// <summary>Initializes a new instance of the <see cref="CustomXmlObjectSerializer"/> class.</summary>
        /// <param name="typeToSerialize">The type to serialize.</param>
        /// <param name="qualifiedName">The qualified name.</param>
        /// <exception cref="ArgumentException"></exception>
        public CustomXmlObjectSerializer(Type typeToSerialize, XmlQualifiedName qualifiedName)
        {
            if (qualifiedName == null)
            {
                throw new ArgumentException("qualifiedName");
            }

            this.Initialize(typeToSerialize, qualifiedName.Name, qualifiedName.Namespace);
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The is start object.</summary>
        /// <param name="reader">The reader.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        /// <exception cref="ArgumentException"></exception>
        public override bool IsStartObject(XmlDictionaryReader reader)
        {
            if (reader == null)
            {
                throw new ArgumentException("reader");
            }

            reader.MoveToElement();
            if (this.rootName != null)
            {
                return reader.IsStartElement(this.rootName, this.rootNamespace);
            }

            return reader.IsStartElement();
        }

        /// <summary>The read object.</summary>
        /// <param name="reader">The reader.</param>
        /// <param name="verifyObjectName">The verify object name.</param>
        /// <returns>The <see cref="object"/>.</returns>
        /// <exception cref="ArgumentException"></exception>
        public override object ReadObject(XmlDictionaryReader reader, bool verifyObjectName)
        {
            if (reader == null)
            {
                throw new ArgumentException("reader");
            }

            return this.serializer.Deserialize(reader);
        }

        /// <summary>The write end object.</summary>
        /// <param name="writer">The writer.</param>
        /// <exception cref="NotSupportedException"></exception>
        public override void WriteEndObject(XmlDictionaryWriter writer)
        {
            throw new NotSupportedException();
        }

        /// <summary>The write object.</summary>
        /// <param name="writer">The writer.</param>
        /// <param name="graph">The graph.</param>
        /// <exception cref="ArgumentException"></exception>
        public override void WriteObject(XmlDictionaryWriter writer, object graph)
        {
            if (writer == null)
            {
                throw new ArgumentException("writer");
            }

            this.serializer.Serialize(writer, graph);
        }

        /// <summary>The write object content.</summary>
        /// <param name="writer">The writer.</param>
        /// <param name="graph">The graph.</param>
        /// <exception cref="ArgumentException"></exception>
        public override void WriteObjectContent(XmlDictionaryWriter writer, object graph)
        {
            if (writer == null)
            {
                throw new ArgumentException("writer");
            }

            if (writer.WriteState != WriteState.Element)
            {
                throw new ArgumentException(string.Format("WriteState '{0}' is in-valid.", writer.WriteState));
            }

            this.serializer.Serialize(writer, graph);
        }

        /// <summary>The write start object.</summary>
        /// <param name="writer">The writer.</param>
        /// <param name="graph">The graph.</param>
        /// <exception cref="NotSupportedException"></exception>
        public override void WriteStartObject(XmlDictionaryWriter writer, object graph)
        {
            throw new NotSupportedException();
        }

        #endregion

        #region Methods

        /// <summary>The initialize.</summary>
        /// <param name="type">The type.</param>
        /// <param name="rootName">The root name.</param>
        /// <param name="rootNamespace">The root namespace.</param>
        /// <exception cref="ArgumentException"></exception>
        private void Initialize([NotNull] Type type, [NotNull] string rootName, [NotNull] string rootNamespace)
        {
            if (type == null)
            {
                throw new ArgumentException("type");
            }

            this.rootName = rootName;
            this.rootNamespace = rootNamespace ?? string.Empty;
            if (this.rootName == null)
            {
                // this.serializer = new XmlSerializer(type);
            }
            else
            {
                var xmlRoot = new XmlRootAttribute { ElementName = this.rootName, Namespace = this.rootNamespace };
                this.serializer = new XmlSerializer(type, xmlRoot);
            }
        }

        #endregion
    }
}