// --------------------------------------------------------------------------------------------------------------------
// <copyright file="XmlHelper.cs" company="">
//   
// </copyright>
// <summary>
//   The xml helper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.Utils
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Serialization;

    using SprintCSI.Annotations;
    using SprintCSI.Response;
    using SprintCSI.ServiceImplementation;

    using WirelessAdvocates.Logger;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The xml helper.</summary>
    public class XmlHelper
    {
        #region Fields

        /// <summary>The failed element.</summary>
        private string failedElement = string.Empty;

        /// <summary>Gets or sets the doc.</summary>
        private XDocument doc;

        /// <summary>The xml string.</summary>
        private object xmlObj;

        /// <summary>The xml string.</summary>
        private string xmlString;

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the carrier name.</summary>
        public string CarrierName { get; set; }

        /// <summary>Gets or sets the ref num.</summary>
        public string RefNum { get; set; }

        /// <summary>Gets or sets the ref num.</summary>
        public XNamespace NameSpace { get; set; }

        /// <summary>Gets or sets the type name.</summary>
        public string TypeName { get; set; }

        /// <summary>Gets or sets the xml string.</summary>
        public object XmlObj
        {
            get
            {
                return this.xmlObj;
            }

            set
            {
                this.xmlObj = value;
                this.xmlString = null;
                this.doc = null;
            }
        }

        /// <summary>Gets or sets the xml string.</summary>
        public string XmlString
        {
            get
            {
                return this.xmlString;
            }

            set
            {
                this.xmlString = value;
                this.xmlObj = null;
                this.doc = null;
            }
        }

        #endregion

        #region Public Methods and Operators

        // Creates an object from an XML string.

        /// <summary>The deserialize old xml response.</summary>
        /// <param name="xml">The xml.</param>
        /// <returns>The <see cref="ovm"/>.</returns>
        public object DeserializeOldOvmXMLResponse(string xml)
        {
            return this.DeserializeXMLResponse(xml, typeof(RESPONSE.ovm));
        }

        /// <summary>The deserialize ovm xml response.</summary>
        /// <param name="xml">The xml.</param>
        /// <returns>The <see cref="object"/>.</returns>
        public object DeserializeOvmXMLResponse(string xml)
        {
            return this.DeserializeXMLResponse(xml, typeof(ovm));

            // NOTE [pcrawford,20140219] 
            // The following code will delete the offending element 
            // in the event of an InvalidOperationException

            //var obj = this.DeserializeXMLResponse(xml, typeof(ovm));
            //if (obj != null)
            //{
            //    return obj;
            //}

            //if (this.failedElement == string.Empty)
            //{
            //    return null;
            //}

            //var d = new XmlHelper { XmlString = xml };
            //d.DeleteElement(this.failedElement);
            //obj = this.DeserializeXMLResponse(d.GenerateXml(), typeof(ovm));
            //if (obj != null)
            //{
            //    return obj;
            //}

            //return null;
        }

        /// <summary>The extract failing element.</summary>
        /// <param name="message">The message.</param>
        /// <param name="xml">The xml.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string ExtractFailingElement(string message, string xml)
        {
            // Get position of element that caused the InvalidOperationException
            var rightParen = message.LastIndexOf(')');
            if (rightParen == -1)
            {
                return null;
            }

            var leftParen = message.LastIndexOf('(');
            if (leftParen == -1)
            {
                return null;
            }

            var nums = message.Substring(leftParen - 1, rightParen - leftParen + 1);
            var numsArray = nums.Split(',');
            var endError = int.Parse(numsArray[1]);

            // Get Element that caused the InvalidOperationException
            var xmlChopped = xml.Substring(0, endError - 2);
            var beginElement = xmlChopped.LastIndexOf('/');
            if (beginElement == -1)
            {
                return null;
            }

            var endElement = xmlChopped.LastIndexOf('>');
            if (endElement == -1)
            {
                return null;
            }

            return xmlChopped.Substring(beginElement + 1, endElement - beginElement - 1);
        }

        /// <summary>The generate xml.</summary>
        /// <returns>The xml<see cref="string" />.</returns>
        public string GenerateXml()
        {
            if (!this.ParseSprintResponse())
            {
                return null;
            }

            return this.doc.ToString();
        }

        /// <summary>The generate xml.</summary>
        /// <param name="o">The o.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GenerateXml(object o)
        {
            try
            {
                var memoryStream = new MemoryStream();

                using (var xmlTextWriter = new XmlTextWriter(memoryStream, new UTF8Encoding(false)))
                {
                    var xs = new XmlSerializer(o.GetType());

                    xs.UnknownNode += this.SerializerUnknownNode;
                    xs.UnknownAttribute += this.SerializerUnknownAttribute;

                    xs.Serialize(xmlTextWriter, o);

                    memoryStream = (MemoryStream)xmlTextWriter.BaseStream;

                    // NOTE [pcrawford,20140117] Saving state by setting Public Property - notice side-effects!
                    this.XmlString = this.UTF8ByteArrayToString(memoryStream.ToArray());

                    return this.xmlString;
                }
            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex);

                throw new ServiceException(string.Format("Cannot serialize ==> {0}", ex.InnerException.Message));
            }
        }

        // Creates an object from an XML string.

        /// <summary>The get xml attribute value.</summary>
        /// <param name="xmlName">The xml name.</param>
        /// <param name="attributeName">The attribute name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetXmlAttributeValue(string xmlName, string attributeName)
        {
            if (!this.ParseSprintResponse())
            {
                return null;
            }

            return this.doc.Descendants(this.NameSpace + xmlName).Select(x1 => x1).First().Attribute(attributeName).Value;
        }

        /// <summary>The get xml value.</summary>
        /// <param name="xmlName">The xml name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetXmlValue(string xmlName)
        {
            if (!this.ParseSprintResponse())
            {
                return null;
            }

            var returnString = this.doc.Descendants(this.NameSpace + xmlName).Select(x1 => x1).FirstOrDefault();
            if (returnString != null)
            {
                return (string)returnString;
            }

            return null;
        }

        /// <summary>The delete element.</summary>
        /// <param name="xmlName">The xml name.</param>
        public void DeleteElement(string xmlName)
        {
            if (!this.ParseSprintResponse())
            {
                return;
            }

            this.doc.Root.Descendants()
                .Where(e => e.Name == this.NameSpace + xmlName)
                .Remove();
        }

        /// <summary>The get xml value.</summary>
        /// <param name="element">The element.</param>
        /// <param name="xmlName">The xml name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetXmlValue(XElement element, string xmlName)
        {
            if (!this.ParseSprintResponse())
            {
                return null;
            }

            var returnString = element.Descendants(this.NameSpace + xmlName).Select(x1 => x1).FirstOrDefault();
            if (returnString != null)
            {
                return (string)returnString;
            }

            return null;
        }

        /// <summary>The get xml value.</summary>
        /// <param name="xmlName">The xml name.</param>
        /// <param name="useNameSpace">The use name space.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetXmlValue(string xmlName, bool useNameSpace)
        {
            if (!this.ParseSprintResponse())
            {
                return null;
            }

            XElement returnString;

            if (useNameSpace)
            {
                returnString = this.doc.Descendants(this.NameSpace + xmlName).Select(x1 => x1).FirstOrDefault();
            }
            else
            {
                returnString = this.doc.Descendants().FirstOrDefault(p => p.Name.LocalName == xmlName);
            }
            
            if (returnString != null)
            {
                return (string)returnString;
            }

            return null;
        }

        /// <summary>The get xml value.</summary>
        /// <param name="xmlName">The xml name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public List<XElement> GetXmlValues(string xmlName)
        {
            if (!this.ParseSprintResponse())
            {
                return null;
            }

            return !this.ParseSprintResponse() ? null : this.doc.Descendants(this.NameSpace + xmlName).Select(x1 => x1).ToList();
        }

        /// <summary>The insert new feature code.</summary>
        /// <param name="value">The value.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        public bool InsertNewFeatureCode(string value)
        {
            if (!this.ParseSprintResponse())
            {
                return false;
            }

            try
            {
                this.doc.Element(this.NameSpace + "ovm")
                    .Element(this.NameSpace + "ovm-request")
                    .Element(this.NameSpace + "activation-request")
                    .Element(this.NameSpace + "service")
                    .Element(this.NameSpace + "plan")
                    .Element(this.NameSpace + "service-agreement")
                    .AddAfterSelf(new XElement(this.NameSpace + "feature", new XAttribute("feature-code", value)));
                return true;
            }
            catch (NullReferenceException)
            {
                return false;
            }
        }

        /// <summary>The set order type to replace.</summary>
        public void SetOrderTypeToReplace()
        {
            if (!this.ParseSprintResponse())
            {
                return;
            }

            var orderUpgrade = from c in this.doc.Descendants() where c.Name.LocalName == "order" select c;

            foreach (var order in orderUpgrade)
            {
                order.Attribute("type").Value = "REPLACE";
                break;
            }
        }

        #endregion

        #region Methods

        /// <summary>The deserialize xml response.</summary>
        /// <param name="xml">The xml.</param>
        /// <param name="type">The type.</param>
        /// <returns>The <see cref="object"/>.</returns>
        internal object DeserializeXMLResponse(string xml, Type type)
        {
            try
            {
                // var root = new XmlRootAttribute { ElementName = "ovm", IsNullable = true };
                var xmlSerializer = new XmlSerializer(type);

                using (var stringReader = new StringReader(xml))
                {
                    using (var xmlReader = new XmlTextReader(stringReader))
                    {
                        xmlSerializer.UnknownElement += this.DeserializeUnknownElement;
                        xmlSerializer.UnknownAttribute += this.DeserializeUnknownAttribute;
                        xmlSerializer.UnknownNode += this.DeserializeUnknownNode;
                        xmlSerializer.UnreferencedObject += this.DeserializeUnreferencedObject;
                        return xmlSerializer.Deserialize(xmlReader);
                    }
                }
            }
            catch (InvalidOperationException ex)
            {
                Trace.WriteLine("XML:" + xml);
                Trace.WriteLine("DeserializeXML exception: " + ex);

                var element = this.ExtractFailingElement(ex.Message, xml);

                var msg = string.Format("DeserializeXML Failed {0} on Element ==>{1}<== from {2}", ex.Message, element, xml);

                new Log().LogException(msg, this.CarrierName, this.TypeName, this.RefNum);

                return null;
            }
            catch (Exception ex)
            {
                Trace.WriteLine("XML:" + xml);
                Trace.WriteLine("DeserializeXML exception: " + ex);

                var msg = string.Format("DeserializeXML Failed {0} ==> {1}", ex.Message, xml);
                new Log().LogException(msg, this.CarrierName, this.TypeName, this.RefNum);
                return null;
            }
        }

        // private static string SerializeResponse(Response response)
        // {
        // var output = new StringWriter();
        // var writer = XmlWriter.Create(output);
        // new XmlSerializer(typeof(Response)).Serialize(writer, response);
        // return output.ToString();
        // }

        /// <summary>The set xml value.</summary>
        /// <param name="xmlName">The xml name.</param>
        /// <param name="value">The value.</param>
        internal void SetXmlValue([NotNull] string xmlName, [NotNull] string value)
        {
            if (!this.ParseSprintResponse())
            {
                return;
            }

            var returnString = this.doc.Descendants(this.NameSpace + xmlName).Select(x1 => x1).FirstOrDefault();
            if (returnString != null)
            {
                returnString.ReplaceNodes(value);
            }
        }

        /// <summary>The serialize unknown attribute.</summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        private void DeserializeUnknownAttribute(object sender, XmlAttributeEventArgs e)
        {
            Trace.WriteLine(string.Format("Cannot deserialize unknown attribute: {0} {1}:{2}", e.Attr.Name, e.LineNumber, e.LinePosition));
        }

        /// <summary>The serialize unknown element.</summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        private void DeserializeUnknownElement(object sender, XmlElementEventArgs e)
        {
            Trace.WriteLine(string.Format("Cannot deserialize Unknown Element: {0} {1}:{2}", e.Element.Name, e.LineNumber, e.LinePosition));
        }

        /// <summary>The ser_ unknown node.</summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        private void DeserializeUnknownNode(object sender, XmlNodeEventArgs e)
        {
            Trace.WriteLine(string.Format("Cannot deserialize Unknown Node: {0} {1}:{2}", e.Name, e.LineNumber, e.LinePosition));
        }

        /// <summary>The ser_ unreferenced object.</summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        private void DeserializeUnreferencedObject(object sender, UnreferencedObjectEventArgs e)
        {
            Trace.WriteLine(string.Format("Cannot deserialize Unreferenced Object: {0} {1}", e.UnreferencedObject, e.UnreferencedId));
        }

        /// <summary>The get xml string.</summary>
        private void GetXmlString()
        {
            var memoryStream = new MemoryStream();

            using (var xmlTextWriter = new XmlTextWriter(memoryStream, new UTF8Encoding(false)))
            {
                this.doc.WriteTo(xmlTextWriter);

                memoryStream = (MemoryStream)xmlTextWriter.BaseStream;

                // NOTE [pcrawford,20140117] Saving state by setting Public Property - notice side-effects!
                // BUG [pcrawford,20140117] Truncates string!!!
                this.XmlString = this.UTF8ByteArrayToString(memoryStream.ToArray());
            }
        }

        /// <summary>The parse sprint response.</summary>
        /// <returns>The <see cref="bool" />.</returns>
        /// <exception cref="ArgumentNullException"></exception>
        private bool ParseSprintResponse()
        {
            if (string.IsNullOrEmpty(this.xmlString) && this.doc == null)
            {
                if (this.xmlObj == null && this.doc == null)
                {
                    throw new DataException("No XML provided");
                }
            }

            if (this.xmlObj != null)
            {
                this.xmlString = (string)this.xmlObj;
            }

            if (this.xmlString == null || this.doc != null)
            {
                return true;
            }

            // using (var sr = new XmlTextReader(this.xmlString))
            // {
            // this.doc = XDocument.Load(sr);
            // }
            this.doc = XDocument.Parse(this.xmlString);

            if (this.doc.Root == null)
            {
                return false;
            }

            this.NameSpace = this.doc.Root.GetDefaultNamespace();

            return true;
        }

        /// <summary>The serializer unknown attribute.</summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        /// <exception cref="ServiceException"></exception>
        private void SerializerUnknownAttribute(object sender, XmlAttributeEventArgs e)
        {
            Trace.WriteLine(string.Format("Cannot serialize Unknown Attribute: {0} {1}:{2}", e.Attr, e.LineNumber, e.LinePosition));

            //// throw new ServiceException(string.Format("Cannot serialize ==> {0}", eventArgs.ObjectBeingDeserialized));
        }

        /// <summary>The serializer unknown node.</summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        /// <exception cref="ServiceException"></exception>
        private void SerializerUnknownNode(object sender, XmlNodeEventArgs e)
        {
            Trace.WriteLine(string.Format("Cannot serialize Unknown Node: {0} {1}:{2}", e.Name, e.LineNumber, e.LinePosition));

            //// throw new ServiceException(string.Format("Cannot serialize ==> {0}", e.ObjectBeingDeserialized));
        }

        /// <summary>The string to ut f 8 byte array.</summary>
        /// <param name="xmlString">The xml String.</param>
        /// <returns>The <see cref="byte[]"/>.</returns>
        private byte[] StringToUTF8ByteArray(string xmlString)
        {
            var encoding = new UTF8Encoding();
            var byteArray = encoding.GetBytes(xmlString);
            return byteArray;
        }

        /// <summary>The ut f 8 byte array to string.</summary>
        /// <param name="characters">The characters.</param>
        /// <returns>The <see cref="string"/>.</returns>
        private string UTF8ByteArrayToString(byte[] characters)
        {
            return (new UTF8Encoding()).GetString(characters);
        }

        #endregion

      
    }
}