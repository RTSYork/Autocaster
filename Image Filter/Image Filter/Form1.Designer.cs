namespace Image_Filter
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
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.openButton = new System.Windows.Forms.Button();
            this.originalPictureBox = new System.Windows.Forms.PictureBox();
            this.processedPictureBox2 = new System.Windows.Forms.PictureBox();
            this.imageBar = new System.Windows.Forms.TrackBar();
            this.imageCount = new System.Windows.Forms.Label();
            this.loadingBar = new System.Windows.Forms.ProgressBar();
            this.imageProcessor1 = new System.ComponentModel.BackgroundWorker();
            this.processedPictureBox4 = new System.Windows.Forms.PictureBox();
            this.processedPictureBox1 = new System.Windows.Forms.PictureBox();
            this.processedPictureBox3 = new System.Windows.Forms.PictureBox();
            this.mixPictureBox = new System.Windows.Forms.PictureBox();
            this.imageProcessor2 = new System.ComponentModel.BackgroundWorker();
            this.playButton = new System.Windows.Forms.Button();
            this.playTimer = new System.Windows.Forms.Timer(this.components);
            this.imageProcessor3 = new System.ComponentModel.BackgroundWorker();
            this.imageProcessor4 = new System.ComponentModel.BackgroundWorker();
            this.greensLabel = new System.Windows.Forms.Label();
            this.redsLabel = new System.Windows.Forms.Label();
            this.yellowsLabel = new System.Windows.Forms.Label();
            this.bluesLabel = new System.Windows.Forms.Label();
            this.orangesLabel = new System.Windows.Forms.Label();
            this.noteLabels = new System.Windows.Forms.TableLayoutPanel();
            ((System.ComponentModel.ISupportInitialize)(this.originalPictureBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.processedPictureBox2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageBar)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.processedPictureBox4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.processedPictureBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.processedPictureBox3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.mixPictureBox)).BeginInit();
            this.noteLabels.SuspendLayout();
            this.SuspendLayout();
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.Filter = "PNG files|*.png|All files|*.*";
            this.openFileDialog1.Multiselect = true;
            this.openFileDialog1.Title = "Open Images";
            this.openFileDialog1.FileOk += new System.ComponentModel.CancelEventHandler(this.openFileDialog1_FileOk);
            // 
            // openButton
            // 
            this.openButton.Location = new System.Drawing.Point(12, 12);
            this.openButton.Name = "openButton";
            this.openButton.Size = new System.Drawing.Size(96, 23);
            this.openButton.TabIndex = 0;
            this.openButton.Text = "Open Images";
            this.openButton.UseVisualStyleBackColor = true;
            this.openButton.Click += new System.EventHandler(this.openButton_Click);
            // 
            // originalPictureBox
            // 
            this.originalPictureBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.originalPictureBox.Location = new System.Drawing.Point(12, 63);
            this.originalPictureBox.Name = "originalPictureBox";
            this.originalPictureBox.Size = new System.Drawing.Size(440, 250);
            this.originalPictureBox.TabIndex = 1;
            this.originalPictureBox.TabStop = false;
            // 
            // processedPictureBox2
            // 
            this.processedPictureBox2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.processedPictureBox2.Location = new System.Drawing.Point(461, 63);
            this.processedPictureBox2.Name = "processedPictureBox2";
            this.processedPictureBox2.Size = new System.Drawing.Size(440, 250);
            this.processedPictureBox2.TabIndex = 2;
            this.processedPictureBox2.TabStop = false;
            // 
            // imageBar
            // 
            this.imageBar.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.imageBar.Enabled = false;
            this.imageBar.Location = new System.Drawing.Point(195, 12);
            this.imageBar.Maximum = 0;
            this.imageBar.Name = "imageBar";
            this.imageBar.Size = new System.Drawing.Size(1084, 45);
            this.imageBar.TabIndex = 5;
            this.imageBar.Scroll += new System.EventHandler(this.imageBar_Scroll);
            // 
            // imageCount
            // 
            this.imageCount.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.imageCount.Location = new System.Drawing.Point(1285, 15);
            this.imageCount.Name = "imageCount";
            this.imageCount.Size = new System.Drawing.Size(61, 23);
            this.imageCount.TabIndex = 6;
            this.imageCount.Text = "0 / 0";
            this.imageCount.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // loadingBar
            // 
            this.loadingBar.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.loadingBar.Location = new System.Drawing.Point(12, 666);
            this.loadingBar.Name = "loadingBar";
            this.loadingBar.Size = new System.Drawing.Size(1337, 23);
            this.loadingBar.Step = 1;
            this.loadingBar.TabIndex = 7;
            // 
            // imageProcessor1
            // 
            this.imageProcessor1.WorkerReportsProgress = true;
            this.imageProcessor1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.imageProcessor_DoWork);
            this.imageProcessor1.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.imageProcessor_ProgressChanged);
            this.imageProcessor1.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.imageProcessor_RunWorkerCompleted);
            // 
            // processedPictureBox4
            // 
            this.processedPictureBox4.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.processedPictureBox4.Location = new System.Drawing.Point(910, 63);
            this.processedPictureBox4.Name = "processedPictureBox4";
            this.processedPictureBox4.Size = new System.Drawing.Size(440, 250);
            this.processedPictureBox4.TabIndex = 8;
            this.processedPictureBox4.TabStop = false;
            // 
            // processedPictureBox1
            // 
            this.processedPictureBox1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.processedPictureBox1.Location = new System.Drawing.Point(12, 322);
            this.processedPictureBox1.Name = "processedPictureBox1";
            this.processedPictureBox1.Size = new System.Drawing.Size(440, 250);
            this.processedPictureBox1.TabIndex = 9;
            this.processedPictureBox1.TabStop = false;
            // 
            // processedPictureBox3
            // 
            this.processedPictureBox3.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.processedPictureBox3.Location = new System.Drawing.Point(461, 322);
            this.processedPictureBox3.Name = "processedPictureBox3";
            this.processedPictureBox3.Size = new System.Drawing.Size(440, 250);
            this.processedPictureBox3.TabIndex = 10;
            this.processedPictureBox3.TabStop = false;
            // 
            // mixPictureBox
            // 
            this.mixPictureBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mixPictureBox.Location = new System.Drawing.Point(910, 322);
            this.mixPictureBox.Name = "mixPictureBox";
            this.mixPictureBox.Size = new System.Drawing.Size(440, 250);
            this.mixPictureBox.TabIndex = 11;
            this.mixPictureBox.TabStop = false;
            // 
            // imageProcessor2
            // 
            this.imageProcessor2.WorkerReportsProgress = true;
            this.imageProcessor2.DoWork += new System.ComponentModel.DoWorkEventHandler(this.imageProcessor_DoWork);
            this.imageProcessor2.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.imageProcessor_ProgressChanged);
            this.imageProcessor2.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.imageProcessor_RunWorkerCompleted);
            // 
            // playButton
            // 
            this.playButton.Enabled = false;
            this.playButton.Location = new System.Drawing.Point(114, 12);
            this.playButton.Name = "playButton";
            this.playButton.Size = new System.Drawing.Size(75, 23);
            this.playButton.TabIndex = 12;
            this.playButton.Text = "Play";
            this.playButton.UseVisualStyleBackColor = true;
            this.playButton.Click += new System.EventHandler(this.playButton_Click);
            // 
            // playTimer
            // 
            this.playTimer.Interval = 50;
            this.playTimer.Tick += new System.EventHandler(this.playTimer_Tick);
            // 
            // imageProcessor3
            // 
            this.imageProcessor3.WorkerReportsProgress = true;
            this.imageProcessor3.DoWork += new System.ComponentModel.DoWorkEventHandler(this.imageProcessor_DoWork);
            this.imageProcessor3.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.imageProcessor_ProgressChanged);
            this.imageProcessor3.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.imageProcessor_RunWorkerCompleted);
            // 
            // imageProcessor4
            // 
            this.imageProcessor4.WorkerReportsProgress = true;
            this.imageProcessor4.DoWork += new System.ComponentModel.DoWorkEventHandler(this.imageProcessor_DoWork);
            this.imageProcessor4.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.imageProcessor_ProgressChanged);
            this.imageProcessor4.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.imageProcessor_RunWorkerCompleted);
            // 
            // greensLabel
            // 
            this.greensLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.greensLabel.AutoSize = true;
            this.greensLabel.ForeColor = System.Drawing.Color.Green;
            this.greensLabel.Location = new System.Drawing.Point(67, 0);
            this.greensLabel.Name = "greensLabel";
            this.greensLabel.Size = new System.Drawing.Size(10, 13);
            this.greensLabel.TabIndex = 13;
            this.greensLabel.Text = "-";
            this.greensLabel.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // redsLabel
            // 
            this.redsLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.redsLabel.AutoSize = true;
            this.redsLabel.ForeColor = System.Drawing.Color.Red;
            this.redsLabel.Location = new System.Drawing.Point(147, 0);
            this.redsLabel.Name = "redsLabel";
            this.redsLabel.Size = new System.Drawing.Size(10, 13);
            this.redsLabel.TabIndex = 14;
            this.redsLabel.Text = "-";
            this.redsLabel.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // yellowsLabel
            // 
            this.yellowsLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.yellowsLabel.AutoSize = true;
            this.yellowsLabel.ForeColor = System.Drawing.Color.DarkKhaki;
            this.yellowsLabel.Location = new System.Drawing.Point(227, 0);
            this.yellowsLabel.Name = "yellowsLabel";
            this.yellowsLabel.Size = new System.Drawing.Size(10, 13);
            this.yellowsLabel.TabIndex = 15;
            this.yellowsLabel.Text = "-";
            this.yellowsLabel.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // bluesLabel
            // 
            this.bluesLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.bluesLabel.AutoSize = true;
            this.bluesLabel.ForeColor = System.Drawing.Color.Blue;
            this.bluesLabel.Location = new System.Drawing.Point(307, 0);
            this.bluesLabel.Name = "bluesLabel";
            this.bluesLabel.Size = new System.Drawing.Size(10, 13);
            this.bluesLabel.TabIndex = 16;
            this.bluesLabel.Text = "-";
            this.bluesLabel.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // orangesLabel
            // 
            this.orangesLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.orangesLabel.AutoSize = true;
            this.orangesLabel.ForeColor = System.Drawing.Color.Orange;
            this.orangesLabel.Location = new System.Drawing.Point(387, 0);
            this.orangesLabel.Name = "orangesLabel";
            this.orangesLabel.Size = new System.Drawing.Size(10, 13);
            this.orangesLabel.TabIndex = 17;
            this.orangesLabel.Text = "-";
            this.orangesLabel.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // noteLabels
            // 
            this.noteLabels.AutoSize = true;
            this.noteLabels.ColumnCount = 5;
            this.noteLabels.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.noteLabels.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.noteLabels.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.noteLabels.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.noteLabels.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.noteLabels.Controls.Add(this.orangesLabel, 4, 0);
            this.noteLabels.Controls.Add(this.bluesLabel, 3, 0);
            this.noteLabels.Controls.Add(this.yellowsLabel, 2, 0);
            this.noteLabels.Controls.Add(this.redsLabel, 1, 0);
            this.noteLabels.Controls.Add(this.greensLabel, 0, 0);
            this.noteLabels.Location = new System.Drawing.Point(910, 578);
            this.noteLabels.Name = "noteLabels";
            this.noteLabels.RowCount = 1;
            this.noteLabels.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.noteLabels.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.noteLabels.Size = new System.Drawing.Size(400, 33);
            this.noteLabels.TabIndex = 19;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1361, 701);
            this.Controls.Add(this.noteLabels);
            this.Controls.Add(this.playButton);
            this.Controls.Add(this.mixPictureBox);
            this.Controls.Add(this.processedPictureBox3);
            this.Controls.Add(this.processedPictureBox1);
            this.Controls.Add(this.processedPictureBox4);
            this.Controls.Add(this.loadingBar);
            this.Controls.Add(this.processedPictureBox2);
            this.Controls.Add(this.originalPictureBox);
            this.Controls.Add(this.imageCount);
            this.Controls.Add(this.imageBar);
            this.Controls.Add(this.openButton);
            this.Name = "Form1";
            this.Text = "Image Filter";
            ((System.ComponentModel.ISupportInitialize)(this.originalPictureBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.processedPictureBox2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageBar)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.processedPictureBox4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.processedPictureBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.processedPictureBox3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.mixPictureBox)).EndInit();
            this.noteLabels.ResumeLayout(false);
            this.noteLabels.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Button openButton;
        private System.Windows.Forms.PictureBox originalPictureBox;
        private System.Windows.Forms.PictureBox processedPictureBox2;
        private System.Windows.Forms.TrackBar imageBar;
        private System.Windows.Forms.Label imageCount;
        private System.Windows.Forms.ProgressBar loadingBar;
        private System.ComponentModel.BackgroundWorker imageProcessor1;
        private System.Windows.Forms.PictureBox processedPictureBox4;
        private System.Windows.Forms.PictureBox processedPictureBox1;
        private System.Windows.Forms.PictureBox processedPictureBox3;
        private System.Windows.Forms.PictureBox mixPictureBox;
        private System.ComponentModel.BackgroundWorker imageProcessor2;
        private System.Windows.Forms.Button playButton;
        private System.Windows.Forms.Timer playTimer;
        private System.ComponentModel.BackgroundWorker imageProcessor3;
        private System.ComponentModel.BackgroundWorker imageProcessor4;
        private System.Windows.Forms.Label greensLabel;
        private System.Windows.Forms.Label redsLabel;
        private System.Windows.Forms.Label yellowsLabel;
        private System.Windows.Forms.Label bluesLabel;
        private System.Windows.Forms.Label orangesLabel;
        private System.Windows.Forms.TableLayoutPanel noteLabels;
    }
}

