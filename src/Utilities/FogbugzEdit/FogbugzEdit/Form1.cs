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

namespace FogbugzEdit
{
    public partial class Form1 : Form
    {
        #region Restore app
        // **************************************************************************
        // ** These variables are used for detecting if the app is already running **
        // **************************************************************************
        [DllImport("user32.dll")]
        private static extern bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll")]
        private static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")]
        private static extern bool IsIconic(IntPtr hWnd);
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
        private bool _SearchInitiated = false;
        private bool _EnableEditing = false;
        private string _ReceivedXml;
        private string _AppName = "FogBugz Edit";
        string _FinalUrl = "https://wirelessadvocates.fogbugz.com/f/cases/";
        private int _CurrentCaseNumber;
        public int _PassedInCaseNumber = -1;

        public Form1()
        {
            // If a case is being passed in, open the file and read the contents to get the case number
            string filePathContainingPassedInContent = Environment.GetEnvironmentVariable("temp") + "\\4AEF7BC9D8D9424394401C89C52A178D.txt";
            if (File.Exists(filePathContainingPassedInContent))
            {
                string fileContent = File.ReadAllText(filePathContainingPassedInContent);
                _PassedInCaseNumber = Convert.ToInt32(fileContent);
                File.Delete(filePathContainingPassedInContent);
            }

            RestoreAppWindowIfAlreadyRunning();
            InitializeComponent();
            connectedLbl.Text = "";
            resultLbl.Text = "";

            // Automatically edit the case if passed in from another program
            if (_PassedInCaseNumber > 0)
            {
                progressBar.Show();
                caseTxtBx.Enabled = true;
                caseTxtBx.Text = _PassedInCaseNumber.ToString();
                okBttn.Enabled = true;
                PopulateDropdowns();
                LoadCase(_PassedInCaseNumber);
                progressBar.Hide();
            }
        }

        #region Click Close button
        private void closeBttn_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        #endregion
        #region Click Update button
        private void saveBttn_Click(object sender, EventArgs e)
        {
            if (caseTxtBx.Text == "")
                return;

            // Disable the Update button until another change is made
            saveBttn.Enabled = false;

            // Define the arguments
            Dictionary<string, string> args = new Dictionary<string, string>();

            // Add the arguments to request in the API call
            if (caseTxtBx.Text.Length > 0)
                args.Add("ixBug", caseTxtBx.Text);
            if (titleTxtBx.Text.Length > 0)
                args.Add("sTitle", titleTxtBx.Text);
            if (projectCmboBx.Text.Length > 0)
                args.Add("sProject", projectCmboBx.Text);
            if (categoryCmboBx.SelectedIndex >= 0)
                args.Add("sCategory", categoryCmboBx.SelectedItem.ToString());
            if (statusCmboBx.SelectedIndex >= 0)
                args.Add("sStatus", statusCmboBx.SelectedItem.ToString());
            if (assignedToCmboBx.SelectedIndex >= 0)
                args.Add("sPersonAssignedTo", assignedToCmboBx.SelectedItem.ToString());
            if (priorityCmboBx.SelectedIndex >= 0)
                args.Add("sPriority", priorityCmboBx.SelectedItem.ToString());
            if (fixForCmboBx.SelectedIndex >= 0)
                args.Add("sFixFor", fixForCmboBx.SelectedItem.ToString());

            // Update the case
            string result = Api.Cmd("edit", args);

            // Display an error if it occurs
            if (result.Contains("error"))
            {
                XmlDocument errorCondition = new XmlDocument();
                errorCondition.LoadXml(result);
                XmlElement response = errorCondition.DocumentElement;
                XmlElement error = (XmlElement)response.FirstChild;
                MessageBox.Show(error.InnerText, _AppName);
                return;
            }

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

            // Display the results in the UI
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
                resultLbl.Text = categoryCmboBx.Text + " " + caseNum + " updated successfully!";
                _FinalUrl = _FinalUrl + caseNum;
            }
        }
        #endregion
        #region Click Previous/Next buttons
        private void previousBttn_Click(object sender, EventArgs e)
        {
            if (Convert.ToInt32(caseTxtBx.Text) <= 1)
                return;
            else
            {
                int caseNum = Convert.ToInt32(caseTxtBx.Text);
                caseNum--;
                if (LoadCase(caseNum))
                    caseTxtBx.Text = caseNum.ToString();
            }
        }

