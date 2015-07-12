using System.Text.RegularExpressions;
using Microsoft.Build.Framework;

namespace Zaibot.MSBuildTasks
{
    public class GitVersionTagTask : GitToolBase
    {
        [Output]
        public string Major { get; set; }

        [Output]
        public string Minor { get; set; }

        [Output]
        public string Revision { get; set; }

        [Output]
        public string Build { get; set; }

        [Output]
        public string Tag { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return "describe --always --tags";
        }

        protected override void HandleOutput(string singleLine)
        {
            var versionRegex = new Regex(@"v(?<major>\d+)\.(?<minor>\d+)(\.(?<revision>\d+)(\.(?<build>\d+))?)?", RegexOptions.Compiled | RegexOptions.Singleline);
            var m = versionRegex.Match(singleLine);
            if (m.Success)
            {
                this.Major = m.Groups["major"].Value;
                this.Minor = m.Groups["minor"].Value;
                this.Revision = m.Groups["revision"].Value;
                this.Build = m.Groups["build"].Value;
            }

            this.Tag = singleLine.Trim();
        }
    }
}