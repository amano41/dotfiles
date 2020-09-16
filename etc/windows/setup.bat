@echo off

rem PowerShell スクリプトを実行するためのラッパー

cd %~dp0
powershell -NoProfile -ExecutionPolicy Unrestricted .\setup.ps1