        private void nextBttn_Click(object sender, EventArgs e)
        {
            int caseNum = Convert.ToInt32(caseTxtBx.Text);
            caseNum++;
            if (LoadCase(caseNum))
                caseTxtBx.Text = caseNum.ToString();
        }
        #endregion
        #region Click Connect Button
        private void connectBttn_Click(object sender, EventArgs e)
        {
            progressBar.Visible = true;
            PopulateDropdowns();
            progressBar.Visible = false;
        }
        #endregion
        #region Click Search Button
        private void searchBttn_Click(object sender, EventArgs e)
        {
            if (caseTxtBx.Text == "")
                return;

            int caseNum = Convert.ToInt32(caseTxtBx.Text);
            LoadCase(caseNum);
        }
        #endregion
        #region caseTxtBx event
        private void caseTxtBx_TextChanged(object sender, EventArgs e)
        {
            // Get the content from the textbox
            string content = caseTxtBx.Text;

            // Verify whether the content is numeric
            if (IsNumeric(content))
                caseTxtBx.Text = content;
            else
            {
                // If it's not numeric, strip the non-numeric character from the string
                int cursorPosition = caseTxtBx.SelectionStart;
                string s = "";
                for (int i = 0; i < content.Length; i++)
                {
                    char c = content[i];
                    if (IsNumeric(c.ToString()))
                        s += c;
                }

                // Replace the text with the stripped version
                caseTxtBx.Text = s;

                // Set the cursor position
                if (cursorPosition <= 0)
                    caseTxtBx.SelectionStart = cursorPosition;
                else
                    caseTxtBx.SelectionStart = cursorPosition - 1;
            }
        }
        #endregion

