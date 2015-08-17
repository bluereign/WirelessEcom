using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace BannedUsers
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SqlConnection thisConnection = new SqlConnection("Network Library=DBMSSOCN;Data Source=10.7.0.62,1500;database=CARTOYS;User id=bhogan;Password=Snubs766;");
            thisConnection.Open();
            SqlCommand thisCommand = thisConnection.CreateCommand();

            thisCommand.CommandText = "INSERT INTO websecurity.BannedUsers ( Address1, City, State) VALUES ( '" + txtAddress1.Text.Replace("'", "''") + "', '" + txtCity.Text.Replace("'", "''") + "', '" + txtState.Text.Replace("'", "''") + "' )";

            SqlDataReader thisReader = thisCommand.ExecuteReader();

            thisReader.Close();
            thisConnection.Close();

            if (MessageBox.Show("Your changes have been saved successfully.", "Confirm Save", MessageBoxButtons.OK, MessageBoxIcon.Information) == DialogResult.OK)
            {
                this.Close();
            }
        }
    }
}
