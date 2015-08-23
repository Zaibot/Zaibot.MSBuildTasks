param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "MSBuild.psm1")
Import-Module (Join-Path $toolsPath "Zaibot.MSBuildTasks.psm1")

function Main 
{
    $buildProject = Get-MSBuildProject $project.Name
    Add-MSBuild-Import($buildProject, "`$(SolutionDir)\.build\Zaibot.MSBuildTasks.targets")
}

Main