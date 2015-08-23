function Deploy-Solution-Folder($packageName, $packagePath, $solution, $solutionFolderName, $files) {
	Write-Host "Copying $packageName files to $targetPath"
	$solutionDir     = Get-Solution-Dir $solution
	$targetPath      = Create-Solution-Directory $solutionDir $solutionFolderName

	$files | ForEach { (Copy-Tool-File $packagePath $targetPath $_) } | Out-Null
	Write-Host "Don't forget to commit the $solutionFolderName folder"
}

function Deploy-Solution-File($packageName, $packagePath, $solution, $solutionFolderName, $sourceName, $targetName) {
	Write-Host "Copying $packageName file to $targetPath"
	$solutionDir     = Get-Solution-Dir $solution
	$targetPath      = Create-Solution-Directory $solutionDir $solutionFolderName
	$targetFilePath  = Join-Path $targetPath $targetName

	Copy-Tool-File $packagePath $targetFilePath $sourceName | Out-Null
	Write-Host "Don't forget to commit the $solutionFolderName folder"
}

function Add-Solution-Folder($packageName, $packagePath, $solution, $solutionFolderName, $files) {
	Write-Host "Adding $packageName files to the solution"
	$solutionDir     = Get-Solution-Dir $solution
	$targetPath      = Create-Solution-Directory $solutionDir $solutionFolderName
	$solutionFolder  = Create-Solution-Folder $solution $solutionFolderName
	$projectItems    = Get-Interface $buildFolder.ProjectItems ([EnvDTE.ProjectItems])

	$packageFiles | ForEach { (Add-Tool-File $projectItems $targetPath $_) } | Out-Null
}
function Add-Solution-File($packageName, $packagePath, $solution, $solutionFolderName, $fileName) {
	Write-Host "Adding $packageName file to the solution"
	$solutionDir     = Get-Solution-Dir $solution
	$targetPath      = (Join-Path $solutionDir $solutionFolderName)
	$solutionFolder  = Create-Solution-Folder $solution $solutionFolderName
	$projectItems    = Get-Interface $solutionFolder.ProjectItems ([EnvDTE.ProjectItems])

	Add-Tool-File $projectItems $targetPath $fileName
}

# Utility Functions
function Create-Solution-Directory($solution, $folderName) {
	$solutionDir = (Split-Path $solution.Properties.Item("Path").Value)
	$targetPath = (Join-Path $solutionDir $folderName)

	if(!(Test-Path $targetPath)) {
		mkdir $targetPath | Out-Null
	}

	return $targetPath
}

function Create-Solution-Folder($solution, $folderName) {
    $folder = $solution.Projects | Where {$_.ProjectName -eq $folderName}
    if (!$folder) {
        $folder = $solution.AddSolutionFolder($folderName)
    }
    return $folderName
}

Function Copy-Tool-File($sourceFolder, $targetFolder, $filename) {
	$filePath =  [IO.Path]::GetFullPath((Join-Path $toolsPath $filename))
	Copy-Item $filePath $targetFolder -Force | Out-Null
}

Function Add-Tool-File($projectItems, $targetFolder, $filename) {
	$targetsPath = [IO.Path]::GetFullPath((Join-Path $targetFolder $filename))
	$projectItems.AddFromFile($targetsPath) | Out-Null
}

function Get-Solution-Dir($solution) {
    if($solution -and $solution.IsOpen) {
        return (Split-Path $solution.Properties.Item("Path").Value)
    }
    else {
        throw "Solution not available"
    }
}

function Get-Solution-Name($solution) {
    if($solution -and $solution.IsOpen) {
        return $solution.Properties.Item("Name").Value
    }
    else {
        throw "Solution not available"
    }
}

function Add-MSBuild-Import($msbuildProject, $path) {
    $import = $msbuildProject.Xml.Imports | Where { $_.Project -eq $path }
    if ($import) {
        $import = $msbuildProject.Xml.AddImport($path)
        $buildProject.Save()
    }
}

Export-ModuleMember Deploy-Solution-Folder, Deploy-Solution-File, Add-Solution-Folder, Add-Solution-File, Get-Solution-Dir, Get-Solution-Name, Create-Solution-Folder, Add-MSBuild-Import