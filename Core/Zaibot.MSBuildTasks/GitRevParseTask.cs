// ----------------------------------------
// 
//   MSBuildTasks
//   Copyright (c) 2015 Zaibot Programs
//   
//   Creation: 2015-08-30
//     Author: Tobias de Groen
//   Location: Arnhem, The Netherlands
// 
//    Website: www.zaibot.net
//    Contact: admin@zaibot.net
//             +31 (6) 3388 3156
// 
// ----------------------------------------

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
            return "rev-parse --short " + this.What;
        }

        protected override void HandleOutput(string singleLine)
        {
            this.Revision = singleLine.Trim();
        }
    }
}