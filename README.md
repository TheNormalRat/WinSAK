# Windows Swiss Army Knife

A comprehensive PowerShell toolkit for Windows system management, debloating, activation, and application installation.

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

## Installation

1. Clone or download this repository:
   ```powershell
   git clone https://github.com/TheNormalRat/WinSAK.git
   cd WinSAK
   ```

2. Run the launcher script:
   ```powershell
   .\Start-WinSAK.ps1
   ```

## Usage

Simply run `Start-WinSAK.ps1` and navigate through the interactive menu system:

```powershell
.\Start-WinSAK.ps1
```

The menu-driven interface makes it easy to:
- Browse system information
- Activate Windows/Office
- Debloat Windows 11
- Install popular applications

## Project Structure

```
WinSAK/
│
├── Start-WinSAK.ps1              # Main launcher script
├── WindowsSwissArmyKnife.psm1    # Core module
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
