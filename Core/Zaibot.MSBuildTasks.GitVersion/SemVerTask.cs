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
                    return this.ExecuteSpec100();

                case "2.0.0":
                    return this.ExecuteSpec200();

                default:
                    throw new Exception("SemVer \"" + this.SemVerSpec + "\" is not supported. Use: \"1.0.0\" or \"2.0.0\".");
            }
        }

        private bool ExecuteSpec100()
        {
            var branch = this.GetBranchName();

            var shortTagRev = this.ChangedSinceTag == 0 ? "" : $"-rev{this.ChangedSinceTag:000}";
            var longTagRev = this.ChangedSinceTag == 0 ? "" : $" revision {this.ChangedSinceTag}";
            var shortTagCommit = this.ChangedSinceTag == 0 ? "" : $"-{this.Commit}";
            var longTagCommit = this.ChangedSinceTag == 0 ? "" : $" ({this.Commit})";
            var tagAnnotation = string.IsNullOrEmpty(this.Annotation) ? "" : $"-{this.Annotation}";
            var buildBranch = string.IsNullOrEmpty(branch) ? "" : $" {branch}";

            this.Short = $"{this.Major}.{this.Minor}";
            this.Long = $"{this.Major}.{this.Minor}.{this.Revision}.0";
            this.DescriptiveShort = $"{this.Major}.{this.Minor}.{this.Revision}{tagAnnotation}{shortTagRev}{shortTagCommit}";
            this.DescriptiveLong = $"{this.Major}.{this.Minor}.{this.Revision}{tagAnnotation}{buildBranch}{longTagRev}{longTagCommit}";

            return true;
        }

        private bool ExecuteSpec200()
        {
            var branch = this.GetBranchName();

            var shortTagRev = this.ChangedSinceTag == 0 ? "" : $".{this.ChangedSinceTag}";
            var longTagRev = this.ChangedSinceTag == 0 ? "" : $" revision {this.ChangedSinceTag}";
            var shortTagCommit = this.ChangedSinceTag == 0 ? "" : $"-c{this.Commit}";
            var longTagCommit = this.ChangedSinceTag == 0 ? "" : $" ({this.Commit})";
            var tagAnnotation = string.IsNullOrEmpty(this.Annotation) ? "" : $"-{this.Annotation}";
            var buildBranch = string.IsNullOrEmpty(branch) ? "" : $" {branch}";

            this.Short = $"{this.Major}.{this.Minor}";
            this.Long = $"{this.Major}.{this.Minor}.{this.Revision}.0";
            this.DescriptiveShort = $"{this.Major}.{this.Minor}.{this.Revision}{tagAnnotation}{shortTagRev}{shortTagCommit}";
            this.DescriptiveLong = $"{this.Major}.{this.Minor}.{this.Revision}{tagAnnotation}{buildBranch}{longTagRev}{longTagCommit}";

            return true;
        }

        private string GetBranchName()
        {
            var branch = this.Branch;
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