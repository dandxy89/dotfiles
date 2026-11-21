#Requires -Version 5.1
<#
.SYNOPSIS
    Bootstrap a Windows machine: Ubuntu under WSL, then bootstrap-debian.sh inside it.

.DESCRIPTION
    The config (zsh, tmux, nvim-setup.sh) is POSIX-only, so Windows gets it through WSL.

    First run: installs WSL + Ubuntu (needs an elevated prompt) and exits. Reboot if asked,
    open "Ubuntu" once to create your Linux user, then re-run.
    Later runs: clone or pull the repo inside WSL and run bootstrap-debian.sh.

    Arguments are passed through to bootstrap-debian.sh, e.g. --upgrade or --skip-config.

.EXAMPLE
    Set-ExecutionPolicy -Scope Process Bypass; .\scripts\bootstrap-windows.ps1 --upgrade
#>
# ponytail: plain $args, not param(): an advanced script rejects --upgrade as an unknown parameter.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Distro = 'Ubuntu'

# `wsl -l -q` prints UTF-16; strip the NULs before comparing.
[string[]] $distros = (wsl.exe -l -q 2>$null) -replace "`0", '' | ForEach-Object { $_.Trim() }
if ($distros -notcontains $Distro) {
    wsl.exe --install -d $Distro
    if ($LASTEXITCODE -ne 0) { throw "wsl --install failed (exit $LASTEXITCODE): run from an elevated PowerShell" }
    Write-Output "WSL + $Distro installed. Reboot if prompted, open '$Distro' once to create your user, then re-run."
    exit 0
}

# --exec skips WSL's login shell, so bash alone parses this. No double quotes: Windows
# PowerShell 5.1 drops them when passing arguments to native programs.
[string] $bootstrap = 'd=$HOME/Projects/dotfiles; ' +
    'if [ -d $d/.git ]; then git -C $d pull --ff-only; else git clone https://github.com/dandxy89/dotfiles.git $d; fi && ' +
    'exec $d/scripts/bootstrap-debian.sh $@'

wsl.exe -d $Distro --exec bash -c $bootstrap bootstrap @args
if ($LASTEXITCODE -ne 0) { throw "bootstrap-debian.sh failed inside WSL (exit $LASTEXITCODE)" }

# Ghostty has no Windows build; Windows Terminal needs the font installed on the Windows side.
Write-Output 'Done. For Windows Terminal, install Geist Mono from https://github.com/vercel/geist-font/releases and set it as the Ubuntu profile font.'
