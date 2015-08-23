param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")
Import-Module (Join-Path $toolsPath "Zaibot.MSBuildTasks.psm1")

$buildFolderName = ".build"
$buildFiles = @()
$buildFiles += "Zaibot.MSBuildTasks.NuGet.targets";
$buildFiles += "Zaibot.MSBuildTasks.NuGet.Readme.txt";

$includesFolderName = "Includes"
$includeFiles = @()
$includeFiles += "Zaibot.MSBuildTasks.NuGet.props"

function Main 
{
	Deploy-Solution-Folder("Zaibot.MSBuildTasks.NuGet", $toolsPath, $solution, $buildFolderName, $buildFiles)
	Add-Solution-Folder("Zaibot.MSBuildTasks.NuGet", $toolsPath, $solution, $buildFolderName, $buildFiles)

	Deploy-Solution-Folder("Zaibot.MSBuildTasks.NuGet", $toolsPath, $solution, $includesFolderName, $includeFiles)
	Add-Solution-Folder("Zaibot.MSBuildTasks.NuGet", $toolsPath, $solution, $includesFolderName, $includeFiles)
}

Main