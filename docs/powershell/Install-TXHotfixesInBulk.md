# Install-TXHotfixesInBulk.ps1

## Overview

[Install-TXHotfixesInBulk](/powershell/Install-TXHotfixesInBulk.ps1) installs MSI files from a specified directory. It ensures that the script is run with administrative privileges, checks if a specific process is running, and extracts zip files if present in the directory before proceeding with the installation.

## Requirements

- Windows operating system
- Administrative privileges to run the script
- PowerShell version 5.0 or later

## Usage

### Syntax

```powershell
.\InstallFiles.ps1 -Path <string>
```

### Parameters

#### `-Path`
- **Type**: `string`
- **Mandatory**: `True`
- **Description**: Specify the directory where installation files are located.

### Examples

To run the script and specify the directory where the installation files are located:

```powershell
.\InstallFiles.ps1 -Path "C:\InstallFiles"
```
## Troubleshooting

### Setting Execution Policy

If you encounter issues running the script, it may be due to PowerShell's execution policy settings. By default, the execution policy is set to restrict running scripts. To run this script, you may need to change the execution policy. refer [ExecutionPolicy](/docs/powershell/ExecutionPolicy.md) for more details.