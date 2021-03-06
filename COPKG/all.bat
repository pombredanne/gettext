@echo off
setlocal

if "%1"=="clean" goto :clean
if "%1"=="noclean" (
	set __NOCLEAN__=true
	shift)

copy /y ..\gettext-runtime\intl\libgnuintl.h.in ..\gettext-runtime\intl\libintl.h

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" amd64
call :build x64 Release v110 || goto :eof
call :build x64 Debug v110 || goto :eof
endlocal

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86
call :build Win32 Release v110 || goto :eof
call :build Win32 Debug v110 || goto :eof
endlocal

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64
call :build x64 Release v100 || goto :eof
call :build x64 Debug v100 || goto :eof
endlocal

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86
call :build Win32 Release v100 || goto :eof
call :build Win32 Debug v100 || goto :eof
endlocal

if "%__NOCLEAN__%"=="true" goto :eof

goto :clean

:build
REM msbuild /P:Platform=%1 /P:Configuration=%2 /P:PlatformToolset=%3 gettext\gettext.sln
msbuild /P:Platform=%1 /P:Configuration=%2 /P:PlatformToolset=%3 /P:ConfigurationType=DynamicLibrary libintl\libintl.vcxproj || goto :eof
msbuild /P:Platform=%1 /P:Configuration=%2 /P:PlatformToolset=%3 /P:ConfigurationType=StaticLibrary libintl\libintl.vcxproj || goto :eof
goto :eof

:clean
rd /s /q libintl\intermediate

