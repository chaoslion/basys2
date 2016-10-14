namespace epp_win {
    partial class frmMain {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent() {
            this.components = new System.ComponentModel.Container();
            this.timMain = new System.Windows.Forms.Timer(this.components);
            this.tbValue = new System.Windows.Forms.TextBox();
            this.cbValue7 = new System.Windows.Forms.CheckBox();
            this.cbValue6 = new System.Windows.Forms.CheckBox();
            this.cbValue4 = new System.Windows.Forms.CheckBox();
            this.cbValue5 = new System.Windows.Forms.CheckBox();
            this.cbValue0 = new System.Windows.Forms.CheckBox();
            this.cbValue1 = new System.Windows.Forms.CheckBox();
            this.cbValue2 = new System.Windows.Forms.CheckBox();
            this.cbValue3 = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // timMain
            // 
            this.timMain.Interval = 1000;
            this.timMain.Tick += new System.EventHandler(this.timMain_Tick);
            // 
            // tbValue
            // 
            this.tbValue.Location = new System.Drawing.Point(11, 13);
            this.tbValue.Name = "tbValue";
            this.tbValue.ReadOnly = true;
            this.tbValue.Size = new System.Drawing.Size(163, 20);
            this.tbValue.TabIndex = 0;
            this.tbValue.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // cbValue7
            // 
            this.cbValue7.AutoCheck = false;
            this.cbValue7.AutoSize = true;
            this.cbValue7.Location = new System.Drawing.Point(12, 39);
            this.cbValue7.Name = "cbValue7";
            this.cbValue7.Size = new System.Drawing.Size(15, 14);
            this.cbValue7.TabIndex = 1;
            this.cbValue7.UseVisualStyleBackColor = true;
            // 
            // cbValue6
            // 
            this.cbValue6.AutoCheck = false;
            this.cbValue6.AutoSize = true;
            this.cbValue6.Location = new System.Drawing.Point(33, 39);
            this.cbValue6.Name = "cbValue6";
            this.cbValue6.Size = new System.Drawing.Size(15, 14);
            this.cbValue6.TabIndex = 2;
            this.cbValue6.UseVisualStyleBackColor = true;
            // 
            // cbValue4
            // 
            this.cbValue4.AutoCheck = false;
            this.cbValue4.AutoSize = true;
            this.cbValue4.Location = new System.Drawing.Point(75, 39);
            this.cbValue4.Name = "cbValue4";
            this.cbValue4.Size = new System.Drawing.Size(15, 14);
            this.cbValue4.TabIndex = 4;
            this.cbValue4.UseVisualStyleBackColor = true;
            // 
            // cbValue5
            // 
            this.cbValue5.AutoCheck = false;
            this.cbValue5.AutoSize = true;
            this.cbValue5.Location = new System.Drawing.Point(54, 39);
            this.cbValue5.Name = "cbValue5";
            this.cbValue5.Size = new System.Drawing.Size(15, 14);
            this.cbValue5.TabIndex = 3;
            this.cbValue5.UseVisualStyleBackColor = true;
            // 
            // cbValue0
            // 
            this.cbValue0.AutoCheck = false;
            this.cbValue0.AutoSize = true;
            this.cbValue0.Location = new System.Drawing.Point(159, 39);
            this.cbValue0.Name = "cbValue0";
            this.cbValue0.Size = new System.Drawing.Size(15, 14);
            this.cbValue0.TabIndex = 8;
            this.cbValue0.UseVisualStyleBackColor = true;
            // 
            // cbValue1
            // 
            this.cbValue1.AutoCheck = false;
            this.cbValue1.AutoSize = true;
            this.cbValue1.Location = new System.Drawing.Point(138, 39);
            this.cbValue1.Name = "cbValue1";
            this.cbValue1.Size = new System.Drawing.Size(15, 14);
            this.cbValue1.TabIndex = 7;
            this.cbValue1.UseVisualStyleBackColor = true;
            // 
            // cbValue2
            // 
            this.cbValue2.AutoCheck = false;
            this.cbValue2.AutoSize = true;
            this.cbValue2.Location = new System.Drawing.Point(117, 39);
            this.cbValue2.Name = "cbValue2";
            this.cbValue2.Size = new System.Drawing.Size(15, 14);
            this.cbValue2.TabIndex = 6;
            this.cbValue2.UseVisualStyleBackColor = true;
            // 
            // cbValue3
            // 
            this.cbValue3.AutoCheck = false;
            this.cbValue3.AutoSize = true;
            this.cbValue3.Location = new System.Drawing.Point(96, 39);
            this.cbValue3.Name = "cbValue3";
            this.cbValue3.Size = new System.Drawing.Size(15, 14);
            this.cbValue3.TabIndex = 5;
            this.cbValue3.UseVisualStyleBackColor = true;
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(183, 64);
            this.Controls.Add(this.cbValue0);
            this.Controls.Add(this.cbValue1);
            this.Controls.Add(this.cbValue2);
            this.Controls.Add(this.cbValue3);
            this.Controls.Add(this.cbValue4);
            this.Controls.Add(this.cbValue5);
            this.Controls.Add(this.cbValue6);
            this.Controls.Add(this.cbValue7);
            this.Controls.Add(this.tbValue);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.Name = "frmMain";
            this.Text = "Counter";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.frmMain_FormClosing);
            this.Load += new System.EventHandler(this.frmMain_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Timer timMain;
        private System.Windows.Forms.TextBox tbValue;
        private System.Windows.Forms.CheckBox cbValue7;
        private System.Windows.Forms.CheckBox cbValue6;
        private System.Windows.Forms.CheckBox cbValue4;
        private System.Windows.Forms.CheckBox cbValue5;
        private System.Windows.Forms.CheckBox cbValue0;
        private System.Windows.Forms.CheckBox cbValue1;
        private System.Windows.Forms.CheckBox cbValue2;
        private System.Windows.Forms.CheckBox cbValue3;
    }
}

