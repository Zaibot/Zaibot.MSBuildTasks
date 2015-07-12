using Microsoft.Build.Framework;

namespace Zaibot.MSBuildTasks
{
    public class GitShortRevTask : GitToolBase
    {
        protected override string ToolName
        {
            get { return "git.exe"; }
        }

        [Output]
        public string Revision { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return "rev-parse --short HEAD";
        }

        protected override void HandleOutput(string singleLine)
        {
            this.Revision = singleLine.Trim();
        }
    }
}