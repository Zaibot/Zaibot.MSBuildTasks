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

function Add-Default-NuSpec() {
	$projectDir = Split-Path $project.FileName;
	$projectName = $project.Properties.Item('AssemblyName').Value
	$projectItems = $project.ProjectItems

	$nuspecSourceFile = Join-Path $toolsPath "Example.nuspec.txt"
	$nuspecFileName = "$projectName" + ".nuspec"
	$nuspecFile = Join-Path $projectDir $nuspecFileName

	if (!(Test-Path $nuspecFile)) {
		Copy-Item $nuspecSourceFile $nuspecFile -Force 
		Write-Host ("Copied nuspec template, set the build action to ZaibotNuGetPack.")
	}

	# Add default nuget to project.
	$file = Add-ProjectItemFromFile $project.ProjectItems $nuspecFile
	$file.Open() | Out-Null
	$file.Document.Activate()
	$file.Document.ReplaceText("`$projectName`$", "$projectName") | Out-Null
}

function Main 
{
	$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])

	Deploy-Solution-Folder "Zaibot.MSBuildTasks.NuGet" $toolsPath $solution $buildFolderName $buildFiles
	Add-Solution-Folder "Zaibot.MSBuildTasks.NuGet" $toolsPath $solution $buildFolderName $buildFiles

	Deploy-Solution-Folder "Zaibot.MSBuildTasks.NuGet" $toolsPath $solution $includesFolderName $includeFiles
	Add-Solution-Folder "Zaibot.MSBuildTasks.NuGet" $toolsPath $solution $includesFolderName $includeFiles

	$buildProject = Get-MSBuildProject $project.Name
	Add-MSBuild-Import $buildProject "`$(SolutionDir)\.build\Zaibot.MSBuildTasks.NuGet.targets"
	Add-Default-NuSpec
	Reload-Project $project
}

Main