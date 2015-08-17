using Microsoft.Win32;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;
using System.Security.Permissions;
using System.Xml;
using UBR.Products.TimeTrakker.Client.Lib.FogBugz;

namespace FogBugzCreate
{
    public partial class Form1 : Form
    {
        #region Restore app
        // **************************************************************************
        // ** These variables are used for detecting if the app is already running **
        // ** used with RestoreAppWindowIfAlreadyRunning()                         **
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
        // ***************************************************************************
        // ** End                                                                   **
        // ***************************************************************************
        #endregion

        private FBApi m_api;
        string _FinalUrl = "https://wirelessadvocates.fogbugz.com/f/cases/";
        Color _ListFileBackColor = Color.FromArgb(255, 240, 240, 240);
        Hashtable _TemplateFileLocations;

        public Form1()
        {
            RestoreAppWindowIfAlreadyRunning();
            InitializeComponent();
            resultLbl.Text = "";
            connectedLbl.Text = "";
        }

        # region API Instantiation
        public FBApi Api
        {
            get
            {
                if (m_api == null)
                {
                    FBApi.Url = this.urlTxtBx.Text;
                    m_api = new FBApi(usernameTxtBx.Text, passwordTxtBx.Text);
                    //m_api.ApiCalled += new FBApi.ApiEvent(m_api_ApiCalled);
                }
                return m_api;
            }
        }
        #endregion

        #region API Called event
        void m_api_ApiCalled(object sender, string sent, string received)
        {
        }
        #endregion
        #region PopulateDropdowns()
        private void PopulateDropdowns()
        {
            string connectionFailureMessage = "------------------------------ Not connected to FogBugz! ------------------------------";

            if (urlTxtBx.Text == "" || usernameTxtBx.Text == "" || passwordTxtBx.Text == "")
            {
                connectedLbl.Text = connectionFailureMessage;
                return;
            }

            bool success = false;

            // Populate the Project dropdown
            if (FillDropDownWithResults("listProjects", projectCmboBx, null, "response/projects/project", "sProject", "ixProject"))
                success = true;
            else
                success = false;
            progressBar.Value = 20;

            /*======================================================================
             * The following call returns all of the FixFors in the entire project,
             * resulting in a long list of FixFors.  The solution is to manually
             * populate the dropdown with only a single FixFor.
             * 
             * From the website: ixFixFor (or sFixFor – searches project first, then global fixfors)
             *======================================================================
            */
            //Dictionary<string, string> args = new Dictionary<string, string>();
            //args.Add("ixProject", projectCmboBx.Text);
            //FillDropDownWithResults("listFixFors", fixForCmboBx, args, "response/fixfors/fixfor", "sFixFor", "ixFixFor");
            fixForCmboBx.SelectedIndex = 0;
            progressBar.Value = 40;

            // Populate the Priority dropdown
            if (FillDropDownWithResults("listPriorities", priorityCmboBx, null, "response/priorities/priority", "sPriority", "ixPriority"))
                success = true;
            else
                success = false;
            progressBar.Value = 60;

            // Populate the Category dropdown
            if (FillDropDownWithResults("listCategories", categoryCmboBx, null, "response/categories/category", "sCategory", "ixCategory"))
                success = true;
            else
                success = false;
            progressBar.Value = 80;

            // Populate the Assigned to dropdown
            if (FillDropDownWithResults("listPeople", assignedToCmboBx, null, "response/people/person", "sFullName", "ixPerson"))
                success = true;
            else
                success = false;
            progressBar.Value = 100;

            // Hide the progress bar
            progressBar.Visible = false;

            // Display the result in the UI
            if (success == true)
            {
                connectBttn.Visible = false;
                connectedLbl.Text = "-------------------------------------------------------------------------------------------- Connected to FogBugz!";
                //createBttn.Enabled = true;
            }
            else
                connectedLbl.Text = connectionFailureMessage;

            // Enable the items in the groupbox
            groupBox.Enabled = success;
            attachFilesChkBx.Enabled = success;
            templateCmboBx.Enabled = success;

            // Get the *.fbt templates from the current folder and populate the template dropdown
            PopulateTemplateDropdown();
            if (templateCmboBx.Items.Count > 0)
                templateCmboBx.SelectedIndex = 0;

            // Enable the file attachment box, but only if the Attach Files checkbox is checked
            if (attachFilesChkBx.Checked)
            {
                if (!success)
                    listFiles.BackColor = _ListFileBackColor;
                else
                    listFiles.BackColor = Color.White;
                listFiles.Enabled = success;
                addFileBttn.Enabled = success;
                removeFileBttn.Enabled = success;
            }

            //Enable the Create button
            //createBttn.Enabled = success;

            // Reset the success variable
            success = false;
        }

