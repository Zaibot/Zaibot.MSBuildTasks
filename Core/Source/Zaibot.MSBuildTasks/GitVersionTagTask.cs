// ----------------------------------------
// 
//   Core
//   Copyright (c) 2015 Zaibot Programs
//   
//   Creation: 2015-07-12
//     Author: Tobias de Groen
//   Location: Arnhem, The Netherlands
// 
//    Website: www.zaibot.net
//    Contact: admin@zaibot.net
//             +31 (6) 3388 3156
// 
// ----------------------------------------

using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Zaibot.MSBuildTasks
{
    public class VersionTextTask : Task
    {
        public string Major { get; set; }
        public string Minor { get; set; }
        public string Revision { get; set; }
        public string Build { get; set; }
        public string Commit { get; set; }
        public string Annotation { get; set; }
        public string ChangedSinceTag { get; set; }

        [Output]
        public string Short { get; set; }
        [Output]
        public string Long { get; set; }
        [Output]
        public string Descriptive { get; set; }

        public override bool Execute()
        {
            Short = Major + "." + Minor;
            Long = Major + "." + Minor;
            Long = Major + "." + Minor + "." + Revision + "." + Build;

            var numbers = new List<string>() { Major, Minor, Revision, Build };

            Descriptive = string.Join(".", numbers) 
                + (string.IsNullOrEmpty(Annotation) ? "" : "-" + Annotation)
                + (ChangedSinceTag =="False" ? "" : string.Format(".{0}", this.Commit));

            return true;
        }
    }

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

        [Output]
        public string Annotation { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return "describe --always --tags";
        }

        protected override void HandleOutput(string singleLine)
        {
            var versionRegex = new Regex(@"v(?<major>\d+)\.(?<minor>\d+)(\.(?<revision>\d+)(\.(?<build>\d+))?)?(\-(?<annotation>.*$))?", RegexOptions.Compiled | RegexOptions.Singleline);
            var m = versionRegex.Match(singleLine);
            if (m.Success)
            {
                this.Major = m.Groups["major"].Value;
                this.Minor = m.Groups["minor"].Value;
                this.Revision = m.Groups["revision"].Value;
                this.Build = m.Groups["build"].Value;
                this.Annotation = m.Groups["annotation"].Value;
            }

            this.Tag = singleLine.Trim();
        }
    }
}