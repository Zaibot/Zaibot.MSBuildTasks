param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")

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
	$file = $project.ProjectItems.AddFromFile($nuspecFile).Open()
	$file.Document.Activate()
	$file.Document.ReplaceText("`$projectName`$", "$projectName")
}

function Main 
{
	$buildProject = Get-MSBuildProject $project.Name
    Add-MSBuild-Import($buildProject, "`$(SolutionDir)\.build\Zaibot.MSBuildTasks.NuGet.targets")
	Add-Default-NuSpec
	Reload-Project $project
}

Main