        private bool FillDropDownWithResults(string cmd, ComboBox list,
            Dictionary<string, string> args, string sResultsTag, string sName, string ixName)
        {
            try
            {
                XmlNodeList results = Api.XCmd(cmd, args, sResultsTag);
                foreach (XmlNode node in results)
                {
                    list.Items.Add(String.Format("{0}", node.SelectNodes(sName)[0].InnerText, node.SelectNodes(ixName)[0].InnerText)); //String.Format("{0} : {1}"
                }

                if (list.Items.Count > 0) list.SelectedIndex = 0;
            }
            catch
            {
                return false;
            }

            return true;
        }
        #endregion
        #region GetMIMEType
        private string GetMIMEType(string filepath)
        {
            // Get the file type from the registry
            RegistryPermission regPerm = new RegistryPermission(RegistryPermissionAccess.Read, "\\\\HKEY_CLASSES_ROOT");
            FileInfo fi = new FileInfo(filepath);
            RegistryKey classesRoot = Registry.ClassesRoot;
            string dotExt = fi.Extension.ToLower();
            RegistryKey typeKey = classesRoot.OpenSubKey("MIME\\Database\\Content Type");

            foreach (string keyname in typeKey.GetSubKeyNames())
            {
                RegistryKey curKey = classesRoot.OpenSubKey("MIME\\Database\\Content Type\\" + keyname);
                if (curKey.GetValue("Extension") != null && curKey.GetValue("Extension").ToString().ToLower() == dotExt)
                    return keyname;
            }
            return "";
        }
        #endregion

        #region Create button
        private void createBttn_Click(object sender, EventArgs e)
        {
            if (titleTxtBx.Text == "")
            {
                resultLbl.ForeColor = Color.Red;
                resultLbl.Text = "Case not created!";
                return;
            }

            // Get case details from the UI
            Dictionary<string, string> args = new Dictionary<string, string>();
            if (titleTxtBx.Text.Length > 0)
                args.Add("sTitle", titleTxtBx.Text);
            if (projectCmboBx.Text.Length > 0)
                args.Add("sProject", projectCmboBx.Text);
            if (fixForCmboBx.SelectedIndex >= 0)
                args.Add("sFixFor", fixForCmboBx.SelectedItem.ToString());
            if (categoryCmboBx.SelectedIndex >= 0)
                args.Add("sCategory", categoryCmboBx.SelectedItem.ToString());
            if (assignedToCmboBx.SelectedIndex >= 0)
                args.Add("sPersonAssignedTo", assignedToCmboBx.SelectedItem.ToString());
            if (priorityCmboBx.SelectedIndex >= 0)
                args.Add("sPriority", priorityCmboBx.SelectedItem.ToString());
            if (descriptionTxtBx.Text != "")
                args.Add("sEvent", descriptionTxtBx.Text);

            // Get the file attachment(s) and convert to bytes
            ASCIIEncoding encoding = new ASCIIEncoding();
            Dictionary<string, byte[]>[] rgFiles = null;
            if (listFiles.Items.Count > 0)
            {
                rgFiles = new Dictionary<string, byte[]>[listFiles.Items.Count];
                for (int i = 0; i < listFiles.Items.Count; i++)
                {
                    rgFiles[i] = new Dictionary<string, byte[]>();
                    rgFiles[i]["name"] = encoding.GetBytes("File" + (i + 1).ToString());
                    rgFiles[i]["filename"] = encoding.GetBytes(listFiles.Items[i].ToString().Substring(listFiles.Items[i].ToString().LastIndexOf("\\") + 1));
                    rgFiles[i]["contenttype"] = encoding.GetBytes(GetMIMEType(listFiles.Items[i].ToString()));
                    FileStream fs = new FileStream(listFiles.Items[i].ToString(), FileMode.Open);
                    BinaryReader br = new BinaryReader(fs);
                    rgFiles[i]["data"] = br.ReadBytes((int)fs.Length);
                    fs.Close();
                }
                args.Add("nFileCount", listFiles.Items.Count.ToString());
            }

            string result = "";
            if (rgFiles != null)
                result = Api.Cmd("new", args, rgFiles);
            else
                result = Api.Cmd("new", args); // Return result will look like this: "<?xml version=\"1.0\"?><response><case ixBug=\"142\" operations=\"edit,assign,resolve,email,remind\"></case></response>";

            // Load the result into a manageable XML document
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(result);

            // Get the root element and child
            XmlElement root = xmlDoc.DocumentElement;
            XmlElement child = (XmlElement)root.FirstChild;

            // Get a collection of the attributes so we can obtain the new case number
            XmlAttributeCollection attributes = child.Attributes;
            XmlAttribute attribute = attributes[0];

            // Store the case number
            string caseNum = attribute.Value;

            // Display the result in the UI
            if (result == "")
            {
                resultLbl.ForeColor = Color.Red;
                resultLbl.Font = new Font(this.Font, FontStyle.Regular);
                resultLbl.Cursor = Cursors.Arrow;
                resultLbl.Text = "Failed to create " + categoryCmboBx.Text + "!";
            }
            else
            {
                resultLbl.Font = new Font(this.Font, FontStyle.Underline);
                resultLbl.ForeColor = Color.Blue;
                resultLbl.Cursor = Cursors.Hand;
                resultLbl.Text = categoryCmboBx.Text + " " + caseNum + " created successfully!";
                _FinalUrl = "https://wirelessadvocates.fogbugz.com/f/cases/" + caseNum;
            }

            // Disable the button so we don't accidentally recreate a copy
            createBttn.Enabled = false;
        }
        #endregion
        #region Connect button
        private void connectBttn_Click(object sender, EventArgs e)
        {
            if (usernameTxtBx.Text == "" || passwordTxtBx.Text == "")
            {
                MessageBox.Show("Please enter credentials!", Application.ProductName);
                return;
            }

            progressBar.Visible = true;

            PopulateDropdowns();
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

                // if this process is is OUR process ID...
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

                // exit our process
                this.Close();

                return;
            }
        }
        #endregion
        #region PopulateTemplateDropdown()
        private void PopulateTemplateDropdown()
        {
            // Open all template files found in the current folder
            string[] files = Directory.GetFiles(Application.StartupPath, "*.fbt");

            // Create a hashtable for storing the template location
            _TemplateFileLocations = new Hashtable();

            // Populate the dropdown with template names
            for (int f = 0; f < files.Length; f++)
            {
                string[] lines = File.ReadAllLines(files[f]);

                for (int i = 0; i < lines.Length; i++)
                {
                    if (lines[i].StartsWith("[") && lines[i].EndsWith("]") && lines[i].Contains("TemplateName"))
                    {
                        templateCmboBx.Items.Add(lines[i + 1]);
                        _TemplateFileLocations.Add(lines[i + 1], files[f]);
                        break;
                    }
                }
            }
        }
        #endregion
        #region Additional UI
        private void attachFilesChkBx_CheckedChanged(object sender, EventArgs e)
        {
            if (!attachFilesChkBx.Checked)
                listFiles.BackColor = _ListFileBackColor;
            else
                listFiles.BackColor = Color.White;
            listFiles.Enabled = attachFilesChkBx.Checked;
            addFileBttn.Enabled = attachFilesChkBx.Checked;
            removeFileBttn.Enabled = attachFilesChkBx.Checked;
        }

