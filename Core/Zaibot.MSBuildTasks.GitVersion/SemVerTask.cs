// ----------------------------------------
// 
//   MSBuildTasks
//   Copyright (c) 2015 Zaibot Programs
//   
//   Creation: 2015-08-19
//     Author: Tobias de Groen
//   Location: Arnhem, The Netherlands
// 
//    Website: www.zaibot.net
//    Contact: admin@zaibot.net
//             +31 (6) 3388 3156
// 
// ----------------------------------------

using System;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Zaibot.MSBuildTasks
{
    public class SemVerTask : Task
    {
        public string SemVerSpec { get; set; }
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
            switch (this.SemVerSpec)
            {
                case null:
                case "1.0.0":
                    return ExecuteSpec100();

                case "2.0.0":
                    return ExecuteSpec200();

                default:
                    throw new Exception("SemVer \"" + SemVerSpec + "\" is not supported. Use: \"1.0.0\" or \"2.0.0\".");
            }
        }

        private bool ExecuteSpec100()
        {
            var branch = GetBranchName();

            var shortTagRev = ChangedSinceTag == 0 ? "" : $"-rev{ChangedSinceTag:000}";
            var longTagRev = ChangedSinceTag == 0 ? "" : $" revision {ChangedSinceTag}";
            var shortTagCommit = ChangedSinceTag == 0 ? "" : $"-{Commit}";
            var longTagCommit = ChangedSinceTag == 0 ? "" : $" ({Commit})";
            var tagAnnotation = string.IsNullOrEmpty(Annotation) ? "" : $"-{Annotation}";
            var buildBranch = string.IsNullOrEmpty(branch) ? "" : $" {branch}";

            Short = $"{Major}.{Minor}";
            Long = $"{Major}.{Minor}.{Revision}.0";
            DescriptiveShort = $"{Major}.{Minor}.{Revision}{tagAnnotation}{shortTagRev}{shortTagCommit}";
            DescriptiveLong = $"{Major}.{Minor}.{Revision}{tagAnnotation}{buildBranch}{longTagRev}{longTagCommit}";

            return true;
        }

        private bool ExecuteSpec200()
        {
            var branch = GetBranchName();

            var shortTagRev = ChangedSinceTag == 0 ? "" : $".{ChangedSinceTag}";
            var longTagRev = ChangedSinceTag == 0 ? "" : $" revision {ChangedSinceTag}";
            var shortTagCommit = ChangedSinceTag == 0 ? "" : $"-c{Commit}";
            var longTagCommit = ChangedSinceTag == 0 ? "" : $" ({Commit})";
            var tagAnnotation = string.IsNullOrEmpty(Annotation) ? "" : $"-{Annotation}";
            var buildBranch = string.IsNullOrEmpty(branch) ? "" : $" {branch}";

            Short = $"{Major}.{Minor}";
            Long = $"{Major}.{Minor}.{Revision}.0";
            DescriptiveShort = $"{Major}.{Minor}.{Revision}{tagAnnotation}{shortTagRev}{shortTagCommit}";
            DescriptiveLong = $"{Major}.{Minor}.{Revision}{tagAnnotation}{buildBranch}{longTagRev}{longTagCommit}";

            return true;
        }

        private string GetBranchName()
        {
            var branch = Branch;
            switch (branch)
            {
                case "master":
                    return null;

                default:
                    return branch;
            }
        }
    }
}