        # region API Instantiation
        public FBApi Api
        {
            get
            {
                // Instantiate the API instance if it hasn't already been instantiated.
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
            if (_SearchInitiated)
            {
                _ReceivedXml = received;
                // Load the XML into a manageable document
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(received);
                XmlNode cases = xmlDoc.SelectSingleNode("//cases");
                XmlElement caseCount = (XmlElement)cases;
                string c = caseCount.GetAttribute("count");
                int count = Convert.ToInt32(c);
                if (count > 0)
                {
                    // Get the nodes and populate the UI
                    XmlNode title = xmlDoc.SelectSingleNode("//sTitle");
                    XmlNode project = xmlDoc.SelectSingleNode("//sProject");
                    XmlNode status = xmlDoc.SelectSingleNode("//sStatus");
                    XmlNode priority = xmlDoc.SelectSingleNode("//sPriority");
                    XmlNode fixFor = xmlDoc.SelectSingleNode("//sFixFor");
                    XmlNode assignedTo = xmlDoc.SelectSingleNode("//sPersonAssignedTo");
                    XmlNode category = xmlDoc.SelectSingleNode("//sCategory");
                    XmlNodeList summary = xmlDoc.SelectNodes("//event");
                    try { titleTxtBx.Text = title.InnerText; } catch { }
                    try { projectCmboBx.Text = project.InnerText; } catch { }
                    try { NormalizeStatus(status.InnerText); } catch { }
                    try { priorityCmboBx.Text = priority.InnerText; } catch { }
                    try { fixForCmboBx.Text = fixFor.InnerText; } catch { }
                    try { assignedToCmboBx.Text = assignedTo.InnerText; } catch { }
                    try { categoryCmboBx.Text = category.InnerText; } catch { }
                    try { GetCaseContents(summary); } catch { }
                }
                else
                    /* To Do: Figure out a way to identify the current case to display, rather than the contents of the textbox.
                     * This is because the Next button increments the case number, but the text box does not reflect that.
                     * 
                     * Does removing caseTxtBx.Text and replacing it with _CurrentCaseNumber work?
                     */
                    MessageBox.Show("Case " + _CurrentCaseNumber + " does not exist!", _AppName);
            }
        }
        #endregion
        #region EnableUI()
        private void EnableUi(bool enable)
        {
            titleLbl.Enabled = enable;
            titleTxtBx.Enabled = enable;
            projectLbl.Enabled = enable;
            projectCmboBx.Enabled = enable;
            statusLbl.Enabled = enable;
            statusCmboBx.Enabled = enable;
            categoryLbl.Enabled = enable;
            categoryCmboBx.Enabled = enable;
            assignedToLbl.Enabled = enable;
            assignedToCmboBx.Enabled = enable;
            priorityLbl.Enabled = enable;
            priorityCmboBx.Enabled = enable;
            fixForLbl.Enabled = enable;
            fixForCmboBx.Enabled = enable;
            summaryTxtBx.Enabled = enable;
            nextBttn.Enabled = enable;
            previousBttn.Enabled = enable;
        }

        private void titleTxtBx_TextChanged(object sender, EventArgs e)
        {
            EnableSaveBttn(_EnableEditing);
        }

        private void projectCmboBx_SelectedIndexChanged(object sender, EventArgs e)
        {
            EnableSaveBttn(_EnableEditing);
        }

        private void statusCmboBx_SelectedIndexChanged(object sender, EventArgs e)
        {
            EnableSaveBttn(_EnableEditing);
        }

        private void categoryCmboBx_SelectedIndexChanged(object sender, EventArgs e)
        {
            EnableSaveBttn(_EnableEditing);
        }

        private void assignedToCmboBx_SelectedIndexChanged(object sender, EventArgs e)
        {
            EnableSaveBttn(_EnableEditing);
        }

        private void priorityCmboBx_SelectedIndexChanged(object sender, EventArgs e)
        {
            EnableSaveBttn(_EnableEditing);
        }

        private void fixForCmboBx_SelectedIndexChanged(object sender, EventArgs e)
        {
            EnableSaveBttn(_EnableEditing);
        }

        private void EnableSaveBttn(bool enable)
        {
            if (_EnableEditing)
                saveBttn.Enabled = enable;
        }
        #endregion
        #region Get case contents()
        private void GetCaseContents(XmlNodeList nodes)
        {
            for (int i = nodes.Count - 1; i >= 0; i--)
            {
                // Get a list of all the events
                XmlElement fbEvent = (XmlElement)nodes[i];
                XmlNodeList eventChildren = fbEvent.ChildNodes;
                XmlElement child = (XmlElement)eventChildren[0];

                // Get the date, description and changes
                XmlNode eventDate = null;
                XmlNode eventDescription = null;
                XmlNode eventChanges = null;

                while (child != null)
                {
                    if (child.Name == "dt")
                        eventDate = child;
                    if (child.Name == "sChanges")
                        eventChanges = child;
                    if (child.Name == "evtDescription")
                        eventDescription = child;

                    child = (XmlElement)child.NextSibling;
                }

                // Store the date, description and changes
                string date = eventDate.InnerText;
                string description = eventDescription.InnerText;
                string changes = eventChanges.InnerText;

                // Assemble the events
                if (date != "")
                {
                    summaryTxtBx.Text += date;
                    if (description != "")
                        summaryTxtBx.Text += ", ";
                }
                if (description != "")
                {
                    summaryTxtBx.Text += description;
                    if (changes != "")
                        summaryTxtBx.Text += ", ";
                }
                if (changes != "")
                    summaryTxtBx.Text += changes;

                if (!summaryTxtBx.Text.EndsWith("\r\n"))
                    summaryTxtBx.Text += "\r\n";
            }

            // Remove the last empty line
            if (summaryTxtBx.Text.EndsWith("\r\n"))
                summaryTxtBx.Text = summaryTxtBx.Text.Remove(summaryTxtBx.Text.Length - 2);
        }
        #endregion
        #region IsNumeric()
        private static bool IsNumeric(string value)
        {
            try
            {
                int.Parse(value);
            }
            catch
            {
                return false;
            }
            return true;
        }
        #endregion
        #region Load case()
        public bool LoadCase(int caseNumber)
        {
            if (caseNumber <= 0)
            {
                MessageBox.Show("You must first enter a case!", _AppName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return false;
            }

            // Disable the Update button to prevent saving when changes have not been made yet
            _EnableEditing = false;
            saveBttn.Enabled = false;

            // Clear the summary
            summaryTxtBx.Clear();

            // Variable to indicate that a search has been initiated so that the m_api_ApiCalled event doesn't misfire
            _SearchInitiated = true;

            // Specify the details to include in the case
            /*
             * Columns:
             * ixBug, fOpen, sTitle, sLatestTextSummary, ixBugEventLatestText, ixProject, sProject, 
             * ixArea, sArea, ixGroup, ixPersonAssignedTo, sPersonAssignedTo, sEmailAssignedTo, ixPersonOpenedBy, 
             * ixPersonResolvedBy, ixPersonClosedBy, ixPersonLastEditedBy, ixStatus, sStatus, ixPriority, 
             * sPriority, ixFixFor, sFixFor, dtFixFor, sVersion, sCOmputer, hrsOrigEst, hrsCurrEst, hrsElapsed, 
             * c, sCustomerEmail, ixMailbox, ixCategory, dtOpened, dtResolved, dtClosed, ixBugEventLatest, fReplied, 
             * fForwarded, sTicket, ixDiscussTopic, dtDue, sReleaseNotes, ixBugEventLastView, dtLastView, 
             * ixRelatedBugs, latestEvent, events, count, sScoutDescription, sScoutMessage, fScoutStopReporting, fSubscribed
            */
            string cols = "sTitle,sProject,sStatus,sPriority,sCategory,sFixFor,sPersonAssignedTo,events";

            // Initiate the call from the API
            _CurrentCaseNumber = caseNumber;
            string xml = Api.Search(caseNumber.ToString(), cols);

            // Return false if there are no cases returned.
            XmlDocument received = new XmlDocument();
            received.LoadXml(xml);
            XmlElement response = received.DocumentElement;
            XmlElement cases = (XmlElement)response.FirstChild;
            int caseCount = Convert.ToInt32(cases.GetAttribute("count"));
            if (caseCount <= 0)
                return false;

            // Turn off _SearchInitiated to prevent m_api_ApiCalled from misfiring
            _SearchInitiated = false;

            // Enable the other elements in the case group box so they can be manipulated
            EnableUi(true);

            // Enable the Save button so editing changes can be written
            _EnableEditing = true;

            return true;
        }
        #endregion
        #region NormalizeStatus()
        private void NormalizeStatus(string currentStatus)
        {
            // Determine whether the status already exists in the dropdown
            if (!statusCmboBx.Items.Contains(currentStatus))
            {
                // If it doesn't exist, add an asterisk to differentiate it from the existing statuses
                string nonexistentStatus = currentStatus + "*";

                // If the asterisked status already exists, just set it
                if (statusCmboBx.Items.Contains(nonexistentStatus))
                    statusCmboBx.Text = nonexistentStatus;
                else
                {
                    // Otherwise add it and set it
                    statusCmboBx.Items.Add(nonexistentStatus);
                    statusCmboBx.Text = nonexistentStatus;
                }
            }
            else
                // If the status does already exist, set it
                statusCmboBx.Text = currentStatus;
        }
        #endregion
        #region Navigation event
        private void resultLbl_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Process.Start(_FinalUrl);
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message, _AppName);
            }
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
            if (FillDropDownWithResults("listProjects", projectCmboBx, null, "response/projects/project", "sProject"))
                success = true;
            else
                success = false;
            progressBar.Value = 18;

