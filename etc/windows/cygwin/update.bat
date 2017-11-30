@echo off

cd %~dp0

setlocal

set CYGWIN_ROOT=C:\Cygwin64
set CYGWIN_LOCAL_PACKAGE_DIR=%CYGWIN_ROOT%\packages

if not exist "%CYGWIN_LOCAL_PACKAGE_DIR%\" (
	echo "directory not found: %CYGWIN_LOCAL_PACKAGE_DIR" 1>&2
	exit /b 1
)

pushd %CYGWIN_LOCAL_PACKAGE_DIR%
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module BitsTransfer; Start-BitsTransfer https://cygwin.com/setup-x86_64.exe"
start /wait setup-x86_64.exe -B -q -n -g
popd
