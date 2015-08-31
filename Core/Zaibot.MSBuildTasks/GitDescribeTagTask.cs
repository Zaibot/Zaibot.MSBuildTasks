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
    public class GitDescribeTagTask : GitToolBase
    {
        [Output]
        public string Text { get; set; }

        protected override string GenerateCommandLineCommands()
        {
            return "describe --match \"*v[0-9]*\" --abbrev=0 --tags";
        }

        protected override void HandleOutput(string singleLine)
        {
            this.Text = singleLine.Trim();
        }
    }
}