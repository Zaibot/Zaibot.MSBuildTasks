param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")
Import-Module (Join-Path $toolsPath "Zaibot.MSBuildTasks.psm1")

$buildFolderName = ".build"
$buildFiles = @()
$buildFiles += "Zaibot.MSBuildTasks.GitVersion.dll";
#$buildFiles += "Zaibot.MSBuildTasks.GitVersion.pdb";
$buildFiles += "Zaibot.MSBuildTasks.GitVersion.targets";
$buildFiles += "Zaibot.MSBuildTasks.GitVersion.Readme.txt";

$includesFolderName = "Includes"
$includeFiles = @()
$includeFiles += "Zaibot.MSBuildTasks.GitVersion.props"

function Main 
{
	$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])
	$productName = Get-Solution-Name $solution

	Deploy-Solution-Folder "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $buildFolderName $buildFiles
	Add-Solution-Folder"Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $buildFolderName $buildFiles

	Deploy-Solution-Folder "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName $includeFiles
	Add-Solution-Folder"Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName $includeFiles
	
	Deploy-Solution-Folder "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName "ProductName_Product.cs" ("$productName" + "_Product.cs")
	Add-Solution-Folder"Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName ("$productName" + "_Product.cs")

	Deploy-Solution-File "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName "ProductName_Version.cs" ("$productName" + "_Version.cs")
	Add-Solution-File"Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName ("$productName" + "_Version.cs")

	Add-Import("`$(SolutionDir)$buildFolderName\Zaibot.MSBuildTasks.GitVersion.targets")
}

Main