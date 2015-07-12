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

using Microsoft.Build.Framework;

namespace Zaibot.MSBuildTasks
{
    public class GitDescribeTask : GitToolBase
    {
        [Output]
        public string Text { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return "describe --tags";
        }

        protected override void HandleOutput(string singleLine)
        {
            this.Text = singleLine.Trim();
        }
    }
}