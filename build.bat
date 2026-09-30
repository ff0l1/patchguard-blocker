@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
set "CMAKE="
where cmake >nul 2>&1 && set "CMAKE=cmake"
if not defined CMAKE if exist "%ProgramFiles%\CMake\bin\cmake.exe" set "CMAKE=%ProgramFiles%\CMake\bin\cmake.exe"
if not defined CMAKE if exist "%ProgramFiles%\Microsoft Visual Studio\18\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" set "CMAKE=%ProgramFiles%\Microsoft Visual Studio\18\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
if not defined CMAKE (
    echo [-] cmake was not found
    exit /b 1
)
"%CMAKE%" -S . -B build -A x64
if errorlevel 1 exit /b 1
"%CMAKE%" --build build --config Release
exit /b %errorlevel%
