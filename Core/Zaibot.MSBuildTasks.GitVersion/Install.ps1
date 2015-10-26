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


function Add-Solution-ProductVersionInclude($solution, $project, $solProdFile, $solVerFile) {
	# Open product include.
	$solIncludes = Create-Solution-Folder $solution "Includes"
	$solIncludes.ProjectItems.Item($solProdFile).Open().Activate() | Out-Null

	# Register includes with projects.
	$propertiesItems = $project.ProjectItems.Item('Properties').ProjectItems;
	
	Add-ProjectItemFromFile $propertiesItems $solProdFile | Out-Null
	Add-ProjectItemFromFile $propertiesItems $solVerFile | Out-Null

	$assemblyVersionFile = $propertiesItems.Item("AssemblyInfo.cs")
	if ($assemblyVersionFile) { 
		Open-AssemblyInfo-ForEdit($assemblyVersionFile)
	}
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
	$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])
	$productName = Get-Solution-Name $solution
	$fileProduct = "$productName" + "_Product.cs"
	$fileVersion = "$productName" + "_Version.cs"

	Deploy-Solution-Folder "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $buildFolderName $buildFiles
	Add-Solution-Folder "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $buildFolderName $buildFiles

	Deploy-Solution-Folder "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName $includeFiles
	Add-Solution-Folder "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName $includeFiles
	
	Deploy-Solution-File "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName "ProductName_Product.cs" $fileProduct
	Add-Solution-File "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName $fileProduct

	Deploy-Solution-File "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName "ProductName_Version.cs" $fileVersion
	Add-Solution-File "Zaibot.MSBuildTasks.GitVersion" $toolsPath $solution $includesFolderName $fileVersion
	
	Get-Project | %{ Add-MSBuild-Import $(Get-MSBuildProject $_.Name) "`$(SolutionDir)$buildFolderName\Zaibot.MSBuildTasks.GitVersion.targets" } | Out-Null

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