using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Image_Filter
{
    public partial class Form1 : Form
    {
        int loaded = 0;
        string[] files;
        Bitmap[] originals;
        Bitmap[] greyed;
        Bitmap[] blurred;
        Bitmap[] thresholded;
        Bitmap[] filtered;
        Bitmap[] mixed;
        List<int>[] greens;
        List<int>[] reds;
        List<int>[] yellows;
        List<int>[] blues;
        List<int>[] oranges;
        int width;
        int height;
        int playFrame;

        public Form1()
        {
            InitializeComponent();
        }

        private void openButton_Click(object sender, EventArgs e)
        {
            openFileDialog1.ShowDialog();
        }

        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            if (!e.Cancel)
            {
                clearImages();

                files = openFileDialog1.FileNames;

                if (files.Length > 0)
                {
                    originals = new Bitmap[files.Length];
                    greyed = new Bitmap[files.Length];
                    blurred = new Bitmap[files.Length];
                    thresholded = new Bitmap[files.Length];
                    filtered = new Bitmap[files.Length];
                    mixed = new Bitmap[files.Length];

                    greens = new List<int>[files.Length];
                    reds = new List<int>[files.Length];
                    yellows = new List<int>[files.Length];
                    blues = new List<int>[files.Length];
                    oranges = new List<int>[files.Length];

                    openButton.Enabled = false;
                    imageBar.Enabled = false;
                    playButton.Enabled = false;

                    loadingBar.Maximum = files.Length;

                    // Use up to 4 threads if possible
                    if (files.Length == 1)
                    {
                        loaded = 3;
                        imageProcessor1.RunWorkerAsync(0);
                    }
                    else if (files.Length == 2)
                    {
                        loaded = 2;
                        imageProcessor1.RunWorkerAsync(0);
                        imageProcessor2.RunWorkerAsync(1);
                    }
                    else if (files.Length == 3)
                    {
                        loaded = 1;
                        imageProcessor1.RunWorkerAsync(0);
                        imageProcessor2.RunWorkerAsync(1);
                        imageProcessor3.RunWorkerAsync(2);
                    }
                    else
                    {
                        loaded = 0;
                        imageProcessor1.RunWorkerAsync(0);
                        imageProcessor2.RunWorkerAsync(1);
                        imageProcessor3.RunWorkerAsync(2);
                        imageProcessor4.RunWorkerAsync(3);
                    }
                        
                }
                else
                {
                    loaded = 0;
                    imageBar.Maximum = 0;
                    imageBar.Value = 0;

                    imageBar.Enabled = false;
                    playButton.Enabled = false;

                    imageCount.Text = "0 / 0";
                }
            }
        }

        private void imageBar_Scroll(object sender, EventArgs e)
        {
            if (loaded == 4)
            {
                imageCount.Text = (imageBar.Value + 1) + " / " + (imageBar.Maximum + 1);
                loadImage(imageBar.Value);
            }
        }

        private void loadImage(int index)
        {
            originalPictureBox.Image = originals[index];
            processedPictureBox1.Image = greyed[index];
            processedPictureBox2.Image = thresholded[index];
            processedPictureBox3.Image = blurred[index];
            processedPictureBox4.Image = filtered[index];
            mixPictureBox.Image = mixed[index];

            if (greens[index].Count > 0)
            {
                greensLabel.Text = "";
                foreach (int position in greens[index])
                    greensLabel.Text += position + "\n";
            }
            else
                greensLabel.Text = "-";

            if (reds[index].Count > 0)
            {
                redsLabel.Text = "";
                foreach (int position in reds[index])
                    redsLabel.Text += position + "\n";
            }
            else
                redsLabel.Text = "-";

            if (yellows[index].Count > 0)
            {
                yellowsLabel.Text = "";
                foreach (int position in yellows[index])
                    yellowsLabel.Text += position + "\n";
            }
            else
                yellowsLabel.Text = "-";

            if (blues[index].Count > 0)
            {
                bluesLabel.Text = "";
                foreach (int position in blues[index])
                    bluesLabel.Text += position + "\n";
            }
            else
                bluesLabel.Text = "-";

            if (oranges[index].Count > 0)
            {
                orangesLabel.Text = "";
                foreach (int position in oranges[index])
                    orangesLabel.Text += position + "\n";
            }
            else
                orangesLabel.Text = "-";
        }

        private void clearImages()
        {
            originalPictureBox.Image = null;
            processedPictureBox1.Image = null;
            processedPictureBox2.Image = null;
            processedPictureBox3.Image = null;
            processedPictureBox4.Image = null;
            mixPictureBox.Image = null;

            greensLabel.Text = "-";
            redsLabel.Text = "-";
            yellowsLabel.Text = "-";
            bluesLabel.Text = "-";
            orangesLabel.Text = "-";
        }

        private void processImage(int index)
        {
            Bitmap original = originals[index];
            int width = original.Width;
            int height = original.Height;

            greyed[index] = new Bitmap(width, height);
            blurred[index] = new Bitmap(width, height);
            thresholded[index] = new Bitmap(width, height);
            filtered[index] = new Bitmap(width, height);
            mixed[index] = new Bitmap(width, height);

            greens[index] = new List<int>();
            reds[index] = new List<int>();
            yellows[index] = new List<int>();
            blues[index] = new List<int>();
            oranges[index] = new List<int>();

            Color oldPixel;
            Color newPixel;
            int grey;
            int grey2;
            int grey3;
            int mixR, mixG, mixB;
            int lastGrey1, lastGrey2;

            int[] lastRow1 = new int[width];
            int[] lastRow2 = new int[width];
            for (int i = 0; i < width; i++)
            {
                lastRow1[i] = 0;
                lastRow2[i] = 0;
            }

            for (int y = 0; y < height; y++)
            {
                lastGrey1 = 0;
                lastGrey2 = 0;

                for (int x = 0; x < width; x++)
                {
                    oldPixel = original.GetPixel(x, y);


                    // Greyscale
                    grey = (((oldPixel.G + oldPixel.B) >> 1) + oldPixel.R) >> 1;
                    newPixel = Color.FromArgb(grey, grey, grey);
                    greyed[index].SetPixel(x, y, newPixel);


                    // Threshold
                    if (grey >= 200)
                        grey = 255;
                    else
                        grey = 0;
                    newPixel = Color.FromArgb(grey, grey, grey);
                    thresholded[index].SetPixel(x, y, newPixel);


                    // Blur
                    grey2 = (grey & 0x88) | (lastGrey1 & 0x44) | (lastGrey2 & 0x22) | (lastRow1[x] & 0x11);
                    lastGrey2 = lastGrey1;
                    lastGrey1 = grey;
                    lastRow1[x] = grey;
                    newPixel = Color.FromArgb(grey2, grey2, grey2);
                    blurred[index].SetPixel(x, y, newPixel);


                    // Threshold 2
                    if (grey2 < 255)
                        grey2 = 0;
                    newPixel = Color.FromArgb(grey2, grey2, grey2);
                    filtered[index].SetPixel(x, y, newPixel);

                    // Edge detection
                    grey3 = (lastRow2[x] == 255 && grey2 != 255) ? 255 : 0;
                    lastRow2[x] = grey2;
                    //newPixel = Color.FromArgb(grey3, grey3, grey3);
                    //filtered[index].SetPixel(x, y, newPixel);
                    

                    // Mixed image and note detection
                    if ((y > 150 && y < 200) && ((y >> 2) + (y >> 4)) == (width >> 1) - x - 92)
                    {
                        newPixel = Color.FromArgb(0, 255, 0);
                        if (grey3 == 255)
                        {
                            if (greens[index].Count > 0 && y - greens[index].Last() < 20)
                                greens[index][greens[index].Count - 1] = y;
                            else
                             greens[index].Add(y);
                        }
                    }
                    else if ((y > 150 && y < 200) && ((y >> 3) + (y >> 5)) == (width >> 1) - x - 48)
                    {
                        newPixel = Color.FromArgb(255, 0, 0);
                        if (grey3 == 255)
                            if (reds[index].Count > 0 && y - reds[index].Last() < 20)
                                reds[index][reds[index].Count - 1] = y;
                            else
                                reds[index].Add(y);
                    }
                    else if ((y > 150 && y < 200) && x == (width >> 1))
                    {
                        newPixel = Color.FromArgb(255, 255, 0);
                        if (grey3 == 255)
                            if (yellows[index].Count > 0 && y - yellows[index].Last() < 20)
                                yellows[index][yellows[index].Count - 1] = y;
                            else
                                yellows[index].Add(y);
                    }
                    else if ((y > 150 && y < 200) && ((y >> 3) + (y >> 5)) == x - 48 - (width >> 1))
                    {
                        newPixel = Color.FromArgb(0, 0, 255);
                        if (grey3 == 255)
                            if (blues[index].Count > 0 && y - blues[index].Last() < 20)
                                blues[index][blues[index].Count - 1] = y;
                            else
                                blues[index].Add(y);
                    }
                    else if ((y > 150 && y < 200) && ((y >> 2) + (y >> 4)) == x - 92 - (width >> 1))
                    {
                        newPixel = Color.FromArgb(255, 128, 0);
                        if (grey3 == 255)
                            if (oranges[index].Count > 0 && y - oranges[index].Last() < 20)
                                oranges[index][oranges[index].Count - 1] = y;
                            else
                                oranges[index].Add(y);
                    }
                    else
                    {
                        mixR = Math.Min(255, (oldPixel.R >> 2) + grey3);
                        mixG = Math.Min(255, (oldPixel.G >> 2) + grey3);
                        mixB = Math.Min(255, (oldPixel.B >> 2) + grey3);
                        newPixel = Color.FromArgb(mixR, mixG, mixB);
                    }
                    mixed[index].SetPixel(x, y, newPixel);
                }
            }
        }

        private void imageProcessor_DoWork(object sender, DoWorkEventArgs e)
        {
            for (int i = (int)e.Argument; i < files.Length; i+=4)
            {
                string fileName = files[i];
                originals[i] = new Bitmap(fileName);
                processImage(i);
                
                ((BackgroundWorker)sender).ReportProgress(0);
            }
        }

        private void imageProcessor_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            loadingBar.PerformStep();
        }

        private void imageProcessor_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            loaded++;

            if (loaded < 4)
                return;

            openButton.Enabled = true;
            imageBar.Enabled = true;
            playButton.Enabled = true;

            loadingBar.Value = 0;

            imageBar.Maximum = files.Length - 1;
            imageBar.Value = 0;

            width = originals[0].Width;
            height = originals[0].Height;
            originalPictureBox.Width = width;
            originalPictureBox.Height = height;
            processedPictureBox2.Width = width;
            processedPictureBox2.Height = height;
            processedPictureBox4.Width = width;
            processedPictureBox4.Height = height;
            processedPictureBox1.Width = width;
            processedPictureBox1.Height = height;
            processedPictureBox3.Width = width;
            processedPictureBox3.Height = height;
            mixPictureBox.Width = width;
            mixPictureBox.Height = height;
            noteLabels.Width = width - 40;

            processedPictureBox2.Location = new Point(originalPictureBox.Location.X + width + 10, originalPictureBox.Location.Y);
            processedPictureBox4.Location = new Point(processedPictureBox2.Location.X + width + 10, originalPictureBox.Location.Y);
            processedPictureBox1.Location = new Point(originalPictureBox.Location.X, originalPictureBox.Location.Y + height + 10);
            processedPictureBox3.Location = new Point(processedPictureBox2.Location.X, processedPictureBox1.Location.Y);
            mixPictureBox.Location = new Point(processedPictureBox4.Location.X, processedPictureBox1.Location.Y);
            noteLabels.Location = new Point(mixPictureBox.Location.X, mixPictureBox.Location.Y + height + 5);

            imageCount.Text = "1 / " + files.Length;

            loadImage(0);
        }

        private void playTimer_Tick(object sender, EventArgs e)
        {
            if (playFrame < files.Length)
            {
                imageCount.Text = (playFrame + 1) + " / " + (imageBar.Maximum + 1);
                loadImage(playFrame);
                imageBar.Value = playFrame;
                playFrame++;
            }
            else
            {
                playButton.Text = "Play";
                playTimer.Stop();
            }
        }

        private void playButton_Click(object sender, EventArgs e)
        {
            if (!playTimer.Enabled && loaded == 4)
            {
                playButton.Text = "Stop";
                if (imageBar.Value == imageBar.Maximum)
                    playFrame = 0;
                else
                    playFrame = imageBar.Value;
                playTimer.Start();
            }
            else
            {
                playButton.Text = "Play";
                playTimer.Stop();
            }
        }
    }
}
