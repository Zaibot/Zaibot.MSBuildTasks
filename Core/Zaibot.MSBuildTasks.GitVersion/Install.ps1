param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")
Import-Module (Join-Path $toolsPath "Zaibot.MSBuildTasks.psm1")

function Create-Solution-Includes-Folder($solution) {
	$includesFolder = $solution.Projects | Where {$_.ProjectName -eq "Includes"}
	if (!$includesFolder) {
		$includesFolder = $solution.AddSolutionFolder("Includes")
	}
	return $includesFolder
}

function Add-Solution-ProductVersionInclude($solution, $project, $solProdFile, $solVerFile) {
	# Open product include.
	(Create-Solution-Folder $solution "Includes").Item($solProdFile).Open().Activate() 

	# Register includes with projects.
	$propertiesFolder = $project.ProjectItems.Item('Properties');
	$propertiesFolder.ProjectItems.AddFromFile($solProdFile) 
	$propertiesFolder.ProjectItems.AddFromFile($solVerFile) 

	$assemblyInfo = $propertiesFolder.Item("AssemblyInfo.cs").Open()
	Open-AssemblyInfo-ForEdit($assemblyInfo)
}

function Open-AssemblyInfo-ForEdit($assemblyInfo) {
	if ($assemblyInfo) {
		$assemblyInfo.Open() 
		if ($assemblyInfo.Document.MarkText("AssemblyVersion") -or $assemblyInfo.Document.MarkText("AssemblyCompany") -or $assemblyInfo.Document.MarkText("AssemblyProduct")) {
			$assemblyInfo.Document.Activate() 
			$assemblyInfo.Document.Selection.StartOfDocument() 
			$assemblyInfo.Document.Selection.Insert("using System.Reflection;`r`n`r`n[assembly: AssemblyTitle(`"ProjectTitle`")]`r`n[assembly: AssemblyDescription(`"ProjectDescription`")]`r`n`r`n// Remove unnecessary code below and merge what is necessary, product and version information is defined in shared files.`r`n`r`n") 
		} else {
			$assemblyInfo.Document.Close(0) 
		}
	} else {
		Write-Host "AssemblyInfo.cs not found -- open the AssemblyInfo file manually and remove product and version attributes."
	}
}

Function Add-Version-Include-To-All-Projects($solution) {
	# For each CSharp project add the version include.
	$projects = $solution.Projects | Where { $_.Type -eq 'C#' }
	$projects | ForEach { Add-Version-Include-To-Project($_) }

	$includesFolderProperties.Item($solProdFile).Open().Activate()
}

function Add-Solution-Project-Properties-Item($project, $path) {
	$project.ProjectItems.Item('Properties').ProjectItems.AddFromFile($path)
	$includesFolderProperties.AddFromFile($path)
}

function Add-Version-Include-To-Project($project) {
	$buildProject = Get-MSBuildProject $project.Name
	
	Add-MSBuild-Import($buildProject, "`$(SolutionDir)\.build\Zaibot.MSBuildTasks.GitVersion.targets")
	Add-Solution-Project-Properties-Item($project, $solProdFile)
	Add-Solution-Project-Properties-Item($project, $solVerFile)
	Open-AssemblyInfo-ForEdit($project)

	$project.Save() 
}


function Main 
{
	$solution = $dte.Solution
	$solutionName = Get-Solution-Name $solution
	$solutionDir = Get-Solution-Dir $solution
	$buildProject = Get-MSBuildProject $project.Name
    Add-MSBuild-Import($buildProject, "`$(SolutionDir)\.build\Zaibot.MSBuildTasks.GitVersion.targets")
    
	$solProdFile = Join-Path $solutionDir ("Includes\$solutionName" + "_Product.cs")
	$solVerFile = Join-Path $solutionDir ("Includes\$solutionName" + "_Version.cs")

	Add-Solution-ProductVersionInclude $solution $project $solProdFile $solVerFile
}

Main