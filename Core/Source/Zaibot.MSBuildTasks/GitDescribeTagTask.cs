using Microsoft.Build.Framework;

namespace Zaibot.MSBuildTasks
{
    public class GitDescribeTagTask : GitToolBase
    {
        [Output]
        public string Text { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return "describe --abbrev=0 --tags";
        }

        protected override void HandleOutput(string singleLine)
        {
            this.Text = singleLine.Trim();
        }
    }
}