        private void openFileDlg_Click(object sender, EventArgs e)
        {
            openFileDialog.Filter = "PNG (*.png)|*.png|JPEG (*.jpg)|*.jpg|Bitmap (*.bmp)|*.bmp|Text (*.txt)|*.txt|All Files (*.*)|*.*";
            if (openFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                listFiles.Items.Add(openFileDialog.FileName);
            }
        }

        private void resultLbl_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Process.Start(_FinalUrl);
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }
        }

        private void removeFileBttn_Click(object sender, EventArgs e)
        {
            if (listFiles.SelectedIndex >= 0)
                listFiles.Items.RemoveAt(listFiles.SelectedIndex);
        }

        private void titleTxtBx_TextChanged(object sender, EventArgs e)
        {
            createBttn.Enabled = true;
            resultLbl.Text = "";
        }

        private void richTextBox_TextChanged(object sender, EventArgs e)
        {
            createBttn.Enabled = true;
            resultLbl.Text = "";
        }

        private void templateCmboBx_SelectedIndexChanged(object sender, EventArgs e)
        {
            descriptionTxtBx.Clear();

            // Get the currently selected template name from the dropdown
            string selectedText = templateCmboBx.SelectedItem.ToString();

            // Query the hashtable to find the template location for the selected template name
            string templateLocation = (string)_TemplateFileLocations[selectedText];

            // Load the contents of the file
            string[] lines = File.ReadAllLines(templateLocation);
            for (int i = 0; i < lines.Length; i++)
            {
                if (lines[i].StartsWith("[") && lines[i].EndsWith("]") && lines[i].Contains("Project"))
                    projectCmboBx.SelectedIndex = projectCmboBx.FindString(lines[i + 1]);
                if (lines[i].StartsWith("[") && lines[i].EndsWith("]") && lines[i].Contains("FixFor"))
                    fixForCmboBx.SelectedIndex = fixForCmboBx.FindString(lines[i + 1]);
                if (lines[i].StartsWith("[") && lines[i].EndsWith("]") && lines[i].Contains("Priority"))
                    priorityCmboBx.SelectedIndex = priorityCmboBx.FindString(lines[i + 1]);
                if (lines[i].StartsWith("[") && lines[i].EndsWith("]") && lines[i].Contains("Category"))
                    categoryCmboBx.SelectedIndex = categoryCmboBx.FindString(lines[i + 1]);
                if (lines[i].StartsWith("[") && lines[i].EndsWith("]") && lines[i].Contains("AssignedTo"))
                    assignedToCmboBx.SelectedIndex = assignedToCmboBx.FindString(lines[i + 1]);
                if (lines[i].StartsWith("[") && lines[i].EndsWith("]") && lines[i].Contains("Description"))
                {
                    for (int n = i; n < lines.Length; n++)
                    {
                        if (lines[n].StartsWith("[") && lines[n].EndsWith("]"))
                        {
                            if (!lines[n].Contains("Description"))
                                break;
                        }
                        else
                            descriptionTxtBx.Text += lines[n] + "\r\n";
                    }
                }
            }
        }
        #endregion
    }
}
