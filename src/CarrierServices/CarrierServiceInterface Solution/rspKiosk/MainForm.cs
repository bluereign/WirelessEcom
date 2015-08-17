using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using System.Threading;
using System.Xml.Serialization;
using System.IO;
using System.Xml;
using System.Xml.Linq;

namespace rspKiosk
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            infoPanel.Visible = false;
            
            this.Refresh();

            label5.Visible = true;
            pictureBox3.Visible = true;

            var th = new Thread(generateToken);
            th.Start();
        }

        private delegate void generateTokenDelegate();

        void generateToken()
        {
            if (this.InvokeRequired)
            {
                this.Invoke(new generateTokenDelegate(this.generateToken));
            }
            else
            {
                string generatedToken = "Could not connect to T-Mobile.";

                try
                {
                    rspKiosk.tmoService.TMobileService tmoService = new rspKiosk.tmoService.TMobileService();

                    generatedToken = SerializeXML(tmoService.GenerateRSATokenForKiosk("1111"));

                    XElement theResponse = XElement.Parse(generatedToken);

                    foreach (XElement c in theResponse.Nodes())
                    {
                        if (c.Name.ToString().Contains("tokenPasscode"))
                        {
                            generatedToken = c.Value;
                        }
                    }
                }
                catch (Exception e)
                {
                    MessageBox.Show(e.Message);
                }

                txtToken.Text = generatedToken;

                txtToken.Left = ((this.ClientSize.Width - txtToken.Width) / 2);
                txtToken.Top = (((this.ClientSize.Height - txtToken.Height) / 2) - 25);

                label5.Visible = false;
                pictureBox3.Visible = false;
            }
        }
        public static string SerializeXML(object o)
        {
            XmlSerializer s = new XmlSerializer(o.GetType());

            MemoryStream ms = new MemoryStream();
            XmlTextWriter writer = new XmlTextWriter(ms, new UTF8Encoding());
            writer.Formatting = Formatting.Indented;
            writer.IndentChar = ' ';
            writer.Indentation = 5;
            Exception caught = null;

            try
            {
                s.Serialize(writer, o);
                XmlDocument xml = new XmlDocument();
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
                    throw caught;
            }
            return null;

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
    }


}
