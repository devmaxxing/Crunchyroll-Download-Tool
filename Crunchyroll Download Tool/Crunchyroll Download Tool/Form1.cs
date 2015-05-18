using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.Threading;

namespace Crunchyroll_Download_Tool
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            downloadList.Items.Clear();
        }

        private void addURL(object sender, EventArgs e)
        {
            downloadList.Items.Add(urlBox.Text);
            urlBox.Text = "";
        }

        private void startDownload(object sender, EventArgs e)
        {
            String[] items = new String[downloadList.Items.Count];
            downloadList.Items.CopyTo(items,0);
            foreach (String item in items)
            {
                download(item);
            }
            
        }

        private void download(String url)
        {
            String arg1 = "no";
            if (usernameBox.Text != null && passwordBox.Text != null)
                arg1 = usernameBox.Text;
            ExecuteCommandSync("start.bat " + arg1 + " " + passwordBox.Text + " " + url);
            downloadList.Items.Remove(url);         
        }

        void ExecuteCommandSync(object command)
        {
            try
            {
                // create the ProcessStartInfo using "cmd" as the program to be run,
                // and "/c " as the parameters.
                // Incidentally, /c tells cmd that we want it to execute the command that follows,
                // and then exit.
                System.Diagnostics.ProcessStartInfo procStartInfo =
                new System.Diagnostics.ProcessStartInfo("cmd", "/c " + command);

                // The following commands are needed to redirect the standard output.
                // This means that it will be redirected to the Process.StandardOutput StreamReader.
                procStartInfo.RedirectStandardOutput = false;
                procStartInfo.UseShellExecute = false;
                // Do not create the black window.
                procStartInfo.CreateNoWindow = false;
                // Now we create a process, assign its ProcessStartInfo and start it
                System.Diagnostics.Process proc = new System.Diagnostics.Process();
                proc.StartInfo = procStartInfo;

                proc.Start();
                proc.WaitForExit();

            }
            catch (Exception objException)
            {
                Console.WriteLine(objException);
            }
        }

        private void RemoveSelection(object sender, EventArgs e)
        {
            if (downloadList.SelectedItem != null)
            {
                downloadList.Items.Remove(downloadList.SelectedItem);
            }
        }
    }
}
