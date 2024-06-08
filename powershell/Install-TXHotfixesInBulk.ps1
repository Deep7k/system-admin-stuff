<#
.SYNOPSIS
    Installs MSI files from a specified directory.

.DESCRIPTION
    This script installs MSI files located in a specified directory. It ensures that the script is run with administrative privileges, checks if a specific process is running, and extracts zip files if present in the directory before proceeding with the installation.

.PARAMETER Path
    Specify the directory where installation files are located.
    Type: String
    Mandatory: True

.EXAMPLE
    .\InstallFiles.ps1 -Path "C:\InstallFiles"
    This command runs the script and specifies the directory where the installation files are located.

.NOTES
    - Ensure you have administrative privileges before running this script.
    - Close any instance of the "Tune" application before executing the script.
    - Ensure the specified directory exists and contains the necessary installation files.

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Helpmessage = "Specify the Directory where Installation files are located")]
    [string]
    $Path
)

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an Administrator!" -ForegroundColor Red
    Exit
}

if (Get-Process -Name "Tune" -ErrorAction SilentlyContinue) {
    Write-Host "Error: Tecnomatix is Running. Please close it and rerun the script" -ForegroundColor Red
    Exit
}

if (Test-Path $Path) {
    $msiFiles = Get-ChildItem -Path $Path -Filter *.msi
    if (Get-ChildItem -Path $Path -Filter *.zip) {
        Write-Host "Found zip files in $Path. Extracting them..."
        Expand-Archive -Path $Path.FullName -DestinationPath $Path.FullName -Force
        $msiFiles = Get-ChildItem -Path $Path -Filter *.msi
    }
}
else {
    Write-Host "Directory Does not exist." -ForegroundColor Red
    Exit
}

try {
    foreach ($msiFile in $msiFiles) {
        $process = Start-Process msiexec.exe -ArgumentList "/i `"$($msiFile.FullName)`" /quiet /norestart" -PassThru -Wait
        if ($process.ExitCode -eq 0) {
            Write-Host "$($msiFile.Name) successfully installed."
        }
        else {
            Write-Host "Failed to install $($msiFile.Name). Exit code: $($process.ExitCode)"
        }
    }
}
catch {
    Write-Error "Unable to complete installation. Error: $_"
}