            // Populate the Category dropdown
            if(FillDropDownWithResults("listCategories", categoryCmboBx, null, "response/categories/category", "sCategory"))
                success = true;
            else
                success = false;
            progressBar.Value = 36;

            // Populate the Status to dropdown
            Dictionary<string, string> args = new Dictionary<string, string>();
            args = new Dictionary<string, string>();
            args.Add("ixCategory", categoryCmboBx.SelectedIndex.ToString());
            if (FillDropDownWithResults("listStatuses", statusCmboBx, args, "response/statuses/status", "sStatus"))
                success = true;
            else
                success = false;
            progressBar.Value = 54;

            // Populate the Assigned to dropdown
            if(FillDropDownWithResults("listPeople", assignedToCmboBx, null, "response/people/person", "sFullName"))
                success = true;
            else
                success = false;
            progressBar.Value = 72;

            // Populate the Priority dropdown
            if(FillDropDownWithResults("listPriorities", priorityCmboBx, null, "response/priorities/priority", "sPriority"))
                success = true;
            else
                success = false;
            progressBar.Value = 90;

            // Populate the FixFor combo box
            args.Clear();
            args.Add("ixProject", projectCmboBx.SelectedIndex.ToString());
            if(FillDropDownWithResults("listFixFors", fixForCmboBx, args, "response/fixfors/fixfor", "sFixFor"))
                success = true;
            else
                success = false;
            progressBar.Value = 100;

            // Display the result in the UI
            if (success == true)
            {
                connectBttn.Visible = false;
                connectedLbl.Text = "-------------------------------------------------------------------------------------------- Connected to FogBugz!";
            }

            caseLbl.Enabled = true;
            caseTxtBx.Enabled = true;
            okBttn.Enabled = true;
            success = false;
        }

        private bool FillDropDownWithResults(string cmd, ComboBox comboBox, Dictionary<string, string> args, string sResultsTag, string sName)
        {
            try
            {
                comboBox.Items.Clear();
                XmlNodeList results = Api.XCmd(cmd, args, sResultsTag);
                foreach (XmlNode node in results)
                {
                    string item = String.Format("{0}", node.SelectNodes(sName)[0].InnerText);
                    if (!comboBox.Items.Contains(item))
                        comboBox.Items.Add(String.Format("{0}", node.SelectNodes(sName)[0].InnerText));
                }

                if (comboBox.Items.Count > 0) comboBox.SelectedIndex = 0;
            }
            catch
            {
                return false;
            }

            return true;
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
                    // then the other process is at index 1
                    n = 1;

                // get the window handle
                IntPtr hWnd = processes[n].MainWindowHandle;

                // if iconic, we need to restore the window
                if (IsIconic(hWnd))
                    ShowWindowAsync(hWnd, SW_RESTORE);

                // bring it to the foreground
                SetForegroundWindow(hWnd);
                this.Close();

                // exit our process
                return;
            }
        }
        #endregion
    }
}
