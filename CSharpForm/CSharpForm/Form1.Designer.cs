namespace CSharpForm
{
    partial class mainForm
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
            this.welcomeText = new System.Windows.Forms.TextBox();
            this.nameText = new System.Windows.Forms.TextBox();
            this.helloButton = new System.Windows.Forms.Button();
            this.closeButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // welcomeText
            // 
            this.welcomeText.Location = new System.Drawing.Point(27, 37);
            this.welcomeText.Name = "welcomeText";
            this.welcomeText.ReadOnly = true;
            this.welcomeText.Size = new System.Drawing.Size(100, 20);
            this.welcomeText.TabIndex = 0;
            // 
            // nameText
            // 
            this.nameText.Location = new System.Drawing.Point(27, 82);
            this.nameText.Name = "nameText";
            this.nameText.Size = new System.Drawing.Size(100, 20);
            this.nameText.TabIndex = 1;
            // 
            // helloButton
            // 
            this.helloButton.Location = new System.Drawing.Point(39, 132);
            this.helloButton.Name = "helloButton";
            this.helloButton.Size = new System.Drawing.Size(75, 23);
            this.helloButton.TabIndex = 2;
            this.helloButton.Text = "Hello";
            this.helloButton.UseVisualStyleBackColor = true;
            this.helloButton.Click += new System.EventHandler(this.helloButton_Click);
            // 
            // closeButton
            // 
            this.closeButton.Location = new System.Drawing.Point(39, 177);
            this.closeButton.Name = "closeButton";
            this.closeButton.Size = new System.Drawing.Size(75, 23);
            this.closeButton.TabIndex = 3;
            this.closeButton.Text = "Close";
            this.closeButton.UseVisualStyleBackColor = true;
            this.closeButton.Click += new System.EventHandler(this.closeButton_Click);
            // 
            // mainForm
            // 
            this.AccessibleName = "Greeting Box";
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.ClientSize = new System.Drawing.Size(153, 260);
            this.Controls.Add(this.closeButton);
            this.Controls.Add(this.helloButton);
            this.Controls.Add(this.nameText);
            this.Controls.Add(this.welcomeText);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "mainForm";
            this.Text = "Greeting Box";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox welcomeText;
        private System.Windows.Forms.TextBox nameText;
        private System.Windows.Forms.Button helloButton;
        private System.Windows.Forms.Button closeButton;
    }
}

