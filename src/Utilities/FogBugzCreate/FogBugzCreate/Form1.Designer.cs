namespace FogBugzCreate
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
            this.titleTxtBx = new System.Windows.Forms.TextBox();
            this.titleLbl = new System.Windows.Forms.Label();
            this.createBttn = new System.Windows.Forms.Button();
            this.projectCmboBx = new System.Windows.Forms.ComboBox();
            this.projectLbl = new System.Windows.Forms.Label();
            this.fixForLbl = new System.Windows.Forms.Label();
            this.fixForCmboBx = new System.Windows.Forms.ComboBox();
            this.assignedToCmboBx = new System.Windows.Forms.ComboBox();
            this.assignedToLbl = new System.Windows.Forms.Label();
            this.priorityCmboBx = new System.Windows.Forms.ComboBox();
            this.priorityLbl = new System.Windows.Forms.Label();
            this.categoryCmboBx = new System.Windows.Forms.ComboBox();
            this.categoryLbl = new System.Windows.Forms.Label();
            this.urlLbl = new System.Windows.Forms.Label();
            this.urlTxtBx = new System.Windows.Forms.TextBox();
            this.usernameLbl = new System.Windows.Forms.Label();
            this.usernameTxtBx = new System.Windows.Forms.TextBox();
            this.passwordLbl = new System.Windows.Forms.Label();
            this.passwordTxtBx = new System.Windows.Forms.TextBox();
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.attachFilesChkBx = new System.Windows.Forms.CheckBox();
            this.addFileBttn = new System.Windows.Forms.Button();
            this.resultLbl = new System.Windows.Forms.Label();
            this.connectBttn = new System.Windows.Forms.Button();
            this.connectedLbl = new System.Windows.Forms.Label();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.groupBox = new System.Windows.Forms.GroupBox();
            this.descriptionTxtBx = new System.Windows.Forms.TextBox();
            this.templateLbl = new System.Windows.Forms.Label();
            this.templateCmboBx = new System.Windows.Forms.ComboBox();
            this.descriptionLbl = new System.Windows.Forms.Label();
            this.listFiles = new System.Windows.Forms.ListBox();
            this.removeFileBttn = new System.Windows.Forms.Button();
            this.groupBox.SuspendLayout();
            this.SuspendLayout();
            // 
            // titleTxtBx
            // 
            this.titleTxtBx.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.titleTxtBx.Location = new System.Drawing.Point(37, 17);
            this.titleTxtBx.Name = "titleTxtBx";
            this.titleTxtBx.Size = new System.Drawing.Size(355, 20);
            this.titleTxtBx.TabIndex = 0;
            this.titleTxtBx.TextChanged += new System.EventHandler(this.titleTxtBx_TextChanged);
            // 
            // titleLbl
            // 
            this.titleLbl.AutoSize = true;
            this.titleLbl.Location = new System.Drawing.Point(6, 20);
            this.titleLbl.Name = "titleLbl";
            this.titleLbl.Size = new System.Drawing.Size(30, 13);
            this.titleLbl.TabIndex = 1;
            this.titleLbl.Text = "Title:";
            // 
            // createBttn
            // 
            this.createBttn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.createBttn.Enabled = false;
            this.createBttn.Location = new System.Drawing.Point(329, 326);
            this.createBttn.Name = "createBttn";
            this.createBttn.Size = new System.Drawing.Size(84, 40);
            this.createBttn.TabIndex = 5;
            this.createBttn.Text = "Create";
            this.createBttn.UseVisualStyleBackColor = true;
            this.createBttn.Click += new System.EventHandler(this.createBttn_Click);
            // 
            // projectCmboBx
            // 
            this.projectCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.projectCmboBx.FormattingEnabled = true;
            this.projectCmboBx.Location = new System.Drawing.Point(48, 43);
            this.projectCmboBx.Name = "projectCmboBx";
            this.projectCmboBx.Size = new System.Drawing.Size(121, 21);
            this.projectCmboBx.TabIndex = 1;
            // 
            // projectLbl
            // 
            this.projectLbl.AutoSize = true;
            this.projectLbl.Location = new System.Drawing.Point(6, 46);
            this.projectLbl.Name = "projectLbl";
            this.projectLbl.Size = new System.Drawing.Size(43, 13);
            this.projectLbl.TabIndex = 4;
            this.projectLbl.Text = "Project:";
            // 
            // fixForLbl
            // 
            this.fixForLbl.AutoSize = true;
            this.fixForLbl.Location = new System.Drawing.Point(6, 73);
            this.fixForLbl.Name = "fixForLbl";
            this.fixForLbl.Size = new System.Drawing.Size(38, 13);
            this.fixForLbl.TabIndex = 5;
            this.fixForLbl.Text = "Fix for:";
            // 
            // fixForCmboBx
            // 
            this.fixForCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.fixForCmboBx.FormattingEnabled = true;
            this.fixForCmboBx.Items.AddRange(new object[] {
            "Undecided"});
            this.fixForCmboBx.Location = new System.Drawing.Point(48, 70);
            this.fixForCmboBx.Name = "fixForCmboBx";
            this.fixForCmboBx.Size = new System.Drawing.Size(121, 21);
            this.fixForCmboBx.TabIndex = 3;
            // 
            // assignedToCmboBx
            // 
            this.assignedToCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.assignedToCmboBx.FormattingEnabled = true;
            this.assignedToCmboBx.Location = new System.Drawing.Point(269, 70);
            this.assignedToCmboBx.Name = "assignedToCmboBx";
            this.assignedToCmboBx.Size = new System.Drawing.Size(121, 21);
            this.assignedToCmboBx.TabIndex = 4;
            // 
            // assignedToLbl
            // 
            this.assignedToLbl.AutoSize = true;
            this.assignedToLbl.Location = new System.Drawing.Point(203, 73);
            this.assignedToLbl.Name = "assignedToLbl";
            this.assignedToLbl.Size = new System.Drawing.Size(65, 13);
            this.assignedToLbl.TabIndex = 8;
            this.assignedToLbl.Text = "Assigned to:";
            // 
            // priorityCmboBx
            // 
            this.priorityCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.priorityCmboBx.FormattingEnabled = true;
            this.priorityCmboBx.Location = new System.Drawing.Point(48, 97);
            this.priorityCmboBx.Name = "priorityCmboBx";
            this.priorityCmboBx.Size = new System.Drawing.Size(121, 21);
            this.priorityCmboBx.TabIndex = 5;
            // 
            // priorityLbl
            // 
            this.priorityLbl.AutoSize = true;
            this.priorityLbl.Location = new System.Drawing.Point(6, 100);
            this.priorityLbl.Name = "priorityLbl";
            this.priorityLbl.Size = new System.Drawing.Size(41, 13);
            this.priorityLbl.TabIndex = 10;
            this.priorityLbl.Text = "Priority:";
            // 
            // categoryCmboBx
            // 
            this.categoryCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.categoryCmboBx.FormattingEnabled = true;
            this.categoryCmboBx.Location = new System.Drawing.Point(269, 43);
            this.categoryCmboBx.Name = "categoryCmboBx";
            this.categoryCmboBx.Size = new System.Drawing.Size(121, 21);
            this.categoryCmboBx.TabIndex = 2;
            // 
            // categoryLbl
            // 
            this.categoryLbl.AutoSize = true;
            this.categoryLbl.Location = new System.Drawing.Point(216, 46);
            this.categoryLbl.Name = "categoryLbl";
            this.categoryLbl.Size = new System.Drawing.Size(52, 13);
            this.categoryLbl.TabIndex = 12;
            this.categoryLbl.Text = "Category:";
            // 
            // urlLbl
            // 
            this.urlLbl.AutoSize = true;
            this.urlLbl.Location = new System.Drawing.Point(12, 9);
            this.urlLbl.Name = "urlLbl";
            this.urlLbl.Size = new System.Drawing.Size(32, 13);
            this.urlLbl.TabIndex = 13;
            this.urlLbl.Text = "URL:";
            // 
            // urlTxtBx
            // 
            this.urlTxtBx.Location = new System.Drawing.Point(76, 6);
            this.urlTxtBx.Name = "urlTxtBx";
            this.urlTxtBx.Size = new System.Drawing.Size(337, 20);
            this.urlTxtBx.TabIndex = 6;
            this.urlTxtBx.Text = "https://wirelessadvocates.fogbugz.com/api.asp";
            // 
            // usernameLbl
            // 
            this.usernameLbl.AutoSize = true;
            this.usernameLbl.Location = new System.Drawing.Point(12, 35);
            this.usernameLbl.Name = "usernameLbl";
            this.usernameLbl.Size = new System.Drawing.Size(58, 13);
            this.usernameLbl.TabIndex = 15;
            this.usernameLbl.Text = "Username:";
            // 
            // usernameTxtBx
            // 
            this.usernameTxtBx.Location = new System.Drawing.Point(76, 32);
            this.usernameTxtBx.Name = "usernameTxtBx";
            this.usernameTxtBx.Size = new System.Drawing.Size(169, 20);
            this.usernameTxtBx.TabIndex = 7;
            this.usernameTxtBx.Text = "jcardon@wirelessadvocates.com";
            // 
            // passwordLbl
            // 
            this.passwordLbl.AutoSize = true;
            this.passwordLbl.Location = new System.Drawing.Point(276, 35);
            this.passwordLbl.Name = "passwordLbl";
            this.passwordLbl.Size = new System.Drawing.Size(56, 13);
            this.passwordLbl.TabIndex = 17;
            this.passwordLbl.Text = "Password:";
            // 
            // passwordTxtBx
            // 
            this.passwordTxtBx.Location = new System.Drawing.Point(338, 32);
            this.passwordTxtBx.Name = "passwordTxtBx";
            this.passwordTxtBx.PasswordChar = '*';
            this.passwordTxtBx.Size = new System.Drawing.Size(75, 20);
            this.passwordTxtBx.TabIndex = 8;
            this.passwordTxtBx.Text = "Jnslnjclzn1";
            // 
            // attachFilesChkBx
            // 
            this.attachFilesChkBx.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.attachFilesChkBx.AutoSize = true;
            this.attachFilesChkBx.Enabled = false;
            this.attachFilesChkBx.Location = new System.Drawing.Point(13, 317);
            this.attachFilesChkBx.Name = "attachFilesChkBx";
            this.attachFilesChkBx.Size = new System.Drawing.Size(83, 17);
            this.attachFilesChkBx.TabIndex = 1;
            this.attachFilesChkBx.Text = "Attachment:";
            this.attachFilesChkBx.UseVisualStyleBackColor = true;
            this.attachFilesChkBx.CheckedChanged += new System.EventHandler(this.attachFilesChkBx_CheckedChanged);
            // 
            // addFileBttn
            // 
            this.addFileBttn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.addFileBttn.Enabled = false;
            this.addFileBttn.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.addFileBttn.Image = ((System.Drawing.Image)(resources.GetObject("addFileBttn.Image")));
            this.addFileBttn.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.addFileBttn.Location = new System.Drawing.Point(301, 320);
            this.addFileBttn.Name = "addFileBttn";
            this.addFileBttn.Size = new System.Drawing.Size(24, 24);
            this.addFileBttn.TabIndex = 3;
            this.addFileBttn.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.addFileBttn.UseVisualStyleBackColor = true;
            this.addFileBttn.Click += new System.EventHandler(this.openFileDlg_Click);
            // 
            // resultLbl
            // 
            this.resultLbl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.resultLbl.Location = new System.Drawing.Point(198, 100);
            this.resultLbl.Name = "resultLbl";
            this.resultLbl.Size = new System.Drawing.Size(192, 18);
            this.resultLbl.TabIndex = 23;
            this.resultLbl.Text = "x";
            this.resultLbl.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.resultLbl.Click += new System.EventHandler(this.resultLbl_Click);
            // 
            // connectBttn
            // 
            this.connectBttn.Location = new System.Drawing.Point(338, 58);
            this.connectBttn.Name = "connectBttn";
            this.connectBttn.Size = new System.Drawing.Size(75, 23);
            this.connectBttn.TabIndex = 9;
            this.connectBttn.Text = "Connect";
            this.connectBttn.UseVisualStyleBackColor = true;
            this.connectBttn.Click += new System.EventHandler(this.connectBttn_Click);
            // 
            // connectedLbl
            // 
            this.connectedLbl.AutoSize = true;
            this.connectedLbl.Location = new System.Drawing.Point(12, 60);
            this.connectedLbl.Name = "connectedLbl";
            this.connectedLbl.Size = new System.Drawing.Size(12, 13);
            this.connectedLbl.TabIndex = 25;
            this.connectedLbl.Text = "x";
            this.connectedLbl.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(15, 64);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(317, 12);
            this.progressBar.TabIndex = 26;
            this.progressBar.Visible = false;
            // 
            // groupBox
            // 
            this.groupBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox.Controls.Add(this.descriptionTxtBx);
            this.groupBox.Controls.Add(this.templateLbl);
            this.groupBox.Controls.Add(this.templateCmboBx);
            this.groupBox.Controls.Add(this.descriptionLbl);
            this.groupBox.Controls.Add(this.titleTxtBx);
            this.groupBox.Controls.Add(this.categoryCmboBx);
            this.groupBox.Controls.Add(this.assignedToCmboBx);
            this.groupBox.Controls.Add(this.assignedToLbl);
            this.groupBox.Controls.Add(this.resultLbl);
            this.groupBox.Controls.Add(this.categoryLbl);
            this.groupBox.Controls.Add(this.projectCmboBx);
            this.groupBox.Controls.Add(this.titleLbl);
            this.groupBox.Controls.Add(this.projectLbl);
            this.groupBox.Controls.Add(this.fixForLbl);
            this.groupBox.Controls.Add(this.fixForCmboBx);
            this.groupBox.Controls.Add(this.priorityCmboBx);
            this.groupBox.Controls.Add(this.priorityLbl);
            this.groupBox.Enabled = false;
            this.groupBox.Location = new System.Drawing.Point(15, 82);
            this.groupBox.Name = "groupBox";
            this.groupBox.Size = new System.Drawing.Size(398, 229);
            this.groupBox.TabIndex = 0;
            this.groupBox.TabStop = false;
            this.groupBox.Text = "Case";
            // 
            // descriptionTxtBx
            // 
            this.descriptionTxtBx.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.descriptionTxtBx.Location = new System.Drawing.Point(9, 145);
            this.descriptionTxtBx.Multiline = true;
            this.descriptionTxtBx.Name = "descriptionTxtBx";
            this.descriptionTxtBx.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.descriptionTxtBx.Size = new System.Drawing.Size(381, 77);
            this.descriptionTxtBx.TabIndex = 28;
            // 
            // templateLbl
            // 
            this.templateLbl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.templateLbl.AutoSize = true;
            this.templateLbl.Location = new System.Drawing.Point(246, 127);
            this.templateLbl.Name = "templateLbl";
            this.templateLbl.Size = new System.Drawing.Size(54, 13);
            this.templateLbl.TabIndex = 27;
            this.templateLbl.Text = "Template:";
            // 
            // templateCmboBx
            // 
            this.templateCmboBx.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.templateCmboBx.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.templateCmboBx.FormattingEnabled = true;
            this.templateCmboBx.Location = new System.Drawing.Point(306, 122);
            this.templateCmboBx.Name = "templateCmboBx";
            this.templateCmboBx.Size = new System.Drawing.Size(84, 21);
            this.templateCmboBx.TabIndex = 6;
            this.templateCmboBx.SelectedIndexChanged += new System.EventHandler(this.templateCmboBx_SelectedIndexChanged);
            // 
            // descriptionLbl
            // 
            this.descriptionLbl.AutoSize = true;
            this.descriptionLbl.Location = new System.Drawing.Point(6, 127);
            this.descriptionLbl.Name = "descriptionLbl";
            this.descriptionLbl.Size = new System.Drawing.Size(63, 13);
            this.descriptionLbl.TabIndex = 25;
            this.descriptionLbl.Text = "Description:";
            // 
            // listFiles
            // 
            this.listFiles.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.listFiles.BackColor = System.Drawing.SystemColors.Control;
            this.listFiles.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.listFiles.Enabled = false;
            this.listFiles.FormattingEnabled = true;
            this.listFiles.Location = new System.Drawing.Point(92, 317);
            this.listFiles.Name = "listFiles";
            this.listFiles.Size = new System.Drawing.Size(209, 54);
            this.listFiles.TabIndex = 2;
            // 
            // removeFileBttn
            // 
            this.removeFileBttn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.removeFileBttn.Enabled = false;
            this.removeFileBttn.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.removeFileBttn.Image = ((System.Drawing.Image)(resources.GetObject("removeFileBttn.Image")));
            this.removeFileBttn.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.removeFileBttn.Location = new System.Drawing.Point(301, 344);
            this.removeFileBttn.Name = "removeFileBttn";
            this.removeFileBttn.Size = new System.Drawing.Size(24, 24);
            this.removeFileBttn.TabIndex = 4;
            this.removeFileBttn.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.removeFileBttn.UseVisualStyleBackColor = true;
            this.removeFileBttn.Click += new System.EventHandler(this.removeFileBttn_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(425, 378);
            this.Controls.Add(this.listFiles);
            this.Controls.Add(this.removeFileBttn);
            this.Controls.Add(this.groupBox);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.connectedLbl);
            this.Controls.Add(this.connectBttn);
            this.Controls.Add(this.addFileBttn);
            this.Controls.Add(this.attachFilesChkBx);
            this.Controls.Add(this.passwordTxtBx);
            this.Controls.Add(this.passwordLbl);
            this.Controls.Add(this.usernameTxtBx);
            this.Controls.Add(this.usernameLbl);
            this.Controls.Add(this.urlTxtBx);
            this.Controls.Add(this.urlLbl);
            this.Controls.Add(this.createBttn);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(441, 416);
            this.Name = "Form1";
            this.Text = "Create Case";
            this.groupBox.ResumeLayout(false);
            this.groupBox.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox titleTxtBx;
        private System.Windows.Forms.Label titleLbl;
        private System.Windows.Forms.Button createBttn;
        private System.Windows.Forms.ComboBox projectCmboBx;
        private System.Windows.Forms.Label projectLbl;
        private System.Windows.Forms.Label fixForLbl;
        private System.Windows.Forms.ComboBox fixForCmboBx;
        private System.Windows.Forms.ComboBox assignedToCmboBx;
        private System.Windows.Forms.Label assignedToLbl;
        private System.Windows.Forms.ComboBox priorityCmboBx;
        private System.Windows.Forms.Label priorityLbl;
        private System.Windows.Forms.ComboBox categoryCmboBx;
        private System.Windows.Forms.Label categoryLbl;
        private System.Windows.Forms.Label urlLbl;
        private System.Windows.Forms.TextBox urlTxtBx;
        private System.Windows.Forms.Label usernameLbl;
        private System.Windows.Forms.TextBox usernameTxtBx;
        private System.Windows.Forms.Label passwordLbl;
        private System.Windows.Forms.TextBox passwordTxtBx;
        private System.Windows.Forms.OpenFileDialog openFileDialog;
        private System.Windows.Forms.CheckBox attachFilesChkBx;
        private System.Windows.Forms.Button addFileBttn;
        private System.Windows.Forms.Label resultLbl;
        private System.Windows.Forms.Button connectBttn;
        private System.Windows.Forms.Label connectedLbl;
        private System.Windows.Forms.ProgressBar progressBar;
        private System.Windows.Forms.GroupBox groupBox;
        private System.Windows.Forms.ListBox listFiles;
        private System.Windows.Forms.Button removeFileBttn;
        private System.Windows.Forms.Label descriptionLbl;
        private System.Windows.Forms.Label templateLbl;
        private System.Windows.Forms.ComboBox templateCmboBx;
        private System.Windows.Forms.TextBox descriptionTxtBx;
    }
}

