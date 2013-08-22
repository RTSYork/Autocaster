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

namespace EthernetStream
{
    public partial class Form1 : Form
    {
        UdpClient udpClient;
        IPEndPoint RemoteIpEndPoint = new IPEndPoint(IPAddress.Any, 0);
        bool open = false;

        int frameWidth = 440;
        int frameHeight = 360;

        Bitmap b;
        byte[] bytes;
        ushort[] imageData;
        byte interlace;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            widthTextBox.Text = frameWidth.ToString();
            heightTextBox.Text = frameHeight.ToString();

            pictureBox1.Width = frameWidth;
            pictureBox1.Height = frameHeight;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (!open)
            {
                frameWidth = int.Parse(widthTextBox.Text);
                frameHeight = int.Parse(heightTextBox.Text);

                pictureBox1.Width = frameWidth;
                pictureBox1.Height = frameHeight;

                button2.Text = "Stop Listening";
                udpClient = new UdpClient(0xF00D);
                udpClient.Client.ReceiveBufferSize = frameWidth * frameHeight * 10;

                open = true;

                b = new Bitmap(frameWidth, frameHeight, PixelFormat.Format16bppRgb565);
                imageData = new ushort[frameWidth * frameHeight / 2];

                UdpState s = new UdpState();
                s.e = RemoteIpEndPoint;
                s.u = udpClient;
                udpClient.BeginReceive(new AsyncCallback(ReceiveCallback), s);              
            }
            else
            {
                open = false;
                button2.Text = "Start Listening";
                udpClient.Close();
            }
        }

        public void ReceiveCallback(IAsyncResult ar)
        {
            UdpClient u = (UdpClient)((UdpState)(ar.AsyncState)).u;
            IPEndPoint e = (IPEndPoint)((UdpState)(ar.AsyncState)).e;
            if (open)
            {
                bytes = u.EndReceive(ar, ref e);

                int y = ((bytes[1] << 8) | bytes[0]) / 2;
                interlace = (byte)(bytes[0] & 0x1);

                for (int x = 0; x < bytes.Length - 2; x++)
                {
                    if (y < frameHeight && x < frameWidth)
                    {
                        imageData[x + (y * frameWidth)] = (ushort)(((ushort)bytes[x*2+3] << 8) | bytes[x*2+2]);
                    }
                }

                if (y == frameHeight / 2 - 1)
                {
                    updateImage();
                }
            }

            if (open) {
                UdpState s = new UdpState();
                s.e = e;
                s.u = u;
                u.BeginReceive(new AsyncCallback(ReceiveCallback), s);
            }
        }

        public unsafe void updateImage()
        {
            BitmapData bData = b.LockBits(new Rectangle(0, 0, frameWidth, frameHeight), ImageLockMode.ReadWrite, b.PixelFormat);

            byte bitsPerPixel = 16;

            byte* scan0 = (byte*)bData.Scan0.ToPointer();

            for (int i = interlace; i < bData.Height; i+=2)
            {
                for (int j = 0; j < bData.Width; ++j)
                {
                    byte* data = scan0 + i * bData.Stride + j * bitsPerPixel / 8;
                    *((ushort*)data) = imageData[(j + (i/2 * frameWidth))];
                }
            }

            b.UnlockBits(bData);

            pictureBox1.Image = b;
        }

    }

    class UdpState
    {
        public UdpClient u;
        public IPEndPoint e;
    }
}
