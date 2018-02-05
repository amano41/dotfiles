@echo off

cd /d %~dp0

setlocal

set CYGWIN_ROOT=C:\Cygwin64
set CYGWIN_LOCAL_PACKAGE_DIR=%CYGWIN_ROOT%\packages
set CYGWIN_MIRROR=http://ftp.jaist.ac.jp/pub/cygwin/
set CYGWIN_PACKAGES=wget,ca-certificates,gnupg

if not exist "%CYGWIN_LOCAL_PACKAGE_DIR%\" (
	mkdir %CYGWIN_LOCAL_PACKAGE_DIR%
)

pushd %CYGWIN_LOCAL_PACKAGE_DIR%
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module BitsTransfer; Start-BitsTransfer https://cygwin.com/setup-x86_64.exe"
start /wait setup-x86_64.exe -B -q -n -R %CYGWIN_ROOT% -l %CYGWIN_LOCAL_PACKAGE_DIR% -s %CYGWIN_MIRROR% -P %CYGWIN_PACKAGES%
popd

copy fstab %CYGWIN_ROOT%\etc\fstab > nul

setx CYGWIN "winsymlinks:nativestrict"
setx MAKE_MODE "unix"
setx SHELL "/bin/bash"
setx SHELLOPTS "igncr"

pushd %CYGWIN_ROOT%\usr\local\bin
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module BitsTransfer; Start-BitsTransfer https://raw.githubusercontent.com/kou1okada/apt-cyg/master/apt-cyg"
popd
