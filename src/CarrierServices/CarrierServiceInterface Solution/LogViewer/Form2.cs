using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Text;
using System.IO;
using System.Xml;

namespace LogViewer
{
    public partial class Form2 : Form
    {
        public string Message { get; set; }
        public Form2()
        {
            InitializeComponent();
        }
        public Form2(string msg)
        {
            InitializeComponent();
            Message = msg;

            try
            {
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(Message);

                StringBuilder sb = new System.Text.StringBuilder();
                StringWriter sw = new StringWriter(sb);

                using (var xtw = new XmlTextWriter(sw))
                {
                    xtw.Formatting = Formatting.Indented;
                    doc.WriteTo(xtw);
                    richTextBox1.Text = sb.ToString();

                }
            }
            catch
            {
                richTextBox1.Text = Message;
            }
        }
    }
}
