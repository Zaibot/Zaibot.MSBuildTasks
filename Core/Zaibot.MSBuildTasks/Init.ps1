param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")
Import-Module (Join-Path $toolsPath "Zaibot.MSBuildTasks.psm1")

$buildFolderName = ".build"
$buildFiles = @()
$buildFiles += "Zaibot.MSBuildTasks.dll";
#$buildFiles += "Zaibot.MSBuildTasks.pdb";
$buildFiles += "Zaibot.MSBuildTasks.targets";
$buildFiles += "Zaibot.MSBuildTasks.Readme.txt";

$includesFolderName = "Includes"
$includeFiles = @()
$includeFiles += "Zaibot.MSBuildTasks.props";

function Main 
{
	$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])

	Deploy-Solution-Folder "Zaibot.MSBuildTasks" $toolsPath $solution $buildFolderName $buildFiles
	Add-Solution-Folder "Zaibot.MSBuildTasks" $toolsPath $solution $buildFolderName $buildFiles

	Deploy-Solution-Folder "Zaibot.MSBuildTasks" $toolsPath $solution $includesFolderName $includeFiles
	Add-Solution-Folder "Zaibot.MSBuildTasks" $toolsPath $solution $includesFolderName $includeFiles
	
	$buildProject = Get-MSBuildProject $project.Name
	Add-MSBuild-Import $buildProject "`$(SolutionDir)$buildFolderName\Zaibot.MSBuildTasks.targets"
}

Main