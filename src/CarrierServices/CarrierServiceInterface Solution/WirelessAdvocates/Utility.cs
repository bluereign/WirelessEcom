// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Utility.cs" company="">
//   
// </copyright>
// <summary>
//   The utility.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates
{
    using System;
    using System.IO;
    using System.Text;
    using System.Web;
    using System.Xml;
    using System.Xml.Serialization;

    /// <summary>The utility.</summary>
    public class Utility
    {
        #region Public Methods and Operators

        /// <summary>The deserialize xml.</summary>
        /// <param name="xml">The xml.</param>
        /// <param name="objType">The obj type.</param>
        /// <returns>The <see cref="object"/>.</returns>
        public object DeserializeXML(string xml, Type objType)
        {
            /*XmlRootAttribute xRoot=new XmlRootAttribute();
            xRoot.ElementName = "credit-response";
            xRoot.IsNullable = false;
            */
            var xmlSerializer = new XmlSerializer(objType);
            var stringReader = new StringReader(xml);
            var xmlReader = new XmlTextReader(stringReader);
            return xmlSerializer.Deserialize(xmlReader);
        }

        /// <summary>The get app setting.</summary>
        /// <param name="key">The key.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetAppSetting(string key)
        {
            try
            {
                var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
                return config.AppSetting(key);
            }
            catch
            {
                return string.Empty;
            }
        }

        /// <summary>The serialize xml.</summary>
        /// <param name="o">The o.</param>
        /// <returns>The <see cref="string"/>.</returns>
        /// <exception cref="Exception"></exception>
        public string SerializeXML(object o)
        {
            var s = new XmlSerializer(o.GetType());

            var ms = new MemoryStream();
            var writer = new XmlTextWriter(ms, new UTF8Encoding())
                             {
                                 Formatting = Formatting.Indented,
                                 IndentChar = ' ',
                                 Indentation = 5
                             };
            Exception caught = null;

            try
            {
                s.Serialize(writer, o);
                var xml = new XmlDocument();
                string xmlString = UTF8ByteArrayToString(ms.ToArray());
                xml.LoadXml(xmlString);
                return xml.OuterXml;
            }
            catch (Exception e)
            {
                caught = e;
            }
            finally
            {
                writer.Close();
                ms.Close();

                if (caught != null)
                {
                    throw caught;
                }
            }

            return null;
        }

        #endregion

        #region Methods

        /// <summary>The string to ut f 8 byte array.</summary>
        /// <param name="xmlString">The p xml string.</param>
        /// <returns>The <see cref="byte[]"/>.</returns>
        private byte[] StringToUTF8ByteArray(string xmlString)
        {
            var encoding = new UTF8Encoding();
            byte[] byteArray = encoding.GetBytes(xmlString);
            return byteArray;
        }

        /// <summary>The ut f 8 byte array to string.</summary>
        /// <param name="characters">The characters.</param>
        /// <returns>The <see cref="string"/>.</returns>
        private string UTF8ByteArrayToString(byte[] characters)
        {
            var encoding = new UTF8Encoding();
            string constructedString = encoding.GetString(characters);
            return constructedString;
        }

        #endregion
    }
}