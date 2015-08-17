using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Collections.Specialized;


namespace CJFTP
{
    class Program
    {
        static void Main(string[] args)
        {



            WebClient request = new WebClient();
string url = "ftp://ftp.microsoft.com/developr/fortran/" +"README.TXT";
request.Credentials = new NetworkCredential("anonymous", "anonymous@example.com");

try
{
  byte[] newFileData = request.DownloadData(url);
  string fileString = System.Text.Encoding.UTF8.GetString(newFileData);
  Console.WriteLine(fileString);
}
catch (WebException e)
{
  // Do something such as log error, but this is based on OP's original code
  // so for now we do nothing.
}



    public static FTPFileInfo GetFileInfo(string fileName)
        {
            var dirInfo = WordstockExport.GetFTPDirectoryDetails();
            var list = FTPFileInfo.Load(dirInfo);
            try
            {
                FTPFileInfo ftpFile = list.SingleOrDefault(f => f.FileName == fileName);
                return ftpFile;
            }
            catch { }
            return null;
        }
     class FTPFileInfo
        {
            private DateTime _FileDate;
            private long _FileSize;
            private string _FileName;

            public DateTime FileDate
            {
                get { return _FileDate; }
                set { _FileDate = value; }
            }
            public long FileSize
            {
                get { return _FileSize; }
                set { _FileSize = value; }
            }
            public string FileName
            {
                get { return _FileName; }
                set { _FileName = value; }
            }

            public FTPFileInfo() { }
            public static FTPFileInfo LoadFromLine(string line)
            {
                FTPFileInfo file = new FTPFileInfo();

                string[] ftpFileInfo = line.Split(" ".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                file._FileDate = DateTime.Parse(ftpFileInfo[0] + " " + ftpFileInfo[1]);
                file._FileSize = long.Parse(ftpFileInfo[2]);
                file._FileName = ftpFileInfo[3];

                return file;

            }
            public static List<FTPFileInfo> Load(string listDirectoryDetails)
            {
                List<FTPFileInfo> files = new List<FTPFileInfo>();

                string[] lines = listDirectoryDetails.Split("\r\n".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                foreach(var line in lines)
                    files.Add(LoadFromLine(line));

                return files;
            }

        }
       private static string GetFTPDirectoryDetails()
            {
                FtpWebRequest request = (FtpWebRequest)WebRequest.Create(App.Export_FTPPath);
                request.Method = WebRequestMethods.Ftp.ListDirectoryDetails;
                request.Credentials = new NetworkCredential(App.FTP_User, App.FTP_Password);
                FtpWebResponse response = (FtpWebResponse)request.GetResponse();

                Stream responseStream = response.GetResponseStream();
                StreamReader reader = new StreamReader(responseStream);
                string fileLines = reader.ReadToEnd();
                reader.Close();
                response.Close();

                return fileLines;
            }






        }
    }

}