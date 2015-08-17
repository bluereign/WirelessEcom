using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.IO;
using System.Xml.Serialization;
using System.Xml;
using System.Text;
using System.Net;
using WirelessAdvocates.WAConfigurationManager;

namespace VerizonCarrierServiceInterface.Interfaces
{
    public class Helper
    {
        public static Request.messageHeaderType BuildMessageHeader(string RequestType, string OrderType, string ChannelType, string ReferenceNumber)
        {
            Request.messageHeaderType messageHeader = new Request.messageHeaderType();
            messageHeader.versionNumber = "001";
            messageHeader.vendorId = "WA-Costco";
            messageHeader.channelId = "B2C";
            messageHeader.channelType = ChannelType;
            messageHeader.requestType = RequestType;
            messageHeader.orderType = OrderType;
            messageHeader.referenceNumber = new Request.referenceNumberType();
            messageHeader.referenceNumber.Value = ReferenceNumber;
            WAConfigurationManager  config = new WirelessAdvocates.WAConfigurationManager.WAConfigurationManager(HttpContext.Current.Server.MapPath(""));
            messageHeader.returnURL = config.AppSetting("VerizonAsyncCallbackListner").ToString(); //TODO: Make this a config setting.
            messageHeader.resendSpecified = true;
            messageHeader.resend = 3;

            return messageHeader;
        }

        public static string FormatVerizonDate(DateTime Date)
        {
            //Example: 02/07/2010 08:09:17
            return Date.ToString("MM/dd/yyyy HH:mm:ss");
        }

        public static void prepOasAddress(Request.oasAddressType addressType)
        {
            addressType.addressLine1 = new Request.oasStringType();
            addressType.addressLine2 = new Request.oasStringType();
            addressType.city = new Request.oasStringType();
            addressType.state = new Request.oasStringType();
            addressType.zipCode = new Request.zipCodeType();
            addressType.country = new Request.oasStringType();
        }

        public static Request.oasAddressType ConvertExtendedAddressToVerizonAddress(WirelessAdvocates.ExtendedAddress ExtendedAddress, bool ExcludeCountryAndName)
        {
            Request.oasAddressType address = new Request.oasAddressType();
            address.addressLine1 = new Request.oasStringType();
            address.addressLine1.Value = ExtendedAddress.AddressLine1;
            address.addressLine2 = new Request.oasStringType();
            address.addressLine2.Value = ExtendedAddress.AddressLine2;
            address.addressType = new Request.oasStringType();
            address.addressType.Value = ExtendedAddress.AddressType;
            address.aptDesignator = new Request.oasStringType();
            address.aptDesignator.Value = ExtendedAddress.AptDesignator;
            address.aptNumber = new Request.oasStringType();
            address.aptNumber.Value = ExtendedAddress.AptNumber;
            address.city = new Request.oasStringType();
            address.city.Value = ExtendedAddress.City;
            address.countyName = new Request.oasStringType();
            address.countyName.Value = ExtendedAddress.CountyName;
            address.deliveryPointBarCode = new Request.oasStringType();
            address.deliveryPointBarCode.Value = ExtendedAddress.DeliveryPointBarCode;
            address.directionalPrefix = new Request.oasStringType();
            address.directionalPrefix.Value = ExtendedAddress.DirectionalPrefix;
            address.directionalSuffix = new Request.oasStringType();
            address.directionalSuffix.Value = ExtendedAddress.DirectionalSuffix;
            address.houseNum = new Request.oasStringType();
            address.houseNum.Value = ExtendedAddress.AddressLine1;
            address.state = new Request.oasStringType();
            address.state.Value = ExtendedAddress.State;
            address.streetName = new Request.oasStringType();
            address.streetName.Value = ExtendedAddress.StreetName;
            address.streetType = new Request.oasStringType();
            address.streetType.Value = ExtendedAddress.StreetType;
            address.zipCode = new Request.zipCodeType();
            address.zipCode.Value = ExtendedAddress.ZipCode;
            address.zip10 = new Request.zip10Type();

            if (ExtendedAddress.ExtendedZipCode.Length == 4)
            {
                address.zip10.Value = "0" + ExtendedAddress.ExtendedZipCode;
            }
            else
            {
                address.zip10.Value = ExtendedAddress.ExtendedZipCode;
            }

            if (!ExcludeCountryAndName)
            {
                address.country = new Request.oasStringType();
                address.country.Value = ExtendedAddress.Country;

                address.businessName = new Request.oasStringType();
                address.businessName.Value = ExtendedAddress.CompanyName;

                address.firstName = new Request.oasStringType();
                address.firstName.Value = ExtendedAddress.Name.FirstName;
                address.lastName = new Request.oasStringType();
                address.lastName.Value = ExtendedAddress.Name.LastName;
                address.middleInitial = new Request.oasSingleCharacterType();
                address.middleInitial.Value = ExtendedAddress.Name.MiddleInitial;
            }

            return address;
        }

