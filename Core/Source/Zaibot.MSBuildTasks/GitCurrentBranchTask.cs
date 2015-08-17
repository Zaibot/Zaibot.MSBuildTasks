using Microsoft.Build.Framework;

namespace Zaibot.MSBuildTasks
{
    public class GitCurrentBranchTask : GitToolBase
    {
        [Output]
        public string Text { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return "rev-parse --abbrev-ref HEAD";
        }

        protected override void HandleOutput(string singleLine)
        {
            this.Text = singleLine.Trim();
        }
    }
}