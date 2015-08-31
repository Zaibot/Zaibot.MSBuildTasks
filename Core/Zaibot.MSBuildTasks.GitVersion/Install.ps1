param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")
Import-Module (Join-Path $toolsPath "Zaibot.MSBuildTasks.psm1")

function Add-Solution-ProductVersionInclude($solution, $project, $solProdFile, $solVerFile) {
	# Open product include.
	(Create-Solution-Folder $solution "Includes").Item($solProdFile).Open().Activate() | Out-Null

	# Register includes with projects.
	$propertiesFolder = $project.ProjectItems.Item('Properties');
	$propertiesFolder.ProjectItems.AddFromFile($solProdFile) | Out-Null
	$propertiesFolder.ProjectItems.AddFromFile($solVerFile) | Out-Null

	$assemblyInfo = $propertiesFolder.Item("AssemblyInfo.cs").Open()
	Open-AssemblyInfo-ForEdit($assemblyInfo)
}

function Open-AssemblyInfo-ForEdit($assemblyInfo) {
	if ($assemblyInfo) {
		$assemblyInfo.Open() | Out-Null
		if ($assemblyInfo.Document.MarkText("AssemblyVersion") -or $assemblyInfo.Document.MarkText("AssemblyCompany") -or $assemblyInfo.Document.MarkText("AssemblyProduct")) {
			$assemblyInfo.Document.Activate() | Out-Null
			$assemblyInfo.Document.Selection.StartOfDocument() | Out-Null
			$assemblyInfo.Document.Selection.Insert("using System.Reflection;`r`n`r`n[assembly: AssemblyTitle(`"ProjectTitle`")]`r`n[assembly: AssemblyDescription(`"ProjectDescription`")]`r`n`r`n// Remove unnecessary code below and merge what is necessary, product and version information is defined in shared files.`r`n`r`n") | Out-Null
		} else {
			$assemblyInfo.Document.Close(0) | Out-Null
		}
	} else {
		Write-Host "AssemblyInfo.cs not found -- open the AssemblyInfo file manually and remove product and version attributes."
	}
}

function Main 
{
	$solution = $dte.Solution
	$solutionName = Get-Solution-Name $solution
	$solutionDir = Get-Solution-Dir $solution
	$buildProject = Get-MSBuildProject $project.Name
    Add-MSBuild-Import $buildProject "`$(SolutionDir)\.build\Zaibot.MSBuildTasks.GitVersion.targets"
    
	$solProdFile = Join-Path $solutionDir ("Includes\$solutionName" + "_Product.cs")
	$solVerFile = Join-Path $solutionDir ("Includes\$solutionName" + "_Version.cs")

	Add-Solution-ProductVersionInclude $solution $project $solProdFile $solVerFile
	Reload-Project $buildProject
}

Main