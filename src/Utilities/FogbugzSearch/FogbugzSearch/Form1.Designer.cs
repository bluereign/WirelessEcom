namespace FogbugzSearch
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.searchStringTxtBx = new System.Windows.Forms.TextBox();
            this.searchBttn = new System.Windows.Forms.Button();
            this.urlTxtBx = new System.Windows.Forms.TextBox();
            this.urlLbl = new System.Windows.Forms.Label();
            this.usernameTxtBx = new System.Windows.Forms.TextBox();
            this.usernameLbl = new System.Windows.Forms.Label();
            this.passwordTxtBx = new System.Windows.Forms.TextBox();
            this.passwordLbl = new System.Windows.Forms.Label();
            this.sentTxtBx = new System.Windows.Forms.TextBox();
            this.receivedTxtBx = new System.Windows.Forms.TextBox();
            this.searchLbl = new System.Windows.Forms.Label();
            this.rawChkBx = new System.Windows.Forms.CheckBox();
            this.caseCountLbl = new System.Windows.Forms.Label();
            this.itemsLstVw = new System.Windows.Forms.ListView();
            this.caseHeader = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.titleHeader = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.closeBttn = new System.Windows.Forms.Button();
            this.contextMenu1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.editContextMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.openContextMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.contextMenu1.SuspendLayout();
            this.SuspendLayout();
            // 
            // searchStringTxtBx
            // 
            this.searchStringTxtBx.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.searchStringTxtBx.AutoCompleteCustomSource.AddRange(new string[] {
            "AlsoEditedBy",
            "Area",
            "AssignedTo",
            "Case",
            "Category",
            "Closed",
            "ClosedBy",
            "CommunityUser",
            "CreatedBy",
            "Due",
            "EditedBy",
            "ElapsedTime",
            "EstimateCurrent",
            "EstimateOriginal",
            "From",
            "Improve",
            "ixBug",
            "LastEdited",
            "LastEditedBy",
            "LastOccurence",
            "Milestone",
            "Occurrences",
            "Opened",
            "OpenedBy",
            "OrderBy",
            "Outline",
            "Parent",
            "Priority",
            "Project",
            "ProjectGroup",
            "RelatedTo",
            "Release",
            "ReleaseNotes",
            "RemainingTime",
            "Requirement",
            "Resolved",
            "Root",
            "Show",
            "StarredBy",
            "Status",
            "Tag",
            "Title",
            "To",
            "Type",
            "View",
            "ViewedBy",
            "Wiki"});
            this.searchStringTxtBx.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.searchStringTxtBx.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.CustomSource;
            this.searchStringTxtBx.Location = new System.Drawing.Point(62, 74);
            this.searchStringTxtBx.Name = "searchStringTxtBx";
            this.searchStringTxtBx.Size = new System.Drawing.Size(331, 20);
            this.searchStringTxtBx.TabIndex = 0;
            this.searchStringTxtBx.KeyUp += new System.Windows.Forms.KeyEventHandler(this.searchStringTxtBx_KeyUp);
            // 
            // searchBttn
            // 
            this.searchBttn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.searchBttn.Location = new System.Drawing.Point(237, 227);
            this.searchBttn.Name = "searchBttn";
            this.searchBttn.Size = new System.Drawing.Size(75, 23);
            this.searchBttn.TabIndex = 2;
            this.searchBttn.Text = "Search";
            this.searchBttn.UseVisualStyleBackColor = true;
            this.searchBttn.Click += new System.EventHandler(this.searchBttn_Click);
            // 
            // urlTxtBx
            // 
            this.urlTxtBx.Location = new System.Drawing.Point(50, 12);
            this.urlTxtBx.Name = "urlTxtBx";
            this.urlTxtBx.Size = new System.Drawing.Size(343, 20);
            this.urlTxtBx.TabIndex = 4;
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
            this.usernameTxtBx.TabIndex = 5;
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
            this.passwordTxtBx.Size = new System.Drawing.Size(67, 20);
            this.passwordTxtBx.TabIndex = 6;
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
            // sentTxtBx
            // 
            this.sentTxtBx.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.sentTxtBx.Location = new System.Drawing.Point(12, 100);
            this.sentTxtBx.Multiline = true;
            this.sentTxtBx.Name = "sentTxtBx";
            this.sentTxtBx.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.sentTxtBx.Size = new System.Drawing.Size(185, 122);
            this.sentTxtBx.TabIndex = 8;
            this.sentTxtBx.Visible = false;
            // 
            // receivedTxtBx
            // 
            this.receivedTxtBx.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.receivedTxtBx.Location = new System.Drawing.Point(208, 100);
            this.receivedTxtBx.Multiline = true;
            this.receivedTxtBx.Name = "receivedTxtBx";
            this.receivedTxtBx.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.receivedTxtBx.Size = new System.Drawing.Size(185, 122);
            this.receivedTxtBx.TabIndex = 9;
            this.receivedTxtBx.Visible = false;
            // 
            // searchLbl
            // 
            this.searchLbl.AutoSize = true;
            this.searchLbl.Location = new System.Drawing.Point(12, 77);
            this.searchLbl.Name = "searchLbl";
            this.searchLbl.Size = new System.Drawing.Size(44, 13);
            this.searchLbl.TabIndex = 6;
            this.searchLbl.Text = "Search:";
            // 
            // rawChkBx
            // 
            this.rawChkBx.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.rawChkBx.AutoSize = true;
            this.rawChkBx.Location = new System.Drawing.Point(159, 231);
            this.rawChkBx.Name = "rawChkBx";
            this.rawChkBx.Size = new System.Drawing.Size(72, 17);
            this.rawChkBx.TabIndex = 3;
            this.rawChkBx.Text = "Raw data";
            this.rawChkBx.UseVisualStyleBackColor = true;
            this.rawChkBx.CheckedChanged += new System.EventHandler(this.rawChkBx_CheckedChanged);
            // 
            // caseCountLbl
            // 
            this.caseCountLbl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.caseCountLbl.AutoSize = true;
            this.caseCountLbl.Location = new System.Drawing.Point(9, 232);
            this.caseCountLbl.Name = "caseCountLbl";
            this.caseCountLbl.Size = new System.Drawing.Size(12, 13);
            this.caseCountLbl.TabIndex = 9;
            this.caseCountLbl.Text = "x";
            // 
            // itemsLstVw
            // 
            this.itemsLstVw.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.itemsLstVw.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.caseHeader,
            this.titleHeader});
            this.itemsLstVw.FullRowSelect = true;
            this.itemsLstVw.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
            this.itemsLstVw.Location = new System.Drawing.Point(12, 100);
            this.itemsLstVw.Name = "itemsLstVw";
            this.itemsLstVw.Size = new System.Drawing.Size(381, 121);
            this.itemsLstVw.TabIndex = 1;
            this.itemsLstVw.UseCompatibleStateImageBehavior = false;
            this.itemsLstVw.View = System.Windows.Forms.View.Details;
            this.itemsLstVw.SizeChanged += new System.EventHandler(this.itemsLstVw_SizeChanged);
            this.itemsLstVw.DoubleClick += new System.EventHandler(this.itemsLstVw_DoubleClick);
            this.itemsLstVw.MouseClick += new System.Windows.Forms.MouseEventHandler(this.itemsLstVw_MouseClick);
            // 
            // caseHeader
            // 
            this.caseHeader.Text = "Case";
            this.caseHeader.Width = 51;
            // 
            // titleHeader
            // 
            this.titleHeader.Text = "Title";
            this.titleHeader.Width = 326;
            // 
            // closeBttn
            // 
            this.closeBttn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.closeBttn.Location = new System.Drawing.Point(318, 227);
            this.closeBttn.Name = "closeBttn";
            this.closeBttn.Size = new System.Drawing.Size(75, 23);
            this.closeBttn.TabIndex = 10;
            this.closeBttn.Text = "Close";
            this.closeBttn.UseVisualStyleBackColor = true;
            this.closeBttn.Click += new System.EventHandler(this.closeBttn_Click);
            // 
            // contextMenu1
            // 
            this.contextMenu1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.editContextMenuItem,
            this.openContextMenuItem});
            this.contextMenu1.Name = "contextMenu1";
            this.contextMenu1.RenderMode = System.Windows.Forms.ToolStripRenderMode.System;
            this.contextMenu1.ShowImageMargin = false;
            this.contextMenu1.Size = new System.Drawing.Size(128, 70);
            // 
            // editContextMenuItem
            // 
            this.editContextMenuItem.Name = "editContextMenuItem";
            this.editContextMenuItem.Size = new System.Drawing.Size(127, 22);
            this.editContextMenuItem.Text = "Edit";
            this.editContextMenuItem.Click += new System.EventHandler(this.editContextMenuItem_Click);
            // 
            // openContextMenuItem
            // 
            this.openContextMenuItem.Name = "openContextMenuItem";
            this.openContextMenuItem.Size = new System.Drawing.Size(127, 22);
            this.openContextMenuItem.Text = "Open";
            this.openContextMenuItem.Click += new System.EventHandler(this.openContextMenuItem_Click);
            // 
            // Form1
            // 
            this.AcceptButton = this.searchBttn;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(405, 262);
            this.Controls.Add(this.closeBttn);
            this.Controls.Add(this.itemsLstVw);
            this.Controls.Add(this.caseCountLbl);
            this.Controls.Add(this.rawChkBx);
            this.Controls.Add(this.searchLbl);
            this.Controls.Add(this.receivedTxtBx);
            this.Controls.Add(this.sentTxtBx);
            this.Controls.Add(this.passwordLbl);
            this.Controls.Add(this.passwordTxtBx);
            this.Controls.Add(this.usernameLbl);
            this.Controls.Add(this.usernameTxtBx);
            this.Controls.Add(this.urlLbl);
            this.Controls.Add(this.urlTxtBx);
            this.Controls.Add(this.searchBttn);
            this.Controls.Add(this.searchStringTxtBx);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(421, 300);
            this.Name = "Form1";
            this.Text = "FogBugz Search";
            this.SizeChanged += new System.EventHandler(this.Form1_SizeChanged);
            this.contextMenu1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox searchStringTxtBx;
        private System.Windows.Forms.Button searchBttn;
        private System.Windows.Forms.TextBox urlTxtBx;
        private System.Windows.Forms.Label urlLbl;
        private System.Windows.Forms.TextBox usernameTxtBx;
        private System.Windows.Forms.Label usernameLbl;
        private System.Windows.Forms.TextBox passwordTxtBx;
        private System.Windows.Forms.Label passwordLbl;
        private System.Windows.Forms.TextBox sentTxtBx;
        private System.Windows.Forms.TextBox receivedTxtBx;
        private System.Windows.Forms.Label searchLbl;
        private System.Windows.Forms.CheckBox rawChkBx;
        private System.Windows.Forms.Label caseCountLbl;
        private System.Windows.Forms.ListView itemsLstVw;
        private System.Windows.Forms.ColumnHeader caseHeader;
        private System.Windows.Forms.ColumnHeader titleHeader;
        private System.Windows.Forms.Button closeBttn;
        private System.Windows.Forms.ContextMenuStrip contextMenu1;
        private System.Windows.Forms.ToolStripMenuItem editContextMenuItem;
        private System.Windows.Forms.ToolStripMenuItem openContextMenuItem;
    }
}

