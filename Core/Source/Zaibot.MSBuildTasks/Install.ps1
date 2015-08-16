﻿param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")

function Get-SolutionName {
    if($dte.Solution -and $dte.Solution.IsOpen) {
        return $dte.Solution.Properties.Item("Name").Value
    }
    else {
        throw "Solution not avaliable"
    }
}

function Add-Solution-ProductVersionInclude() {
	$solutionDir = Get-SolutionDir
	$solutionName = Get-SolutionName

	$includesPath = (Join-Path $solutionDir "Includes")

	$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])
	$projectItems = $project.ProjectItems
	
	# Add files to includes folder.
	if(!(Test-Path $includesPath)) {
		mkdir $includesPath | Out-Null
	}
	$solProdFile = Join-Path $includesPath ("$solutionName"+"_Product.cs")
	if (!(Test-Path $solProdFile)) {
		Copy-Item (Join-Path $toolsPath "ProductName_Product.cs") $solProdFile -Force | Out-Null
		Write-Host ("Product information include copied, please fill out the information in Includes\" + $solutionName + "_Product.cs.")
	}
	$solVerFile = Join-Path $includesPath ("$solutionName"+"_Version.cs")
	if (!(Test-Path $solVerFile)) {
		Copy-Item (Join-Path $toolsPath "ProductName_Version.cs") $solVerFile -Force | Out-Null
		Write-Host "Version information include copied."
	}

	# Create the solution includes folder.
	$includesFolder = $solution.Projects | Where {$_.ProjectName -eq "Includes"}
	if (!$includesFolder) {
		$includesFolder = $solution.AddSolutionFolder("Includes")
	}
	$includesFolderProperties = $includesFolder.ProjectItems

	# Register includes with projects.
	$projectItems.Item('Properties').ProjectItems.AddFromFile($solProdFile)
	$includesFolderProperties.AddFromFile($solProdFile)

	$projectItems.Item('Properties').ProjectItems.AddFromFile($solVerFile)
	$includesFolderProperties.AddFromFile($solVerFile)

	# Open the files for editing.
	$project.ProjectItems.Item('Properties').ProjectItems.Item("AssemblyInfo.cs").Open().Activate()
	$includesFolderProperties.Item($solProdFile).Open()
	Open-AssemblyInfo-ForEdit($project)
}

function Open-AssemblyInfo-ForEdit($project) {
	$assemblyInfo = ($project.ProjectItems.Item('Properties').ProjectItems | Where { $_.Name -eq 'AssemblyInfo.cs' })
	if($assemblyInfo) {
		$assemblyInfo.Open()
		$assemblyInfo.Document.Activate()
		$assemblyInfo.Document.Selection.StartOfDocument()
		$assemblyInfo.Document.Selection.Insert("using System.Reflection;`r`n`r`n[assembly: AssemblyTitle(`"ProjectTitle`")]`r`n[assembly: AssemblyDescription(`"ProjectDescription`")]`r`n`r`n// Remove unnecessary code below and merge what is necessary, product and version information is defined in shared files.`r`n`r`n")
	} else {
		Write-Host "AssemblyInfo.cs not found -- open the AssemblyInfo file manually and remove product and version attributes."
	}
}


function Main 
{
	Add-Solution-ProductVersionInclude
}

Main