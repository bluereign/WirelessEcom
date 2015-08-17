using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data;

namespace LogViewer
{
    public partial class Form1 : Form
    {
        private DateTime _startDate;
        private DateTime _endDate;
        private string _requestType = string.Empty;
        private object _syncObj = new object();
        private System.Timers.Timer _timer;
        public List<MyData> _dataList = new List<MyData>();

        public Form1()
        {
            InitializeComponent();
            textBoxConnString.Text = @"Data Source=10.7.0.21,1500;Initial Catalog=TEST.WIRELESSADVOCATES.COM;User ID=cfdbo;Password=W1r3l3ss";
            textBoxStartDate.Text = DateTime.Now.Subtract(new TimeSpan(12, 0, 0)).ToString();
            textBoxEndDate.Text = DateTime.Now.ToString();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            UpdateGridView(false);
        }

        private void UpdateGridView(bool updateOverride)
        {
            lock (_syncObj)
            {
                if (checkBoxLiveMonitor.Checked || updateOverride )
                {
                    using (DataClasses1DataContext context = new DataClasses1DataContext(textBoxConnString.Text))
                    {
                        try
                        {
                           _startDate = DateTime.Parse(textBoxStartDate.Text);
                           _endDate = DateTime.Parse(textBoxEndDate.Text);

                        }
                        catch
                        {
                            _startDate = DateTime.Now.Subtract(new TimeSpan(24, 0, 0));
                            _endDate = DateTime.Now;
                        }


                        if (string.IsNullOrEmpty(_requestType))
                        {

                            _dataList = (from log in context.CarrierInterfaceLogs
                                         join order in context.Orders 
                                         on log.ReferenceNumber equals order.CheckoutReferenceNumber
                                         where log.Carrier == "Sprint"
                                         && log.LoggedDateTime >= _startDate
                                         && log.LoggedDateTime <= _endDate
                                         orderby log.LoggedDateTime descending
                                         select new MyData
                                         {
                                             Id = log.Id,
                                             OrderId = order.OrderId,
                                             LoggedDateTime = log.LoggedDateTime,
                                             RefNo = log.ReferenceNumber,
                                             Type = log.Type,
                                             RequestType = log.RequestType
                                         }).ToList();
                        }
                        else
                        {
                            _dataList = (from log in context.CarrierInterfaceLogs
                                         join order in context.Orders
                                         on log.ReferenceNumber equals order.CheckoutReferenceNumber
                                         where log.Carrier == "Sprint"
                                         && log.LoggedDateTime >= _startDate
                                         && log.LoggedDateTime <= _endDate
                                         && log.RequestType.Contains(_requestType)
                                         orderby log.LoggedDateTime descending
                                         select new MyData
                                         {
                                             Id = log.Id,
                                             OrderId = order.OrderId,
                                             LoggedDateTime = log.LoggedDateTime,
                                             RefNo = log.ReferenceNumber,
                                             Type = log.Type,
                                             RequestType = log.RequestType
                                         }).ToList();
                        }
                        dataGridView1.DataSource = _dataList;
                    }
                }
            }
            foreach (DataGridViewRow row in dataGridView1.Rows)
            {
                var type = (string)row.Cells["RequestType"].Value;
                if (type.Contains("Exception"))
                {
                    row.DefaultCellStyle.ForeColor = Color.Red;
                }
            }
        }

        private void comboBoxRequestType_SelectedIndexChanged(object sender, EventArgs e)
        {
            _requestType = (string)comboBoxRequestType.SelectedItem;
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            var cell = dataGridView1.CurrentCell;
            var Id = (long)dataGridView1.Rows[cell.RowIndex].Cells["Id"].Value;

            using (DataClasses1DataContext context = new DataClasses1DataContext(textBoxConnString.Text))
            {
                var xml = (from d in context.CarrierInterfaceLogs
                           where d.Id == Id
                           select d.Data).First();
                Form2 f2 = new Form2(xml);
                f2.ShowDialog();
            }
        }

        private void buttonClear_Click(object sender, EventArgs e)
        {
            textBoxStartDate.Text = DateTime.Now.ToString();
            dataGridView1.DataSource = null;
        }

        private void buttonUpdate_Click(object sender, EventArgs e)
        {
            UpdateGridView(true);
        }
    }

    public class MyData
    {
        public long Id { get; set; }
        public int OrderId { get; set; }
        public DateTime? LoggedDateTime { get; set; }
        public string RefNo { get; set; }
        public string Type { get; set; }
        public string RequestType { get; set; }
    }
}
