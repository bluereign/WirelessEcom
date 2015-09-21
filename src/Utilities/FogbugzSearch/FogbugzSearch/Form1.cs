using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using UBR.Products.TimeTrakker.Client.Lib.FogBugz;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;

namespace FogbugzSearch
{
    public partial class Form1 : Form
    {
        #region Restore app
        // **************************************************************************
        // ** These variables are used for detecting if the app is already running **
        // **************************************************************************
        [DllImport("user32.dll")]
        private static extern
            bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll")]
        private static extern
            bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")]
        private static extern
            bool IsIconic(IntPtr hWnd);

        private const int SW_HIDE = 0;
        private const int SW_SHOWNORMAL = 1;
        private const int SW_SHOWMINIMIZED = 2;
        private const int SW_SHOWMAXIMIZED = 3;
        private const int SW_SHOWNOACTIVATE = 4;
        private const int SW_RESTORE = 9;
        private const int SW_SHOWDEFAULT = 10;

        private FBApi m_api;
        private string _SearchKeyFileName = "FogbugzSearchKeys.txt";
        private string _SearchKeyFilePath = Environment.CurrentDirectory + "\\";
        private string _AppName = "FogBugz Search";
        // ***************************************************************************
        // ** End                                                                   **
        // ***************************************************************************
        #endregion

        public Form1()
        {
            RestoreAppWindowIfAlreadyRunning();
            _SearchKeyFilePath = _SearchKeyFilePath + _SearchKeyFileName;
            InitializeComponent();
            LoadSearchKeys();
            caseCountLbl.Text = "";
        }

        #region API Instantiation
        public FBApi Api
        {
            get
            {
                if (m_api == null)
                {
                    FBApi.Url = this.urlTxtBx.Text;
                    m_api = new FBApi(usernameTxtBx.Text, passwordTxtBx.Text);
                    m_api.ApiCalled += new FBApi.ApiEvent(m_api_ApiCalled);
                }
                return m_api;
            }
        }
        #endregion
        #region API Called event
        void m_api_ApiCalled(object sender, string sent, string received)
        {
            // Populate the Sent and Received text boxes
            sentTxtBx.Text = sent;
            receivedTxtBx.Text = FormatXml(received, true);

            // Load the XML into a manageable document
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(received);

            // Get the root element and first child
            XmlElement root = xmlDoc.DocumentElement;
            XmlElement count = (XmlElement)root.FirstChild;

            // Assemble the case string
            caseCountLbl.Text = count.GetAttribute("count") + " cases";
            XmlNodeList cases = xmlDoc.SelectNodes("//case");

            // Populate the listbox
            ListViewItem listItem1;
            itemsLstVw.Items.Clear();
            foreach(XmlElement caseElement in cases)
            {
                XmlElement caseChild = (XmlElement)caseElement.FirstChild;
                string caseNum = caseChild.InnerText;
                string caseTitle = caseChild.NextSibling.InnerText;
                listItem1 = new ListViewItem(caseNum);
                listItem1.SubItems.Add(caseTitle);

                itemsLstVw.Items.AddRange(new ListViewItem[] { listItem1});
            }
        }
        #endregion

