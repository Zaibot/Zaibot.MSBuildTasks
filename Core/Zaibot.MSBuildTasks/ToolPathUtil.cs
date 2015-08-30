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
using System.Security;
using Microsoft.Win32;

namespace Zaibot.MSBuildTasks
{
    internal static class ToolPathUtil
    {
        public static bool SafeFileExists(string path, string toolName)
        {
            return SafeFileExists(Path.Combine(path, toolName));
        }

        public static bool SafeFileExists(string file)
        {
            try
            {
                return File.Exists(file);
            }
            catch
            {
            } // eat exception

            return false;
        }

        public static string MakeToolName(string name)
        {
            return (Environment.OSVersion.Platform == PlatformID.Unix)
                ? name
                : name + ".exe";
        }

        public static string FindInRegistry(string toolName)
        {
            try
            {
                var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" + toolName, false);
                if (key != null)
                {
                    var possiblePath = key.GetValue(null) as string;
                    if (SafeFileExists(possiblePath))
                        return Path.GetDirectoryName(possiblePath);
                }
            }
            catch (SecurityException)
            {
            }

            return null;
        }

        public static string FindInPath(string toolName)
        {
            var pathEnvironmentVariable = Environment.GetEnvironmentVariable("PATH") ?? string.Empty;
            var paths = pathEnvironmentVariable.Split(new[] {Path.PathSeparator}, StringSplitOptions.RemoveEmptyEntries);
            foreach (var path in paths)
            {
                if (SafeFileExists(path, toolName))
                {
                    return path;
                }
            }

            return null;
        }

        public static string FindInProgramFiles(string toolName, params string[] commonLocations)
        {
            foreach (var location in commonLocations)
            {
                var path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), location);
                if (SafeFileExists(path, toolName))
                {
                    return path;
                }
            }

            return null;
        }

        public static string FindInLocalPath(string toolName, string localPath)
        {
            if (localPath == null)
                return null;

            var path = new DirectoryInfo(localPath).FullName;
            if (SafeFileExists(localPath, toolName))
            {
                return path;
            }

            return null;
        }
    }
}