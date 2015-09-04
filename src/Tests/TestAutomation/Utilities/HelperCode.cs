using System;
using System.IO;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestAutomation.Utilities
{
    public static class FileIO
    {
        static string testOutputFileRelativePath = Path.Combine("Output", "TestOutput.txt");

        public static FileInfo OpenTestOutputFile()
        {
            string assemblyPath = Assembly.GetExecutingAssembly().CodeBase;
            string testOutputFilePath = Path.Combine(assemblyPath, testOutputFileRelativePath);

            return new FileInfo(testOutputFilePath);
        }
    }

}
