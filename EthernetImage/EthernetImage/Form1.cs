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
using System.Net.Sockets;
using System.Net;
using System.Drawing.Imaging;

namespace EthernetImage
{
    public partial class Form1 : Form
    {
        UdpClient udpClient;
        IPEndPoint RemoteIpEndPoint = new IPEndPoint(IPAddress.Any, 0);
        bool open = false;

        int frameWidth = 440;
        int frameHeight = 360;
        int frameCount = 120;

        Bitmap[] b;
        int x;
        int y;
        int z;
        int i;
        byte[] bytes;
        uint[] imageData;

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

                        b[0].SetPixel(x, y, Color.FromArgb(bytes[i], bytes[i + 1], bytes[i + 2]));
                        i += 3;
                    }
                }

                pictureBox1.Image = b[0];
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (!open)
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

                button2.Text = "Stop Listening";
                udpClient = new UdpClient(0xF00D);
                udpClient.Client.ReceiveBufferSize = frameWidth * frameHeight * frameCount * 4;
                
                open = true;

                b = new Bitmap[frameCount];

                for (int a = 0; a < frameCount; a++)
                {
                    b[a] = new Bitmap(frameWidth, frameHeight, PixelFormat.Format32bppRgb);
                }

                imageData = new uint[frameWidth * frameHeight];

                UdpState s = new UdpState();
                s.e = RemoteIpEndPoint;
                s.u = udpClient;
                udpClient.BeginReceive(new AsyncCallback(ReceiveCallback), s);

                x = 0;
                y = 0;
                z = 0;
                i = 0;
                timer1.Start();
            }
            else
            {
                open = false;
                button2.Text = "Start Listening";
                udpClient.Close();  
                timer1.Stop();
            }
        }

        public void ReceiveCallback(IAsyncResult ar)
        {
            UdpClient u = (UdpClient)((UdpState)(ar.AsyncState)).u;
            IPEndPoint e = (IPEndPoint)((UdpState)(ar.AsyncState)).e;
            if (open)
            {
                bytes = u.EndReceive(ar, ref e);

                for (int i = 0; i < bytes.Length; i+=4)
                {
                    imageData[x + (y * frameWidth)] = (uint)(((uint)bytes[i + 2] << 16) | ((uint)bytes[i + 1] << 8) | bytes[i]);
                    x++;
                }

                if (x == frameWidth)
                {
                    x = 0;
                    y++;
                }

                if (y == frameHeight && z < frameCount)
                {
                    updateImage();
                    currentFrame = z;
                    z++;
                    y = 0;
                }
            }

            if (open)
            {
                UdpState s = new UdpState();
                s.e = e;
                s.u = u;
                u.BeginReceive(new AsyncCallback(ReceiveCallback), s);
            }
        }

        public unsafe void updateImage()
        {
            BitmapData bData = b[z].LockBits(new Rectangle(0, 0, frameWidth, frameHeight), ImageLockMode.ReadWrite, b[z].PixelFormat);

            byte bitsPerPixel = 32;

            byte* scan0 = (byte*)bData.Scan0.ToPointer();

            for (int i = 0; i < bData.Height; ++i)
            {
                for (int j = 0; j < bData.Width; ++j)
                {
                    byte* data = scan0 + i * bData.Stride + j * bitsPerPixel / 8;
                    *((uint*)data) = imageData[(j + (i * frameWidth))];
                }
            }

            b[z].UnlockBits(bData);

            pictureBox1.Image = b[z];
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
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
                    String fileName = folderBrowserDialog1.SelectedPath + "\\frame" + (a + 1) + ".png";
                    b[a].Save(fileName, System.Drawing.Imaging.ImageFormat.Png);
                }
            }
        }

    }

    class UdpState
    {
        public UdpClient u;
        public IPEndPoint e;
    }
}
