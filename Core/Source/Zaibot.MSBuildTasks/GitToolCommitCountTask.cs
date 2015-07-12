using Microsoft.Build.Framework;

namespace Zaibot.MSBuildTasks
{
    public class GitToolCommitCountTask : GitToolBase
    {
        public string Since { get; set; }

        [Output]
        public string Count { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return string.Format("rev-list --count {0}..HEAD", this.Since);
        }

        protected override void HandleOutput(string singleLine)
        {
            var count = singleLine.Trim();
            int i;
            int.TryParse(count, out i);
            this.Count = i.ToString();
        }
    }
}