        #region FormatXml()
        public static string FormatXml(string xml, bool isIndented)
        {
            bool success = false;

            // Instantiation of the StringWriter and the XmlTextWriter
            StringWriter sw = new StringWriter();
            XmlTextWriter writer = new XmlTextWriter(sw);

            // Determine of the resulting XML should be indented
            if (isIndented == true)
                writer.Formatting = Formatting.Indented;
            else
                writer.Formatting = Formatting.None;

            // Instantiation of the XmlDocument
            XmlDocument xmlDoc = new XmlDocument();

            try
            {
                // Load the XML into the XmlDocument
                xmlDoc.LoadXml(xml);
                success = true;
            }
            catch (Exception error)
            {
                string e = error.Message;       // For debugging purposes only.
                MessageBox.Show("Invalid XML", "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            if (success)
            {
                // Perform the formatting
                xmlDoc.WriteTo(writer);
            }

            // Return the formatted XML in a string
            return sw.ToString();
        }
        #endregion
        #region Click Search button
        private void searchBttn_Click(object sender, EventArgs e)
        {
            Api.Search(searchStringTxtBx.Text);
            AutoCompleteStringCollection ac = searchStringTxtBx.AutoCompleteCustomSource;
            string[] lines = new string[ac.Count];
            string searchItem = ac[0];
            for (int i = 0; i < ac.Count; i++)
                lines[i] = ac[i];

            // Append the new search key to the existing collection
            if (!ac.Contains(searchStringTxtBx.Text))
                ac.Add(searchStringTxtBx.Text);

            // Store the new search string for next time
            UpdateSearchKeyFile(lines, searchStringTxtBx.Text);
        }
        #endregion
        #region Click Close button
        private void closeBttn_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        #endregion
        #region Press <Enter> or <Delete>
        private void searchStringTxtBx_KeyUp(object sender, KeyEventArgs e)
        {
            // <Enter> behavior
            if (e.KeyCode == Keys.Enter)
                searchBttn.Focus();

            // <Delete> behavior
            if (e.KeyCode == Keys.Delete)
            {
                string selectedItem = searchStringTxtBx.Text;
                UpdateSearchKeyFile(selectedItem);
                searchStringTxtBx.Text = "";
                AutoCompleteStringCollection ac = searchStringTxtBx.AutoCompleteCustomSource;
                ac.Remove(selectedItem);
            }
        }
        #endregion
        #region LoadSearchKeys()
        private void LoadSearchKeys()
        {
            string[] lines;
            if (File.Exists(_SearchKeyFilePath))
            {
                searchStringTxtBx.AutoCompleteCustomSource.Clear();
                lines = File.ReadAllLines(_SearchKeyFilePath);
                for (int i = 0; i < lines.Length; i++)
                {
                    searchStringTxtBx.AutoCompleteCustomSource.Add(lines[i]);
                }
            }
            else if (File.Exists(Environment.GetEnvironmentVariable("temp") + "\\" + _SearchKeyFileName))
            {
                MessageBox.Show("Unable to find " + _SearchKeyFileName + ", looking in temp now.", _AppName);
                lines = File.ReadAllLines(Environment.GetEnvironmentVariable("temp") + "\\" + _SearchKeyFileName);
                for (int i = 0; i < lines.Length; i++)
                {
                    searchStringTxtBx.AutoCompleteCustomSource.Add(lines[i]);
                }
            }
        }
        #endregion
        #region UpdateSearchKeyFile()
        private void UpdateSearchKeyFile(string[] data, string itemToAdd)
        {
            // Search key addition behavior
            if (!data.Contains(itemToAdd))
            {
                string[] newList = new string[data.Length + 1];
                data.CopyTo(newList, 0);
                newList[data.Length] = itemToAdd;
                try
                {
                    File.WriteAllLines(_SearchKeyFilePath, newList);
                }
                catch {
                    MessageBox.Show("Unable to find " + _SearchKeyFileName + ", looking in temp now.", _AppName);
                    string filePath = Environment.GetEnvironmentVariable("temp") + "\\" + _SearchKeyFileName;
                    File.WriteAllLines(filePath, newList);
                }
            }
        }
        private void UpdateSearchKeyFile(string itemToRemove)
        {
            // Search key deletion behavior
            int n = 0;
            string[] searchKeyFile = File.ReadAllLines(_SearchKeyFilePath);
            string[] newSearchKeyFile = new string[searchKeyFile.Length - 1];
            if (searchKeyFile.Contains(itemToRemove))
            {
                for (int i = 0; i < searchKeyFile.Length; i++)
                {
                    if (!searchKeyFile[i].Contains(itemToRemove))
                    {
                        newSearchKeyFile[n] = searchKeyFile[i];
                        n++;
                    }
                }
                try
                {
                    File.WriteAllLines(_SearchKeyFilePath, newSearchKeyFile);
                }
                catch
                {
                    MessageBox.Show("Unable to find " + _SearchKeyFileName + ", looking in temp now.", _AppName);
                    string filePath = Environment.GetEnvironmentVariable("temp") + "\\" + _SearchKeyFileName;
                    File.WriteAllLines(filePath, newSearchKeyFile);
                }
            }
        }
        #endregion
        #region Resize dialog
        private void Form1_SizeChanged(object sender, EventArgs e)
        {
            int size = this.Width - 45;
            sentTxtBx.Width = size / 2;
            receivedTxtBx.Width = size / 2;
            receivedTxtBx.Left = sentTxtBx.Right + 9;
            //if (itemsLstVw.Scrollable)
                titleHeader.Width = itemsLstVw.Width - caseHeader.Width - 5;
            //else
            //    titleHeader.Width = itemsLstVw.Width - caseHeader.Width - 5;
        }

        private void itemsLstVw_SizeChanged(object sender, EventArgs e)
        {
            //if (itemsLstVw.Scrollable)
            //    titleHeader.Width = itemsLstVw.Width - caseHeader.Width - 22;
            //else
            //    titleHeader.Width = itemsLstVw.Width - caseHeader.Width - 5;
        }
        #endregion
        #region Raw checkbox
        private void rawChkBx_CheckedChanged(object sender, EventArgs e)
        {
            if (rawChkBx.Checked)
            {
                itemsLstVw.Visible = false;
                sentTxtBx.Visible = true;
                receivedTxtBx.Visible = true;
            }
            else
            {
                itemsLstVw.Visible = true;
                sentTxtBx.Visible = false;
                receivedTxtBx.Visible = false;
            }
        }
        #endregion
        #region Double-click listview item
        private void itemsLstVw_DoubleClick(object sender, EventArgs e)
        {
            OpenInFogBugzWebUi();
        }
        #endregion
        #region RestoreAppWindowIfAlreadyRunning()
        private void RestoreAppWindowIfAlreadyRunning()
        {
            // Code from: http://www.codeproject.com/Articles/2976/Detect-if-another-process-is-running-and-bring-it
            // get the name of our process
            string proc = Process.GetCurrentProcess().ProcessName;

            // get the list of all processes by that name
            Process[] processes = Process.GetProcessesByName(proc);

            // if there is more than one process...
            if (processes.Length > 1)
            {
                // Assume there is our process, which we will terminate, and the other process, which we want to bring to the 
                // foreground. This assumes there are only two processes in the processes array, and we need to find out which 
                // one is NOT us.

                // get our process
                Process p = Process.GetCurrentProcess();
                int n = 0;        // assume the other process is at index 0

                // if this process id is OUR process ID...
                if (processes[0].Id == p.Id)
                {
                    // then the other process is at index 1
                    n = 1;
                }

                // get the window handle
                IntPtr hWnd = processes[n].MainWindowHandle;

                // if iconic, we need to restore the window
                if (IsIconic(hWnd))
                {
                    ShowWindowAsync(hWnd, SW_RESTORE);
                }

                // bring it to the foreground
                SetForegroundWindow(hWnd);
                this.Close();

                // exit our process
                return;
            }
        }
        #endregion
        #region OpenInFogBugzWebUi()
        private void OpenInFogBugzWebUi()
        {
            // Get the index of the selected item
            int urlIndex = urlTxtBx.Text.IndexOf(".com");

            // Get the selected item as an object
            object selectedItem = itemsLstVw.SelectedItems[0].Text;

            // Get the base URL and normalize it
            string baseUrl = urlTxtBx.Text.Remove(urlIndex + 4);
            if (!baseUrl.EndsWith("/"))
                baseUrl += "/";

            // Convert the selected item to a string
            string caseNum = selectedItem.ToString();

            // Assemble the URL
            string newUrl = baseUrl + "default.asp?" + caseNum;

            // Navigate to the URL
            try
            {
                System.Diagnostics.Process.Start(newUrl);
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }
        }
        #endregion
        #region Click in list view
        private void itemsLstVw_MouseClick(object sender, MouseEventArgs e)
        {
            // Enable the context menu if the list view contains items
            if (itemsLstVw.Items.Count > 0)
                itemsLstVw.ContextMenuStrip = contextMenu1;
            else
                itemsLstVw.ContextMenuStrip = null;
        }
        #endregion
        #region Open the case into the FogBugz editor
        private void editContextMenuItem_Click(object sender, EventArgs e)
        {
            // Create a temporary file to transfer the case number
            string tempFilename = Environment.GetEnvironmentVariable("temp") + "\\4AEF7BC9D8D9424394401C89C52A178D.txt";

            // Get the selected item as an object
            object selectedItem = itemsLstVw.SelectedItems[0].Text;

            // Create the temporary file
            File.WriteAllText(tempFilename, selectedItem.ToString());

            // Verify the file exists
            if(!File.Exists(tempFilename))
                MessageBox.Show("Unable to edit case in " + "FogBugz Edit", _AppName);

            // Find the path to the editor
            string splitCharacter = "\\";
            string[] splitString;
            char[] delimiter = splitCharacter.ToCharArray();
            splitString = Environment.CurrentDirectory.Split(delimiter);
            string FogBugzEditExePathName = "";
            for (int i = 0; i < splitString.Length; i++ )
            {
                if (splitString[i].ToLower() != "fogbugzsearch")
                    FogBugzEditExePathName += splitString[i] + "\\";
                else
                    break;
            }
            FogBugzEditExePathName += "FogbugzEdit\\FogbugzEdit\\bin\\Debug\\FogBugzEdit.exe";

            // Open the editor, which will read in the case number for consumption
            if (File.Exists(FogBugzEditExePathName) && File.Exists(tempFilename))
            {
                try
                {
                    System.Diagnostics.Process.Start(FogBugzEditExePathName);
                }
                catch { MessageBox.Show("Unable to edit case in " + "FogBugz Edit", _AppName); }
            }
        }
        #endregion
        #region Context menu
        private void openContextMenuItem_Click(object sender, EventArgs e)
        {
            OpenInFogBugzWebUi();
        }
        #endregion
    }
}
