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

using System;
using System.IO;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace Zaibot.MSBuildTasks
{
    public abstract class GitToolBase : ToolTask
    {
        protected override string ToolName
        {
            get { return ToolPathUtil.MakeToolName("git"); }
        }

        private string FindToolPath(string toolName)
        {
            var toolPath =
                ToolPathUtil.FindInRegistry(toolName) ??
                ToolPathUtil.FindInPath(toolName) ??
                ToolPathUtil.FindInProgramFiles(toolName, @"Git\bin") ??
                ToolPathUtil.FindInLocalPath(toolName, this.LocalPath);

            if (toolPath == null)
            {
                throw new Exception("Could not find git.exe. Looked in PATH locations and various common folders inside Program Files as well as LocalPath.");
            }

            return toolPath;
        }

        public string LocalPath { get; set; }

        protected override string GenerateFullPathToTool()
        {
            this.ToolPath = this.FindToolPath(this.ToolName);
            return Path.Combine(this.ToolPath, this.ToolName);
        }

        protected override string GetWorkingDirectory()
        {
            if (string.IsNullOrEmpty(this.LocalPath))
                return base.GetWorkingDirectory();

            return this.LocalPath;
        }

        protected override void LogEventsFromTextOutput(string singleLine, MessageImportance messageImportance)
        {
            var flag = messageImportance == this.StandardErrorLoggingImportance;
            if (flag)
            {
                base.LogEventsFromTextOutput(singleLine, messageImportance);
                return;
            }

            this.HandleOutput(singleLine);
        }

        protected abstract void HandleOutput(string singleLine);
    }
}