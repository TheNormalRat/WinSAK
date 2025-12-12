@echo off
powershell.exe -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0Start-WinSAK.ps1\"' -Verb RunAs"
