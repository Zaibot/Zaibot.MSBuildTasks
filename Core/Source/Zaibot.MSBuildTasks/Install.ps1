param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")

function Get-SolutionName {
    if($dte.Solution -and $dte.Solution.IsOpen) {
        return Split-Path $dte.Solution.Properties.Item("Name").Value
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
	if (!(Test-Path(Join-Path $includesFolder "$solutionName_Product.cs"))) {
		Copy-Item "$toolsPath\ProductName_Product.cs" (Join-Path $includesPath "$solutionName_Product.cs") -Force | Out-Null
		Write-Host "Product information include copied, please fill out the information in Includes\$solutionName_Product.cs."
	}
	if (!(Test-Path(Join-Path $includesFolder "$solutionName_Version.cs"))) {
		Copy-Item "$toolsPath\ProductName_Version.cs" (Join-Path $includesPath "$solutionName_Version.cs") -Force | Out-Null
		Write-Host "Version information include copied."
	}

	# Create the solution includes folder.
	$includesFolder = $solution.Projects | Where {$_.ProjectName -eq "Includes"}
	if (!$includesFolder) {
		$includesFolder = $solution.AddSolutionFolder("Includes")
	}

	# Register includes with projects.
	$dllPath = [IO.Path]::GetFullPath( (Join-Path $includesPath "$solutionName_Product.cs") )
	$projectItems.Item('Properties').ProjectItems.AddFromFile($dllPath)

	$dllPath = [IO.Path]::GetFullPath( (Join-Path $includesPath "$solutionName_Version.cs") )
	$projectItems.Item('Properties').ProjectItems.AddFromFile($dllPath)
}


function Main 
{
	Add-Solution-ProductVersionInclude
}

Main