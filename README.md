# Zaibot.MSBuildTasks
Automatic assembly version update for C#/msbuild projects based on GIT release labels.

## Install
```ps
Install-Package Zaibot.MSBuildTasks
```

The installer creates a folder in the solution folder called Includes. Two files are created: ```<ProductName>_Product.cs``` and ```<ProductName>_Version.cs```.
The purpose of ```<ProductName>_Product.cs``` is to have company and product information all in one place.
The purpose of ```<ProductName>_Version.cs``` is to store the version of the product, this file will be overwritten with each build.

Before building make sure there's atleast one version tag prefixed with 'v', for example:
```
git tag releases/0.1/v0.1.0-alpha
```

## Usage
Tag the commits to be release using NuGet SemVer-2.0.0 prefixed with a 'v'. When there's a commit after the tag a number behind the version number will increase.

### MSBuild Properties
Output
```
ProductVersionShort 1.2
ProductVersionLong 1.2.3.0
ProductVersionDescriptiveShort 1.2.3-beta.1 
ProductVersionDescriptiveLong 1.2.3-beta.1-1ad6c8 feature/new_feature
```
Optional Input
```
ZaibotMSBuildTasksPath = $(SolutionDir).build\
ZaibotMSBuildTasksLib = $(ZaibotMSBuildTasksPath)Zaibot.MSBuildTasks.dll
VersionFile = $(SolutionDir)Includes\$(SolutionName)_Version.cs
```

### Use case example 1
master branch with regular version tag.
```
git checkout master
...
git commit -m ...
git tag releases/0.1/v0.1.0
build
```
```
Version Short: 0.1 Version Long: 0.1.0.0 Descriptive Long: 0.1.0
```

### Use case example 2
feature branch with regular version tag.
```
git checkout feature/new_feature
...
git commit -m ...
git tag releases/0.1/v0.1.0
build
```
```
Version Short: 0.1 Version Long: 0.1.0.0 Descriptive Long: 0.1 feature/new_feature
```

### Use case example 3
feature branch with annotated tag.
```
git checkout feature/new_feature
...
git commit -m ...
git tag releases/0.1/v0.1.0-beta
build
```
```
Version Short: 0.1 Version Long: 0.1.0.0 Descriptive Long: 0.1-beta feature/new_feature
```

### Use case example 4
master branch with commit after tag.
```
git checkout master
...
git commit -m ...
git tag releases/0.1/v0.1.0
...
git commit -m ...
build
```
```
Version Short: 0.1 Version Long: 0.1.0.0 Descriptive Long: 0.1-beta.1-commithash
```

### Examples
 - releases/0.1/v0.1.0-alpha
 - releases/0.1/v0.1.0-beta
 - releases/0.1/v0.1.0

## Uninstall
```ps
Uninstall-Package Zaibot.MSBuildTasks
```
The uninstaller does not remove the ```.build\Zaibot.MSBuildTasks*.*``` targets or version include files.

## License

Licensed under the MIT License

# Zaibot.MSBuildTasks.NuGet

## Install
```ps
Install-Package Zaibot.MSBuildTasks.NuGet
```

**Reload the project/solution after installation.**

The installer creates a nuspec file if it does not exist yet: ```<ProjectName>.nuspec```. **Change the Build Action** of the nuspec files you would like to pack on a *Release* build to ```ZaibotNuSpecPack```. 

## Usage
```
msbuild Solution.sln /t:Rebuild /p:"Configuration=Release"
```

When ```Zaibot.MSBuildTasks``` is installed the ```ProductVersionDescriptiveShort``` property will be assigned to the nuspec package.

### Publishing NuGet packages
```
msbuild Solution.sln /t:Rebuild /p:"Configuration=Release;"
```

### MSBuild Properties
Optional Input
```
NuGetExePath = $(SolutionDir).nuget\nuget.exe
NuSpecPath = (empty)
NuGetSourceUrl = (empty)
NuGetSourceApiKey = (empty)
ZaibotMSBuildTasksPath = $(SolutionDir).build\
ZaibotMsBuildTasks = $(ZaibotMSBuildTasksPath)Zaibot.MSBuildTasks.targets
NuSpecPackageVersion = (empty)
NuSpecPackageFile = (empty)
```

## Uninstall
```ps
Uninstall-Package Zaibot.MSBuildTasks.NuGet
```
The uninstaller does not remove the ```.build\Zaibot.MSBuildTasks.NuGet*.*``` targets or nuspec files.

## License

Licensed under the MIT License
