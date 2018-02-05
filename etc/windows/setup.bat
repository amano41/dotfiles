@echo off

cd /d %~dp0

setlocal

rem ===================================
rem  Environment Variables
rem ===================================

set ROOT=D:
set TEMP_USER=R:\Temp\User
set TEMP_SYSTEM=R:\Temp\System

if not exist "%ROOT%\" (
	echo Root drive '%ROOT%' not found. 1>&2
	echo Use '%HOMEDRIVE%' instead. 1>&2
	set ROOT=%HOMEDRIVE%
)

setx HOME %ROOT%\Home\%USERNAME% > nul
if not exist "%HOME%" (
	mkdir %HOME%
)
echo HOME = %HOME% 1>&2

setx ATOM_HOME "%HOME%\.atom" > nul
if not exist "%ATOM_HOME%\" (
	mkdir %ATOM_HOME%
)
echo ATOM_HOME = %ATOM_HOME% 1>&2

if exist "%TEMP_USER%\" (
	setx TEMP %TEMP_USER% > nul
	setx TMP %TEMP_USER% > nul
) else (
	echo '%TEMP_USER%' not found. 1>&2
)
echo User TEMP = %TEMP_USER% 1>&2

if exist "%TEMP_SYSTEM%\" (
	setx /m TEMP %TEMP_SYSTEM% > nul
	setx /m TMP %TEMP_SYSTEM% > nul
) else (
	echo '%TEMP_SYSTEM%' not found. 1>&2
)
echo System TEMP = %TEMP_SYSTEM% 1>&2


rem ===================================
rem  Chocolatey
rem ===================================

if exist chocolatey\setup.bat (
	call chocolatey\setup.bat
) else (
	echo 'chocolatey\setup.bat' not found. 1>&2
)


rem ===================================
rem  Cygwin
rem ===================================

if exist cygwin\setup.bat (
	call cygwin\setup.bat
) else (
	echo 'cygwin\setup.bat' not found. 1>&2
)
