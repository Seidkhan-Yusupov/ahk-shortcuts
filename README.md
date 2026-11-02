# Khan's portable AutoHotkey v1

Session-only shortcuts for Windows 10/11. No installation, admin access, or startup entry.

## Setup once on your own PC

1. Make a public GitHub repo, such as `ahk-shortcuts`.
2. Upload `khan_sudo_keys.ahk` and `launch.ps1` to its root.
3. Change `$Repository = 'USERNAME/ahk-shortcuts'` in `launch.ps1` to your GitHub username and repository.
4. Commit to the `main` branch.

## On a university computer

Open PowerShell and use this command (replace `USERNAME` first):

```powershell
irm https://raw.githubusercontent.com/USERNAME/ahk-shortcuts/main/launch.ps1 | iex
```

**Security:** The command runs remote code. Only use a repository you control and whose launcher you have inspected. For a safer alternative, download `launch.ps1`, review it and run the local file according to university policy.

## End your session

Right-click the green **H** AutoHotkey system-tray icon > **Exit**. Leave PowerShell open until it prints that the temporary files were removed. If you close PowerShell first, AutoHotkey may continue running and cleanup may be skipped; sign out of Windows when leaving a shared computer.

The launcher downloads official portable AutoHotkey **v1.1.37.02**, verifies its SHA-256 hash, downloads the latest shortcuts from your repository, and runs them. The `.exe` installer you uploaded is not required. The script is not compatible with AutoHotkey v2 without changes.

University IT restrictions may block PowerShell downloads or portable executables; do not bypass those restrictions.
