param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")

function Add-Default-NuSpec() {
	$projectDir = Split-Path $project.FileName;
	$projectName = $project.Properties.Item('AssemblyName').Value
	$projectItems = $project.ProjectItems

	$nuspecSourceFile = Join-Path $toolsPath "Example.nuspec"
	$nuspecFileName = "$projectName" + ".nuspec"
	$nuspecFile = Join-Path $projectDir $nuspecFileName

	if (!(Test-Path $nuspecFile)) {
		Copy-Item $nuspecSourceFile $nuspecFile -Force | Out-Null
		Write-Host ("Copied nuspec template, set the build action to ZaibotNuGetPack.")
	}

	# Add default nuget to project.
	$file = $project.ProjectItems.AddFromFile($nuspecFile).Open()
	$file.Document.Activate()
	$file.Document.ReplaceText("`$projectName`$", "$projectName")
}

function Main 
{
	Add-Default-NuSpec
}

Main