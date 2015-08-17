// ----------------------------------------
// 
//   MSBuildTasks
//   Copyright (c) 2015 Zaibot Programs
//   
//   Creation: 2015-08-16
//     Author: Tobias de Groen
//   Location: Arnhem, The Netherlands
// 
//    Website: www.zaibot.net
//    Contact: admin@zaibot.net
//             +31 (6) 3388 3156
// 
// ----------------------------------------

using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Zaibot.MSBuildTasks
{
    public class GenerateVersionTextTask : Task
    {
        public string Major { get; set; }
        public string Minor { get; set; }
        public string Revision { get; set; }
        public string Branch { get; set; }
        public string Build { get; set; }
        public string Commit { get; set; }
        public string Annotation { get; set; }
        public int ChangedSinceTag { get; set; }

        [Output]
        public string Short { get; set; }

        [Output]
        public string Long { get; set; }

        [Output]
        public string DescriptiveShort { get; set; }

        [Output]
        public string DescriptiveLong { get; set; }

        public override bool Execute()
        {
            var changesCommit = ChangedSinceTag == 0 ? "" : $"-{Commit}";
            var annotation = string.IsNullOrEmpty(Annotation) ? "" : $"-{Annotation}";
            var versionBranch = string.IsNullOrEmpty(Branch) ? "" : $" {Branch}";

            Short = $"{Major}.{Minor}";
            Long = $"{Major}.{Minor}";
            Long = $"{Major}.{Minor}.{Revision}.{ChangedSinceTag}";
            DescriptiveShort = $"{Long}{annotation}{changesCommit}";
            DescriptiveLong = $"{Long}{annotation}{changesCommit}{versionBranch}";

            return true;
        }
    }
}