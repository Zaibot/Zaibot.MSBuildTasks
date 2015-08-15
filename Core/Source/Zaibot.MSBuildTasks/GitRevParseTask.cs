using Microsoft.Build.Framework;

namespace Zaibot.MSBuildTasks
{
    public class GitRevParseTask : GitToolBase
    {
        public string What { get; set; }

        [Output]
        public string Revision { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return "rev-parse --short " + What;
        }

        protected override void HandleOutput(string singleLine)
        {
            this.Revision = singleLine.Trim();
        }
    }
}