        public static Request.oasAddressType ConvertExtendedAddressToVerizonAddress(WirelessAdvocates.ExtendedAddress ExtendedAddress)
        {
            return ConvertExtendedAddressToVerizonAddress(ExtendedAddress, true);
        }

        public static string SubmitRequest(string xml)
        {
            string responseXML = "";

            // Create a request using a URL that can receive a post.
            WAConfigurationManager  config = new WirelessAdvocates.WAConfigurationManager.WAConfigurationManager(HttpContext.Current.Server.MapPath(""));
            WebRequest request = WebRequest.Create(config.AppSetting("VerizonEndPoint"));
            Stream dataStream = null;
            StreamReader reader = null;
            WebResponse res = null;

            // Post the request
            try
            {
                // Set the Method property of the request to POST.
                request.Method = "POST";
                string postData = xml;
                byte[] byteArray = Encoding.UTF8.GetBytes(postData);
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = byteArray.Length;
                dataStream = request.GetRequestStream();
                dataStream.Write(byteArray, 0, byteArray.Length);
                dataStream.Close();
                res = request.GetResponse();
                dataStream = res.GetResponseStream();
                reader = new StreamReader(dataStream);
                responseXML = reader.ReadToEnd();
               
            }
            catch (WebException webEx)
            {
                System.Diagnostics.Debug.WriteLine("webEx:" + webEx.ToString());
                WirelessAdvocates.Logger.Log.LogException(webEx.ToString(), "Verizon", "PortInValidation", "");
                 
              
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("ex:" + ex.ToString());
                WirelessAdvocates.Logger.Log.LogException(ex.ToString(), "Verizon", "PortInValidation", "");
                 
            }
            finally
            {
                // Clean up the streams.
                reader.Close();
                dataStream.Close();
                res.Close();
            }

            responseXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" + responseXML;

            return responseXML;
        }

        public static string GenerateXML(object o)
        {
            try
            {
                String XmlizedString = null;
                MemoryStream memoryStream = new MemoryStream();
                XmlSerializer xs = new XmlSerializer(o.GetType());
                
                XmlTextWriter xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.ASCII);
                
                xs.Serialize(xmlTextWriter, o);
                
                memoryStream = (MemoryStream)xmlTextWriter.BaseStream;
                XmlizedString = UTF8ByteArrayToString(memoryStream.ToArray());

                return XmlizedString;
            }
            catch (Exception e) 
            { 
                System.Console.WriteLine(e);
                System.Diagnostics.Debug.WriteLine(e);

                return null; 
            }
        }

        // Creates an object from an XML string.
        public static object DeserializeXML(string Xml, System.Type ObjType)
        {
            object obj = null;
            StringReader stringReader =  null;
            XmlTextReader xmlReader = null;

            try
            {
                XmlRootAttribute xRoot = new XmlRootAttribute();
                xRoot.ElementName = "oasOrderResponse";
                //xRoot.Namespace = "http://www.verizonwireless.com/oas";
                xRoot.IsNullable = true;

                XmlSerializer ser;
                ser = new XmlSerializer(ObjType);
                stringReader = new StringReader(Xml);
                xmlReader = new XmlTextReader(stringReader);
                ser.UnknownElement += new XmlElementEventHandler(ser_UnknownElement);
                obj = ser.Deserialize(xmlReader);

                System.Diagnostics.Debug.WriteLine("XML:" + Xml);
                System.Diagnostics.Debug.WriteLine("DeserializeXML OBJECT: " + Interfaces.Helper.GenerateXML(obj));            
            }
            catch (Exception ex1)
            {
                System.Diagnostics.Debug.WriteLine("XML:" + Xml);
                System.Diagnostics.Debug.WriteLine("DeserializeXML exception: " + ex1.ToString());
            }
            finally
            {
                xmlReader.Close();
                stringReader.Close();
            }

            return obj;
        }

        static void ser_UnknownElement(object sender, XmlElementEventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Unknown Element: " + e.Element.Name);
        }

        private static String UTF8ByteArrayToString(Byte[] characters)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            String constructedString = encoding.GetString(characters);
            return (constructedString);
        }

        private static Byte[] StringToUTF8ByteArray(String pXmlString)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            Byte[] byteArray = encoding.GetBytes(pXmlString);
            return byteArray;
        }

        // Helper class to ignore namespaces when de-serializing
        public class NamespaceIgnorantXmlTextReader : XmlTextReader
        {
            public NamespaceIgnorantXmlTextReader(System.IO.TextReader reader) : base(reader) { }

            public override string NamespaceURI
            {
                get { return ""; }
            }
        }

        // Helper class to omit XML decl at start of document when serializing
        public class XTWFND : XmlTextWriter
        {
            public XTWFND(System.IO.TextWriter w) : base(w) { Formatting = System.Xml.Formatting.Indented; }
            public override void WriteStartDocument() { }
        }
    }
}