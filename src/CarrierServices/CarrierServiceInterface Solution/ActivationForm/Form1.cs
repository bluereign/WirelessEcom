using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml;

namespace ActivationForm
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            attService2.ATTService att = new ActivationForm.attService2.ATTService();
            
            string responseXml = "";
            string theReturn = "";

            for (int idx = 1; idx <= 100; idx++)
            {
                responseXml = WirelessAdvocates.Utility.SerializeXML(att.SubmitOrder(idx.ToString()));

                theReturn += Environment.NewLine + "Order Number: " + idx + " Response: " + readXml(responseXml, "PrimaryErrorMessage");
            }

            textBox1.Text = theReturn.Trim();
        }

        private string readXml(string theXml, string theElement)
        {
            string readXmlReturn = "Not Found";

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(theXml);

            StringBuilder str = new StringBuilder("");
            XmlNodeList nodes = doc.GetElementsByTagName(theElement);
            
            foreach (XmlNode node in nodes)
            {
                readXmlReturn = node.InnerText;
            }

            return readXmlReturn;
        }

        private void closeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
