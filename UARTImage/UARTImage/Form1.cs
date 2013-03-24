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
using System.Threading;

namespace UARTImage
{
    public partial class Form1 : Form
    {
        int frameWidth = 414;
        int frameHeight = 50;
        int frameCount = 60;

        Bitmap[] b;
        int x;
        int y;
        int z;
        byte[] bytes;
        int i;

        int currentFrame = 0;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            widthTextBox.Text = frameWidth.ToString();
            heightTextBox.Text = frameHeight.ToString();
            framesTextBox.Text = frameCount.ToString();

            pictureBox1.Width = frameWidth;
            pictureBox1.Height = frameHeight;

            frameTrackBar.Maximum = frameCount - 1;
            frameLabel.Text = (currentFrame + 1) + " / " + frameCount;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            openFileDialog1.ShowDialog();
        }

        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            if (!e.Cancel)
            {
                b = new Bitmap[1];

                b[0] = new Bitmap(frameWidth, frameHeight);
                i = 0;

                FileStream fs = (FileStream)openFileDialog1.OpenFile();
                try
                {
                    bytes = new byte[fs.Length];
                    fs.Read(bytes, 0, Convert.ToInt32(fs.Length));
                    fs.Close();
                }
                finally
                {
                    fs.Close();
                }

                for (int y = 0; y < frameHeight; y++)
                {
                    for (int x = 0; x < frameWidth; x++)
                    {
                        if (i > bytes.Length - 3)
                            break;

                        b[0].SetPixel(x, y, Color.FromArgb(bytes[i], bytes[i+1], bytes[i+2]));
                        i += 3;
                    }
                }

                pictureBox1.Image = b[0];
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (!serialPort1.IsOpen)
            {
                frameWidth = int.Parse(widthTextBox.Text);
                frameHeight = int.Parse(heightTextBox.Text);
                frameCount = int.Parse(framesTextBox.Text);

                pictureBox1.Width = frameWidth;
                pictureBox1.Height = frameHeight;

                currentFrame = 0;
                frameTrackBar.Value = 0;
                frameTrackBar.Maximum = frameCount - 1;
                frameLabel.Text = (currentFrame + 1) + " / " + frameCount;

                button2.Text = "Stop Serial";
                serialPort1.Open();

                b = new Bitmap[frameCount];

                for (int a = 0; a < frameCount; a++)
                {
                    b[a] = new Bitmap(frameWidth, frameHeight);
                }

                x = 0;
                y = 0;
                z = 0;
                i = 0;
                bytes = new byte[3];
                timer1.Start();
            }
            else
            {
                button2.Text = "Start Serial";
                serialPort1.Close();
                timer1.Stop();
            }
        }

        private void serialPort1_DataReceived(object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
        {
            if (serialPort1.IsOpen)
            {
                while (serialPort1.BytesToRead > 0)
                {
                    bytes[i] = (byte)serialPort1.ReadByte();

                    if (y == frameHeight && z < frameCount - 1)
                    {
                        y = 0;
                        z++;

                        currentFrame = z;
                        //frameTrackBar.Value = z;
                        //frameLabel.Text = (currentFrame + 1) + " / " + frameCount;
                    }

                    if (y < frameHeight)
                    {
                        if (i == 2)
                        {
                            Monitor.Enter(b[z]);
                            b[z].SetPixel(x, y, Color.FromArgb(bytes[0], bytes[1], bytes[2]));
                            Monitor.Exit(b[z]);

                            x++;
                            if (x == frameWidth)
                            {
                                x = 0;
                                y++;
                            }

                            i = 0;
                        }
                        else
                        {
                            i++;
                        }
                    }
                    else
                    {
                        serialPort1.ReadByte();
                    }
                }
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            Monitor.Enter(b[currentFrame]);
            pictureBox1.Image = (Image)b[currentFrame].Clone();
            Monitor.Exit(b[currentFrame]);

            frameTrackBar.Value = currentFrame;
            frameLabel.Text = (currentFrame + 1) + " / " + frameCount;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            saveFileDialog1.ShowDialog();
        }

        private void saveFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            if (!e.Cancel)
            {
                b[currentFrame].Save(saveFileDialog1.FileName, System.Drawing.Imaging.ImageFormat.Png);
            }
        }

        private void frameTrackBar_Scroll(object sender, EventArgs e)
        {
            currentFrame = frameTrackBar.Value;
            frameLabel.Text = (currentFrame + 1) + " / " + frameCount;

            Monitor.Enter(b[currentFrame]);
            pictureBox1.Image = (Image)b[currentFrame].Clone();
            Monitor.Exit(b[currentFrame]);
        }

        private void saveAllButton_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                for (int a = 0; a < b.Length; a++)
                {
                    String fileName = folderBrowserDialog1.SelectedPath + "\\frame" + (a+1) + ".png";
                    b[a].Save(fileName, System.Drawing.Imaging.ImageFormat.Png);
                }
            }
        }

    }
}
