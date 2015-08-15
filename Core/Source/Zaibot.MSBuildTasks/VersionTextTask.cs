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
using System.Globalization;
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
        public int ChangedSinceTag { get; set; }

        [Output]
        public string Short { get; set; }

        [Output]
        public string Long { get; set; }

        [Output]
        public string Descriptive { get; set; }

        public override bool Execute()
        {
            this.Short = this.Major + "." + this.Minor;
            this.Long = this.Major + "." + this.Minor;
            this.Long = this.Major + "." + this.Minor + "." + this.Revision + "." + ChangedSinceTag;//this.Build;

            var numbers = new List<string> {this.Major, this.Minor, this.Revision, this.ChangedSinceTag.ToString(CultureInfo.InvariantCulture) };

            this.Descriptive = string.Join(".", numbers)
                               + (string.IsNullOrEmpty(this.Annotation) ? "" : "-" + this.Annotation)
                               + (this.ChangedSinceTag == 0 ? "" : string.Format("-{0}", this.Commit));

            return true;
        }
    }
}