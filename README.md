# Windows Swiss Army Knife (WinSAK)

A comprehensive PowerShell toolkit for Windows system management, debloating, activation, and application installation.

**I am NOT responsible for any damage done to your machine.**
**WinSAK** is simply a PowerShell-based interface that uses small scripts and links to amazing open-source projects.

**If you don’t understand what you’re doing, you should not be doing it.**

## Features

### 1. System Information & Diagnostics
- View detailed system information
- List installed software
- Check disk space usage
- Monitor top processes by CPU or Memory

### 2. Windows Activation Tools
- Check Windows activation status
- Activate Windows using [Microsoft Activation Scripts (MAS)](https://github.com/massgravel/Microsoft-Activation-Scripts)
- Activate Office products

### 3. Windows Debloat Manager
- Powered by [Win11Debloat by Raphire](https://github.com/Raphire/Win11Debloat)
- Run default debloat (recommended settings)
- Silent mode for automated deployments
- Custom debloat with selective removal
- Revert changes and reinstall removed apps

### 4. Install Applications
Quick installation of popular applications via winget:
- Steam
- Discord
- NVIDIA GeForce Experience
- 7-Zip
- Mozilla Firefox
- Google Chrome
- SteelSeries GG
- Search and install custom apps
- View all installed applications

## Requirements

- Windows 10/11
- PowerShell 5.1 or higher
- Administrator privileges (for some operations)
- Internet connection (for downloads and activation)

## Installation & Usage

### Method 1: One-Line Quick Start (No Installation Required)
Perfect for quick use or trying out the tool. Run this command in PowerShell:
```powershell
irm https://raw.githubusercontent.com/TheNormalRat/WinSAK/main/Start-WinSAK.ps1 | iex
```
This downloads and runs the script directly without cloning the repository.

### Method 2: Batch File Launcher (Recommended for Regular Use)
1. Clone or download this repository:
   ```powershell
   git clone https://github.com/TheNormalRat/WinSAK.git
   ```
   Or download as ZIP and extract it.

2. Double-click **`WinSAK.bat`** to launch with automatic admin privileges.

### Method 3: PowerShell Direct
1. Clone or download the repository (see Method 2)
2. Navigate to the folder and run:
   ```powershell
   .\Start-WinSAK.ps1
   ```

## How to Use

Once launched, you'll see an interactive menu with the following options:

**System Information & Diagnostics**
- View comprehensive system details (OS, CPU, RAM, disk space)
- List all installed software
- Monitor top processes by CPU or memory usage

**Windows Activation Tools**
- Check current Windows activation status
- Activate Windows using HWID/KMS methods
- Activate Microsoft Office products

**Windows Debloat Manager**
- Run default debloat with recommended settings
- Use silent mode for automated deployments
- Custom debloat to selectively remove specific apps
- Revert changes and reinstall removed applications

**Install Applications**
- Quick install popular apps (Steam, Discord, Chrome, Firefox, etc.)
- Search and install any app from winget repository
- View all currently installed applications

Simply enter the number of your choice and follow the prompts. The interface is designed to be self-explanatory and user-friendly.

## Project Structure

```
WinSAK/
│
├── Start-WinSAK.ps1              # Main launcher script
├── WinSAK.bat                    # Batch file launcher (auto admin)
│
└── Utilities/                     # Utility modules
    ├── SystemInfo.ps1            # System information functions
    ├── NetworkTools.ps1          # Network diagnostics
    ├── FileSystemTools.ps1       # File system utilities
    ├── ProcessTools.ps1          # Process management
    ├── ActivationManager.ps1     # Windows/Office activation
    ├── DebloatManager.ps1        # Windows debloating
    └── AppInstaller.ps1          # Application installation
```

## Integrated Projects

This toolkit integrates the following excellent open-source projects:

- **[Microsoft Activation Scripts (MAS)](https://github.com/massgravel/Microsoft-Activation-Scripts)** - Windows and Office activation
- **[Win11Debloat](https://github.com/Raphire/Win11Debloat)** - Windows 11 debloating and optimization

## Credits

- **MAS** by [massgravel](https://github.com/massgravel)
- **Win11Debloat** by [Raphire](https://github.com/Raphire)
- Built with PowerShell

## License

This project is provided as-is for educational and personal use.

## Disclaimer

- Use at your own risk
- Always create system backups before making system modifications
- Activation scripts are provided by third-party projects (MAS)
- This tool is for personal use only

## Contributing

Feel free to submit issues or pull requests to improve this toolkit.
