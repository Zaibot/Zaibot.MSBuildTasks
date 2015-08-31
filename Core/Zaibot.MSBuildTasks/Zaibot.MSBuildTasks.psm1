function Deploy-Solution-Folder($packageName, $packagePath, $solution, $solutionFolderName, $files) {
	Write-Host "Copying $packageName files to $solutionFolderName"
	$solutionDir     = Get-Solution-Dir $solution
	$targetPath      = Create-Solution-Directory $solution $solutionFolderName

	$files | ForEach { Copy-Tool-File $packagePath $targetPath $_ }
	Write-Host "Don't forget to commit the $solutionFolderName folder"
}

function Deploy-Solution-File($packageName, $packagePath, $solution, $solutionFolderName, $sourceName, $targetName) {
	Write-Host "Copying $packageName file to $solutionFolderName"
	$solutionDir     = Get-Solution-Dir $solution
	$targetPath      = Create-Solution-Directory $solution $solutionFolderName
	$targetFilePath  = (Join-Path $targetPath $targetName)

	Copy-Tool-File $packagePath $targetFilePath $sourceName
	Write-Host "Don't forget to commit the $solutionFolderName folder"
}

function Add-Solution-Folder($packageName, $packagePath, $solution, $solutionFolderName, $files) {
	Write-Host "Adding $packageName files to the solution"
	$solutionDir     = Get-Solution-Dir $solution
	$targetPath      = Create-Solution-Directory $solution $solutionFolderName
	$solutionFolder  = Create-Solution-Folder $solution $solutionFolderName
	$projectItems    = $solutionFolder.ProjectItems

	$files | ForEach { (Add-Tool-File $projectItems $targetPath $_) }
}

function Add-Solution-File($packageName, $packagePath, $solution, $solutionFolderName, $fileName) {
	Write-Host "Adding $packageName file to the solution"
	$solutionDir     = Get-Solution-Dir $solution
	$targetPath      = Join-Path $solutionDir $solutionFolderName
	$solutionFolder  = Create-Solution-Folder $solution $solutionFolderName
	$projectItems    = $solutionFolder.ProjectItems

	Add-Tool-File $projectItems $targetPath $fileName
}

# Utility Functions
function Create-Solution-Directory($solution, $folderName) {
	Write-Host "Create-Solution-Directory($solution, $folderName)"
	$solutionDir = Get-Solution-Dir $solution
	$targetPath = Join-Path $solutionDir $folderName

	Write-Host "`$solutionDir = $solutionDir"
	if(!(Test-Path $targetPath)) {
		mkdir $targetPath | Out-Null
	}

	Write-Host "Create-Solution-Directory = $targetPath"
	return $targetPath
}

function Create-Solution-Folder($solution, $folderName) {
	Write-Host "Create-Solution-Folder($solution, $folderName)"
    $folder = $solution.Projects | Where {$_.ProjectName -eq $folderName}
    if (!$folder) {
        $folder = $solution.AddSolutionFolder($folderName)
    }
	Write-Host "Create-Solution-Folder = $folder"
    return $folder
}

Function Copy-Tool-File($sourceFolder, $targetFolder, $filename) {
	Write-Host "Copy-Tool-File($sourceFolder, $targetFolder, $filename)"
	$filePath = Join-Path $sourceFolder $filename
	Write-Host "Copying $filePath to $targetFolder"
	Copy-Item $filePath $targetFolder -Force | Out-Null
}

Function Add-Tool-File($projectItems, $targetFolder, $filename) {
	Write-Host "Add-Tool-File"
	$exists = !!($projectItems | Where { $_.Name -eq $filename })
	if (!$exists) {
		$targetsPath = Join-Path $targetFolder $filename
		Write-Host "Adding $targetsPath"
		$projectItems.AddFromFile($targetsPath) | Out-Null
	} else {
		Write-Host "Skipping $targetsPath"
	}
}

function Get-Solution-Dir($solution) {
	Write-Host "Get-Solution-Dir"
    if ($solution -and $solution.IsOpen) {
		$pathProp = ($solution.Properties | Where { $_.Name -eq "Path" } | Select-Object -first 1)
		$pathVal = $pathProp.Value
		$asdasd = Split-Path $pathVal
		Write-Host "Get-Solution-Dir = $asdasd"
        return $asdasd
    } else {
        throw "Solution not available"
    }
}

function Get-Solution-Name($solution) {
	Write-Host "Get-Solution-Name"
    if($solution -and $solution.IsOpen) {
		$pathProp = ($solution.Properties | Where { $_.Name -eq "Name" } | Select-Object -first 1)
		$pathVal = $pathProp.Value
		Write-Host "Get-Solution-Dir = $pathVal"
        return $pathVal
    }
    else {
        throw "Solution not available"
    }
}

function Search-Import($imports, $name) {
	$imports | ?{ $_.Project -eq $name }
}
function Search-First-Import($imports, $name) {
	$imports | ?{ $_.Project -eq $name } | Select-Object -First 1
}
function Remove-Import($which) {
	$which | % { $_.Parent.RemoveChild($_) }
}

function Add-MSBuild-Import($msbuildProject, $path, $after) {
	Write-Host "Add-MSBuild-Import"
    $import = Search-Import $msbuildProject.Xml.Imports $path
	if ($import) {
		Remove-Import $import
	}
    $newImport = $msbuildProject.Xml.AddImport($path)
	if ($after) {
		$match = $after | %{ Search-First-Import $msbuildProject.Xml.Imports $_ } | ?{ !!$_ } | Select-Object -First 1
		if ($match) {
			$newImport.Parent.RemoveChild($newImport)
			$match.Parent.InsertAfterChild($newImport, $match)
		}
	}
    $buildProject.Save()
}

function Reload-Project($project) {
	$path = '?'
	If (Test-Path $project) { $path = $project }
	ElseIf ($project.FullName) { $path = $project.FullName }
	ElseIf ($project.FullPath) { $path = $project.FullPath }

	$(Get-Item $path).LastWriteTime = Get-Date
}

Export-ModuleMember Deploy-Solution-Folder, Deploy-Solution-File, Add-Solution-Folder, Add-Solution-File, Get-Solution-Dir, Get-Solution-Name, Create-Solution-Folder, Add-MSBuild-Import, Reload-Project
