using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Net;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Data;
using System.Collections;
using System.Xml;


class Program
{
    const string CAT_THINGY = "https://product-search.api.cj.com/v2/product-search?website-id=7606823&advertiser-ids=joined&records-per-page=1000";

    static void Main(string[] args)
    {
        var reqUrl = string.Format("{0}", CAT_THINGY);
        var webReq = WebRequest.Create(reqUrl) as HttpWebRequest;
        webReq.Headers.Add("Authorization", "00a9023196c527b0a2743ebb048194bd6b257f59ef4bdf8da1d6aab15b5cc6f2efc00563e3f45cf96ccf7c42a4e0c9f010637d3ed8109d1e91556b4a9b3977b685/03bb47ab03895fce067108220e566164473cab98abfd309c5d2801a879c0eec6312462406e2389f59a8b008a7cc069d2270e19e8088e4eff5f65006d97cf1e95");
        var resp = webReq.GetResponse() as HttpWebResponse;
        var receiveStream = resp.GetResponseStream();
        var readStream = new StreamReader(receiveStream, Encoding.UTF8);
        var respText = readStream.ReadToEnd();
        resp.Close();
        readStream.Close();
        if (resp.StatusCode == HttpStatusCode.OK)
        {
            // Save this shit in XML.

            XmlDocument xm = new XmlDocument();
            xm.LoadXml(string.Format("{0}", respText));
            
       
            // Save this XML to the database.

            string conn = "Data Source=10.7.0.221;Initial Catalog=CommissionReporting;User Id=waecommerce;Password=CHRISisawesome!;";

            SqlConnection sc = new SqlConnection(conn);
            sc.Open();

            // There is probably a better way to handle invalid XML characters... I don't know it yet...

            xm.InnerXml = xm.InnerXml.Replace("'", "''");
            xm.InnerXml = xm.InnerXml.Replace("•", "+");
            xm.InnerXml = xm.InnerXml.Replace("—", "-");

                    string sql = "INSERT INTO raw.CommissionDetails " +
                    " (ChannelId,CarrierId,Source,Type,Log) " +
                    " VALUES ('3','128','CommissionJunction','Catalog','" + xm.InnerXml + "')";

            SqlCommand cmd = new SqlCommand(sql, sc);
                       cmd.ExecuteNonQuery();
                       cmd = null;
                            
               sc.Close();

        }




        }

}