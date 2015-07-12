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

using Microsoft.Build.Utilities;

namespace Zaibot.MSBuildTasks
{
    public class AssemblyVersionTask : Task
    {
        public string File { get; set; }
        public string Version { get; set; }
        public string FileVersion { get; set; }
        public string InfoVersion { get; set; }

        public override bool Execute()
        {
            const string format =
                "using System.Reflection;\r\n"
                + "[assembly: AssemblyVersion(\"{0}\")]\r\n"
                + "[assembly: AssemblyFileVersion(\"{1}\")]\r\n"
                + "[assembly: AssemblyInformationalVersion(\"{2}\")]\r\n";

            var assVersion = Version;
            var assFileVersion = FileVersion;
            var assInfoVersion = InfoVersion;

            System.IO.File.WriteAllText(this.File, string.Format(format, assVersion, assFileVersion, assInfoVersion));
            return true;
        }
    }
}