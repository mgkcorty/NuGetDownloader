param(
    [string]$packageName,
	[string]$version=""
)

$nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$currentDir = $PSScriptRoot
$nugetExe = [IO.Path]::Combine($currentDir, "nuget.exe")
if(!$([IO.File]::Exists($nugetExe)))
{
    Invoke-WebRequest $nugetUrl -OutFile $nugetExe	
}

$packageDir = [IO.Path]::Combine($currentDir, $packageName)
$resultPackageDir = [IO.Path]::Combine($currentDir, "$($packageName)-clean")

[IO.Directory]::CreateDirectory($packageDir)
[IO.Directory]::CreateDirectory($resultPackageDir)

cd $packageDir
if($version -eq "")
{
    & $nugetExe install $packageName
}
else
{
    & $nugetExe install $packageName -version $version
}
$result = Get-ChildItem -Path $packageDir -Filter *.nupkg -Recurse -File -Name | ForEach-Object {
	[System.IO.Path]::Combine($packageDir, $_)
}
$result | Copy-Item -Destination $resultPackageDir