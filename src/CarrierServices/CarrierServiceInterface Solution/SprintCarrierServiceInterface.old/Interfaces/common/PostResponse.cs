using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Net;
using System.IO;
using SprintCarrierServiceInterface.Interfaces.model.ovmCommon;
using System.Text.RegularExpressions;

namespace SprintCarrierServiceInterface.Interfaces.common.PostResponse
{
    public class PostResponse
    {
        //header format
        private static string requestHeader = @"
            <?xml version=""1.0"" encoding=""UTF-8""?>
            <ovm xmlns=""http://nextel.com/ovm"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">
	            <ovm-header>
		            <pin>6654</pin>
		            <vendor-code>CO</vendor-code>
		            <message-type>{0}</message-type>
		            <timestamp>{1}</timestamp>
                    <message-id>{2}</message-id>
	            </ovm-header>
	            <ovm-request>{3}</ovm-request>
            </ovm>
        ";

        //hitting test/live url
        public string getResponse(string url, string data)
        {
            string vystup = null;
            try
            {
                byte[] buffer = Encoding.ASCII.GetBytes(data);
                HttpWebRequest WebReq = (HttpWebRequest)WebRequest.Create(url);
                WebReq.Method = "POST";
                WebReq.ContentType = "application/x-www-form-urlencoded";
                WebReq.ContentLength = buffer.Length;
                Stream PostData = WebReq.GetRequestStream();
                PostData.Write(buffer, 0, buffer.Length);
                PostData.Close();
                HttpWebResponse WebResp = (HttpWebResponse)WebReq.GetResponse();
                
                // Console.WriteLine(WebResp.StatusCode);
                // Console.WriteLine(WebResp.Server);

                Stream Answer = WebResp.GetResponseStream();
                StreamReader _Answer = new StreamReader(Answer);
                vystup = _Answer.ReadToEnd();
                return null;
             //   return vystup;
               // throw new Exception(vystup);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            //return vystup.Trim();
           
        }

        // Adds Header
        //public string generateRequest(RequestMessageType type, string requestXml, int pin, string referenceNumber)
        //pin given as 6654
        
        public string generateRequest(RequestMessageType type, string requestXml, string referenceNumber)
        {
          //actual request (w/o header)
            string innerXml = requestXml.Replace("<?xml version=\"1.0\" encoding=\"utf-8\" ?>", "");
            innerXml = innerXml.Replace(" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"http://nextel.com/ovm\"", "");
            
          //concatinating the header + request
            string myString = String.Format(requestHeader, type, String.Format("{0:s}", DateTime.Now), referenceNumber, innerXml.Trim());
            
            return myString;
        }
        
        // Removes Header
        public string getResponseXml(RequestMessageType type, string responseXml)
        {
            string responseType = type.ToString();
            MatchCollection m1 = Regex.Matches(responseXml, @"(<" + responseType.Replace("REQUEST", "RESPONSE").Replace("_", "-").ToLower() + ">.*</" + responseType.Replace("REQUEST", "RESPONSE").Replace("_", "-").ToLower() + ">)", RegexOptions.Singleline);

            string strResponse = m1[0].Groups[1].Value;
            string typeElement = responseType.Replace("REQUEST", "RESPONSE").Replace("_", "-").ToLower();

            return strResponse.Replace("<" + typeElement + ">" ,  "<" + typeElement + " xmlns=\"http://nextel.com/ovm\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://nextel.com/ovm http://oebg-http.nextel.com:8006/ovm/xsd/ovm-response.xsd\">");
        }
    }
}