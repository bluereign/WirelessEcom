namespace FogbugzEdit
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.caseTxtBx = new System.Windows.Forms.TextBox();
            this.okBttn = new System.Windows.Forms.Button();
            this.urlTxtBx = new System.Windows.Forms.TextBox();
            this.urlLbl = new System.Windows.Forms.Label();
            this.usernameTxtBx = new System.Windows.Forms.TextBox();
            this.usernameLbl = new System.Windows.Forms.Label();
            this.passwordTxtBx = new System.Windows.Forms.TextBox();
            this.passwordLbl = new System.Windows.Forms.Label();
            this.caseLbl = new System.Windows.Forms.Label();
            this.projectCmboBx = new System.Windows.Forms.ComboBox();
            this.projectLbl = new System.Windows.Forms.Label();
            this.statusLbl = new System.Windows.Forms.Label();
            this.statusCmboBx = new System.Windows.Forms.ComboBox();
            this.categoryLbl = new System.Windows.Forms.Label();
            this.categoryCmboBx = new System.Windows.Forms.ComboBox();
            this.assignedToLbl = new System.Windows.Forms.Label();
            this.assignedToCmboBx = new System.Windows.Forms.ComboBox();
            this.fixForLbl = new System.Windows.Forms.Label();
            this.fixForCmboBx = new System.Windows.Forms.ComboBox();
            this.priorityLbl = new System.Windows.Forms.Label();
            this.priorityCmboBx = new System.Windows.Forms.ComboBox();
            this.titleLbl = new System.Windows.Forms.Label();
            this.titleTxtBx = new System.Windows.Forms.TextBox();
            this.saveBttn = new System.Windows.Forms.Button();
            this.connectBttn = new System.Windows.Forms.Button();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.groupBox = new System.Windows.Forms.GroupBox();
            this.previousBttn = new System.Windows.Forms.Button();
            this.nextBttn = new System.Windows.Forms.Button();
            this.summaryTxtBx = new System.Windows.Forms.TextBox();
            this.connectedLbl = new System.Windows.Forms.Label();
            this.resultLbl = new System.Windows.Forms.Label();
            this.closeBttn = new System.Windows.Forms.Button();
            this.groupBox.SuspendLayout();
            this.SuspendLayout();
            // 
            // caseTxtBx
            // 
            this.caseTxtBx.Enabled = false;
            this.caseTxtBx.Location = new System.Drawing.Point(57, 18);
            this.caseTxtBx.Name = "caseTxtBx";
            this.caseTxtBx.Size = new System.Drawing.Size(70, 20);
            this.caseTxtBx.TabIndex = 0;
            this.caseTxtBx.TextChanged += new System.EventHandler(this.caseTxtBx_TextChanged);
            // 
            // okBttn
            // 
            this.okBttn.Enabled = false;
            this.okBttn.Location = new System.Drawing.Point(133, 17);
            this.okBttn.Name = "okBttn";
            this.okBttn.Size = new System.Drawing.Size(68, 23);
            this.okBttn.TabIndex = 2;
            this.okBttn.Text = "Load Case";
            this.okBttn.UseVisualStyleBackColor = true;
            this.okBttn.Click += new System.EventHandler(this.searchBttn_Click);
            // 
            // urlTxtBx
            // 
            this.urlTxtBx.Location = new System.Drawing.Point(50, 12);
            this.urlTxtBx.Name = "urlTxtBx";
            this.urlTxtBx.Size = new System.Drawing.Size(363, 20);
            this.urlTxtBx.TabIndex = 1;
            this.urlTxtBx.Text = "https://wirelessadvocates.fogbugz.com/api.asp";
            // 
            // urlLbl
            // 
            this.urlLbl.AutoSize = true;
            this.urlLbl.Location = new System.Drawing.Point(12, 15);
            this.urlLbl.Name = "urlLbl";
            this.urlLbl.Size = new System.Drawing.Size(32, 13);
            this.urlLbl.TabIndex = 0;
            this.urlLbl.Text = "URL:";
            // 
            // usernameTxtBx
            // 
            this.usernameTxtBx.Location = new System.Drawing.Point(76, 38);
            this.usernameTxtBx.Name = "usernameTxtBx";
            this.usernameTxtBx.Size = new System.Drawing.Size(173, 20);
            this.usernameTxtBx.TabIndex = 3;
            this.usernameTxtBx.Text = "jcardon@wirelessadvocates.com";
            // 
            // usernameLbl
            // 
            this.usernameLbl.AutoSize = true;
            this.usernameLbl.Location = new System.Drawing.Point(12, 41);
            this.usernameLbl.Name = "usernameLbl";
            this.usernameLbl.Size = new System.Drawing.Size(58, 13);
            this.usernameLbl.TabIndex = 2;
            this.usernameLbl.Text = "Username:";
            // 
            // passwordTxtBx
            // 
            this.passwordTxtBx.Location = new System.Drawing.Point(326, 38);
            this.passwordTxtBx.Name = "passwordTxtBx";
            this.passwordTxtBx.PasswordChar = '*';
            this.passwordTxtBx.Size = new System.Drawing.Size(87, 20);
            this.passwordTxtBx.TabIndex = 5;
            this.passwordTxtBx.Text = "Jnslnjclzn1";
            // 
            // passwordLbl
            // 
            this.passwordLbl.AutoSize = true;
            this.passwordLbl.Location = new System.Drawing.Point(264, 41);
            this.passwordLbl.Name = "passwordLbl";
            this.passwordLbl.Size = new System.Drawing.Size(56, 13);
            this.passwordLbl.TabIndex = 4;
            this.passwordLbl.Text = "Password:";
            // 
            // caseLbl
            // 
            this.caseLbl.AutoSize = true;
            this.caseLbl.Enabled = false;
            this.caseLbl.Location = new System.Drawing.Point(4, 21);
            this.caseLbl.Name = "caseLbl";
            this.caseLbl.Size = new System.Drawing.Size(49, 13);
            this.caseLbl.TabIndex = 0;
            this.caseLbl.Text = "Case no:";
            // 
            // projectCmboBx
            // 
            this.projectCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.projectCmboBx.Enabled = false;
            this.projectCmboBx.FormattingEnabled = true;
            this.projectCmboBx.Location = new System.Drawing.Point(59, 71);
            this.projectCmboBx.Name = "projectCmboBx";
            this.projectCmboBx.Size = new System.Drawing.Size(131, 21);
            this.projectCmboBx.Sorted = true;
            this.projectCmboBx.TabIndex = 6;
            this.projectCmboBx.SelectedIndexChanged += new System.EventHandler(this.projectCmboBx_SelectedIndexChanged);
            // 
            // projectLbl
            // 
            this.projectLbl.AutoSize = true;
            this.projectLbl.Enabled = false;
            this.projectLbl.Location = new System.Drawing.Point(4, 74);
            this.projectLbl.Name = "projectLbl";
            this.projectLbl.Size = new System.Drawing.Size(43, 13);
            this.projectLbl.TabIndex = 5;
            this.projectLbl.Text = "Project:";
            // 
            // statusLbl
            // 
            this.statusLbl.AutoSize = true;
            this.statusLbl.Enabled = false;
            this.statusLbl.Location = new System.Drawing.Point(4, 128);
            this.statusLbl.Name = "statusLbl";
            this.statusLbl.Size = new System.Drawing.Size(40, 13);
            this.statusLbl.TabIndex = 9;
            this.statusLbl.Text = "Status:";
            // 
            // statusCmboBx
            // 
            this.statusCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.statusCmboBx.Enabled = false;
            this.statusCmboBx.FormattingEnabled = true;
            this.statusCmboBx.Location = new System.Drawing.Point(59, 125);
            this.statusCmboBx.Name = "statusCmboBx";
            this.statusCmboBx.Size = new System.Drawing.Size(131, 21);
            this.statusCmboBx.Sorted = true;
            this.statusCmboBx.TabIndex = 10;
            this.statusCmboBx.SelectedIndexChanged += new System.EventHandler(this.statusCmboBx_SelectedIndexChanged);
            // 
            // categoryLbl
            // 
            this.categoryLbl.AutoSize = true;
            this.categoryLbl.Enabled = false;
            this.categoryLbl.Location = new System.Drawing.Point(4, 101);
            this.categoryLbl.Name = "categoryLbl";
            this.categoryLbl.Size = new System.Drawing.Size(52, 13);
            this.categoryLbl.TabIndex = 13;
            this.categoryLbl.Text = "Category:";
            // 
            // categoryCmboBx
            // 
            this.categoryCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.categoryCmboBx.Enabled = false;
            this.categoryCmboBx.FormattingEnabled = true;
            this.categoryCmboBx.Location = new System.Drawing.Point(59, 98);
            this.categoryCmboBx.Name = "categoryCmboBx";
            this.categoryCmboBx.Size = new System.Drawing.Size(131, 21);
            this.categoryCmboBx.Sorted = true;
            this.categoryCmboBx.TabIndex = 14;
            this.categoryCmboBx.SelectedIndexChanged += new System.EventHandler(this.categoryCmboBx_SelectedIndexChanged);
            // 
            // assignedToLbl
            // 
            this.assignedToLbl.AutoSize = true;
            this.assignedToLbl.Enabled = false;
            this.assignedToLbl.Location = new System.Drawing.Point(196, 74);
            this.assignedToLbl.Name = "assignedToLbl";
            this.assignedToLbl.Size = new System.Drawing.Size(65, 13);
            this.assignedToLbl.TabIndex = 7;
            this.assignedToLbl.Text = "Assigned to:";
            // 
            // assignedToCmboBx
            // 
            this.assignedToCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.assignedToCmboBx.Enabled = false;
            this.assignedToCmboBx.FormattingEnabled = true;
            this.assignedToCmboBx.Location = new System.Drawing.Point(267, 71);
            this.assignedToCmboBx.Name = "assignedToCmboBx";
            this.assignedToCmboBx.Size = new System.Drawing.Size(121, 21);
            this.assignedToCmboBx.Sorted = true;
            this.assignedToCmboBx.TabIndex = 8;
            this.assignedToCmboBx.SelectedIndexChanged += new System.EventHandler(this.assignedToCmboBx_SelectedIndexChanged);
            // 
            // fixForLbl
            // 
            this.fixForLbl.AutoSize = true;
            this.fixForLbl.Enabled = false;
            this.fixForLbl.Location = new System.Drawing.Point(209, 128);
            this.fixForLbl.Name = "fixForLbl";
            this.fixForLbl.Size = new System.Drawing.Size(38, 13);
            this.fixForLbl.TabIndex = 15;
            this.fixForLbl.Text = "Fix for:";
            // 
            // fixForCmboBx
            // 
            this.fixForCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.fixForCmboBx.Enabled = false;
            this.fixForCmboBx.FormattingEnabled = true;
            this.fixForCmboBx.Location = new System.Drawing.Point(267, 125);
            this.fixForCmboBx.Name = "fixForCmboBx";
            this.fixForCmboBx.Size = new System.Drawing.Size(121, 21);
            this.fixForCmboBx.Sorted = true;
            this.fixForCmboBx.TabIndex = 16;
            this.fixForCmboBx.SelectedIndexChanged += new System.EventHandler(this.fixForCmboBx_SelectedIndexChanged);
            // 
            // priorityLbl
            // 
            this.priorityLbl.AutoSize = true;
            this.priorityLbl.Enabled = false;
            this.priorityLbl.Location = new System.Drawing.Point(209, 101);
            this.priorityLbl.Name = "priorityLbl";
            this.priorityLbl.Size = new System.Drawing.Size(41, 13);
            this.priorityLbl.TabIndex = 11;
            this.priorityLbl.Text = "Priority:";
            // 
            // priorityCmboBx
            // 
            this.priorityCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.priorityCmboBx.Enabled = false;
            this.priorityCmboBx.FormattingEnabled = true;
            this.priorityCmboBx.Location = new System.Drawing.Point(267, 98);
            this.priorityCmboBx.Name = "priorityCmboBx";
            this.priorityCmboBx.Size = new System.Drawing.Size(121, 21);
            this.priorityCmboBx.Sorted = true;
            this.priorityCmboBx.TabIndex = 12;
            this.priorityCmboBx.SelectedIndexChanged += new System.EventHandler(this.priorityCmboBx_SelectedIndexChanged);
            // 
            // titleLbl
            // 
            this.titleLbl.AutoSize = true;
            this.titleLbl.Enabled = false;
            this.titleLbl.Location = new System.Drawing.Point(4, 48);
            this.titleLbl.Name = "titleLbl";
            this.titleLbl.Size = new System.Drawing.Size(53, 13);
            this.titleLbl.TabIndex = 3;
            this.titleLbl.Text = "Case title:";
            // 
            // titleTxtBx
            // 
            this.titleTxtBx.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.titleTxtBx.Enabled = false;
            this.titleTxtBx.Location = new System.Drawing.Point(57, 45);
            this.titleTxtBx.Name = "titleTxtBx";
            this.titleTxtBx.Size = new System.Drawing.Size(331, 20);
            this.titleTxtBx.TabIndex = 4;
            this.titleTxtBx.TextChanged += new System.EventHandler(this.titleTxtBx_TextChanged);
            // 
            // saveBttn
            // 
            this.saveBttn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.saveBttn.Enabled = false;
            this.saveBttn.Location = new System.Drawing.Point(257, 372);
            this.saveBttn.Name = "saveBttn";
            this.saveBttn.Size = new System.Drawing.Size(75, 23);
            this.saveBttn.TabIndex = 9;
            this.saveBttn.Text = "Update";
            this.saveBttn.UseVisualStyleBackColor = true;
            this.saveBttn.Click += new System.EventHandler(this.saveBttn_Click);
            // 
            // connectBttn
            // 
            this.connectBttn.Location = new System.Drawing.Point(338, 64);
            this.connectBttn.Name = "connectBttn";
            this.connectBttn.Size = new System.Drawing.Size(75, 23);
            this.connectBttn.TabIndex = 7;
            this.connectBttn.Text = "Connect";
            this.connectBttn.UseVisualStyleBackColor = true;
            this.connectBttn.Click += new System.EventHandler(this.connectBttn_Click);
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(15, 70);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(317, 10);
            this.progressBar.TabIndex = 6;
            this.progressBar.Visible = false;
            // 
            // groupBox
            // 
            this.groupBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox.Controls.Add(this.previousBttn);
            this.groupBox.Controls.Add(this.nextBttn);
            this.groupBox.Controls.Add(this.summaryTxtBx);
            this.groupBox.Controls.Add(this.caseTxtBx);
            this.groupBox.Controls.Add(this.okBttn);
            this.groupBox.Controls.Add(this.caseLbl);
            this.groupBox.Controls.Add(this.projectCmboBx);
            this.groupBox.Controls.Add(this.titleLbl);
            this.groupBox.Controls.Add(this.projectLbl);
            this.groupBox.Controls.Add(this.titleTxtBx);
            this.groupBox.Controls.Add(this.statusCmboBx);
            this.groupBox.Controls.Add(this.priorityLbl);
            this.groupBox.Controls.Add(this.statusLbl);
            this.groupBox.Controls.Add(this.priorityCmboBx);
            this.groupBox.Controls.Add(this.categoryCmboBx);
            this.groupBox.Controls.Add(this.fixForLbl);
            this.groupBox.Controls.Add(this.categoryLbl);
            this.groupBox.Controls.Add(this.fixForCmboBx);
            this.groupBox.Controls.Add(this.assignedToCmboBx);
            this.groupBox.Controls.Add(this.assignedToLbl);
            this.groupBox.Location = new System.Drawing.Point(15, 93);
            this.groupBox.Name = "groupBox";
            this.groupBox.Size = new System.Drawing.Size(398, 273);
            this.groupBox.TabIndex = 8;
            this.groupBox.TabStop = false;
            this.groupBox.Text = "Case to edit";
            // 
            // previousBttn
            // 
            this.previousBttn.Enabled = false;
            this.previousBttn.Location = new System.Drawing.Point(252, 16);
            this.previousBttn.Name = "previousBttn";
            this.previousBttn.Size = new System.Drawing.Size(65, 23);
            this.previousBttn.TabIndex = 19;
            this.previousBttn.Text = "< Previous";
            this.previousBttn.UseVisualStyleBackColor = true;
            this.previousBttn.Click += new System.EventHandler(this.previousBttn_Click);
            // 
            // nextBttn
            // 
            this.nextBttn.Enabled = false;
            this.nextBttn.Location = new System.Drawing.Point(323, 16);
            this.nextBttn.Name = "nextBttn";
            this.nextBttn.Size = new System.Drawing.Size(65, 23);
            this.nextBttn.TabIndex = 18;
            this.nextBttn.Text = "Next >";
            this.nextBttn.UseVisualStyleBackColor = true;
            this.nextBttn.Click += new System.EventHandler(this.nextBttn_Click);
            // 
            // summaryTxtBx
            // 
            this.summaryTxtBx.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.summaryTxtBx.BackColor = System.Drawing.SystemColors.Window;
            this.summaryTxtBx.Enabled = false;
            this.summaryTxtBx.Location = new System.Drawing.Point(10, 155);
            this.summaryTxtBx.Multiline = true;
            this.summaryTxtBx.Name = "summaryTxtBx";
            this.summaryTxtBx.ReadOnly = true;
            this.summaryTxtBx.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.summaryTxtBx.Size = new System.Drawing.Size(378, 112);
            this.summaryTxtBx.TabIndex = 17;
            this.summaryTxtBx.WordWrap = false;
            // 
            // connectedLbl
            // 
            this.connectedLbl.AutoSize = true;
            this.connectedLbl.Location = new System.Drawing.Point(12, 67);
            this.connectedLbl.Name = "connectedLbl";
            this.connectedLbl.Size = new System.Drawing.Size(12, 13);
            this.connectedLbl.TabIndex = 10;
            this.connectedLbl.Text = "x";
            // 
            // resultLbl
            // 
            this.resultLbl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.resultLbl.AutoSize = true;
            this.resultLbl.Location = new System.Drawing.Point(17, 377);
            this.resultLbl.Name = "resultLbl";
            this.resultLbl.Size = new System.Drawing.Size(12, 13);
            this.resultLbl.TabIndex = 11;
            this.resultLbl.Text = "x";
            this.resultLbl.Click += new System.EventHandler(this.resultLbl_Click);
            // 
            // closeBttn
            // 
            this.closeBttn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.closeBttn.Location = new System.Drawing.Point(338, 372);
            this.closeBttn.Name = "closeBttn";
            this.closeBttn.Size = new System.Drawing.Size(75, 23);
            this.closeBttn.TabIndex = 12;
            this.closeBttn.Text = "Close";
            this.closeBttn.UseVisualStyleBackColor = true;
            this.closeBttn.Click += new System.EventHandler(this.closeBttn_Click);
            // 
            // Form1
            // 
            this.AcceptButton = this.okBttn;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(424, 407);
            this.Controls.Add(this.closeBttn);
            this.Controls.Add(this.resultLbl);
            this.Controls.Add(this.connectedLbl);
            this.Controls.Add(this.groupBox);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.connectBttn);
            this.Controls.Add(this.saveBttn);
            this.Controls.Add(this.passwordLbl);
            this.Controls.Add(this.passwordTxtBx);
            this.Controls.Add(this.usernameLbl);
            this.Controls.Add(this.usernameTxtBx);
            this.Controls.Add(this.urlLbl);
            this.Controls.Add(this.urlTxtBx);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(440, 331);
            this.Name = "Form1";
            this.Text = "FogBugz Edit";
            this.groupBox.ResumeLayout(false);
            this.groupBox.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox caseTxtBx;
        private System.Windows.Forms.Button okBttn;
        private System.Windows.Forms.TextBox urlTxtBx;
        private System.Windows.Forms.Label urlLbl;
        private System.Windows.Forms.TextBox usernameTxtBx;
        private System.Windows.Forms.Label usernameLbl;
        private System.Windows.Forms.TextBox passwordTxtBx;
        private System.Windows.Forms.Label passwordLbl;
        private System.Windows.Forms.Label caseLbl;
        private System.Windows.Forms.ComboBox projectCmboBx;
        private System.Windows.Forms.Label projectLbl;
        private System.Windows.Forms.Label statusLbl;
        private System.Windows.Forms.ComboBox statusCmboBx;
        private System.Windows.Forms.Label categoryLbl;
        private System.Windows.Forms.ComboBox categoryCmboBx;
        private System.Windows.Forms.Label assignedToLbl;
        private System.Windows.Forms.ComboBox assignedToCmboBx;
        private System.Windows.Forms.Label fixForLbl;
        private System.Windows.Forms.ComboBox fixForCmboBx;
        private System.Windows.Forms.Label priorityLbl;
        private System.Windows.Forms.ComboBox priorityCmboBx;
        private System.Windows.Forms.Label titleLbl;
        private System.Windows.Forms.TextBox titleTxtBx;
        private System.Windows.Forms.Button saveBttn;
        private System.Windows.Forms.Button connectBttn;
        private System.Windows.Forms.ProgressBar progressBar;
        private System.Windows.Forms.GroupBox groupBox;
        private System.Windows.Forms.Label connectedLbl;
        private System.Windows.Forms.Label resultLbl;
        private System.Windows.Forms.TextBox summaryTxtBx;
        private System.Windows.Forms.Button closeBttn;
        private System.Windows.Forms.Button previousBttn;
        private System.Windows.Forms.Button nextBttn;
    }
}

