param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")
Import-Module (Join-Path $toolsPath "Zaibot.MSBuildTasks.psm1")

$buildFolderName = ".build"
$buildFiles = @()
$buildFiles += "Zaibot.MSBuildTasks.dll";
$buildFiles += "Zaibot.MSBuildTasks.pdb";
$buildFiles += "Zaibot.MSBuildTasks.targets";
$buildFiles += "Zaibot.MSBuildTasks.Readme.txt";

$includesFolderName = "Includes"
$includeFiles = @()
$includeFiles += "Zaibot.MSBuildTasks.props";

function Main 
{
	Deploy-Solution-Folder("Zaibot.MSBuildTasks", $toolsPath, $solution, $buildFolderName, $buildFiles)
	Add-Solution-Folder("Zaibot.MSBuildTasks", $toolsPath, $solution, $buildFolderName, $buildFiles)

	Deploy-Solution-Folder("Zaibot.MSBuildTasks", $toolsPath, $solution, $includesFolderName, $includeFiles)
	Add-Solution-Folder("Zaibot.MSBuildTasks", $toolsPath, $solution, $includesFolderName, $includeFiles)
}

Main