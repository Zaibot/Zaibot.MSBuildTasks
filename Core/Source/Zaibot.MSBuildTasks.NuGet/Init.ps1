param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")

function Copy-MSBuildTasks($project) {
	$solutionDir = Get-SolutionDir
	$tasksToolsPath = (Join-Path $solutionDir ".build")

	if(!(Test-Path $tasksToolsPath)) {
		mkdir $tasksToolsPath | Out-Null
	}

	Write-Host "Copying Zaibot MSBuildTasks files to $tasksToolsPath"
	Copy-Item "$toolsPath\Zaibot.MSBuildTasks.NuGet.targets" $tasksToolsPath -Force | Out-Null
	Copy-Item "$toolsPath\Zaibot.MSBuildTasks.NuGet.Readme.txt" $tasksToolsPath -Force | Out-Null

	$buildFile = Join-Path $solutionDir "Build.proj"
	
	Write-Host "Don't forget to commit the .build folder"
	return "$tasksToolsPath"
}

function Add-Solution-Folder($buildPath) {
	# Get the open solution.
	$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])

	# Create the solution folder.
	$buildFolder = $solution.Projects | Where {$_.ProjectName -eq ".build"}
	if (!$buildFolder) {
		$buildFolder = $solution.AddSolutionFolder(".build")
	}
	
	# Add files to solution folder
	$projectItems = Get-Interface $buildFolder.ProjectItems ([EnvDTE.ProjectItems])

	$targetsPath = [IO.Path]::GetFullPath( (Join-Path $buildPath "Zaibot.MSBuildTasks.NuGet.targets") )
	$projectItems.AddFromFile($targetsPath)

	$dllPath = [IO.Path]::GetFullPath( (Join-Path $buildPath "Zaibot.MSBuildTasks.NuGet.Readme.txt") )
	$projectItems.AddFromFile($dllPath)
}


function Main 
{
	$taskPath = Copy-MSBuildTasks $project
	Add-Solution-Folder $taskPath
}

Main