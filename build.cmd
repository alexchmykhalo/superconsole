@echo off

rem ***************************************************************************
rem * SuperConsole Build Script                                               *
rem * Copyright (C) 2020  Alex Chmykhalo <alex.chmykhalo@gmail.com>           *
rem *                                                                         *
rem * SuperConsole is a software collection based on ConEmu, MSYS2, Mintty    *
rem * Zsh, Git for Windows, grml-zsh-config, antigen and agkozak-zsh-theme    *
rem * projects customized and configured for everyday use.                    *
rem *                                                                         *
rem * Should work on Windows 10. Just run this script to get a fresh build.   *
rem ***************************************************************************

rem **************************************************************
rem *                    Build Configuration                     *
rem **************************************************************

set SCRIPT_DIR=%~dp0
set BUILD_DIR=%SCRIPT_DIR%build

set CURL_PATH=%SCRIPT_DIR%curl\curl.exe

set NUGET_DOWNLOAD_URL=https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
set NUGET_PATH=%BUILD_DIR%\nuget.exe

set P7ZIP_PACKAGE_NAME="7-Zip.CommandLine"
set P7ZIP_PACKAGE_VERSION="18.1.0"
set P7ZIP_PATH=%BUILD_DIR%\%P7ZIP_PACKAGE_NAME%.%P7ZIP_PACKAGE_VERSION%\tools\x64\7za.exe

set CONEMU_MAJ_VER=20
set CONEMU_MIN_VER=07
set CONEMU_PATCH_VER=13
set CONEMU_DOWNLOAD_LINK="https://github.com/Maximus5/ConEmu/releases/download/v%CONEMU_MAJ_VER%.%CONEMU_MIN_VER%.%CONEMU_PATCH_VER%/ConEmuPack.%CONEMU_MAJ_VER%%CONEMU_MIN_VER%%CONEMU_PATCH_VER%.7z"
set CONEMU_PACKAGE_NAME=%BUILD_DIR%\ConEmuPack.%CONEMU_MAJ_VER%%CONEMU_MIN_VER%%CONEMU_PATCH_VER%.7z
set CONEMU_DIR=%BUILD_DIR%\ConEmu

set MSYS2_RELEASE_YEAR=2020
set MSYS2_RELEASE_MOUNTH=06
set MSYS2_RELEASE_DAY=29
set MSYS2_DOWNLOAD_LINK="https://github.com/msys2/msys2-installer/releases/download/%MSYS2_RELEASE_YEAR%-%MSYS2_RELEASE_MOUNTH%-%MSYS2_RELEASE_DAY%/msys2-base-x86_64-%MSYS2_RELEASE_YEAR%%MSYS2_RELEASE_MOUNTH%%MSYS2_RELEASE_DAY%.tar.xz"
set MSYS2_PACKAGE_NAME=%BUILD_DIR%\msys2-base-x86_64-%MSYS2_RELEASE_YEAR%%MSYS2_RELEASE_MOUNTH%%MSYS2_RELEASE_DAY%.tar.xz
set MSYS2_DIR=%BUILD_DIR%\ConEmu

set POST_INSTALL_DIR_PATH=%SCRIPT_DIR%post-install
set THIRDPARTY_DIR_PATH=%SCRIPT_DIR%scripts
set THIRDPARTY_DEST_PATH=%MSYS2_DIR%\msys64\3rdparty
set POST_INSTALL_DEST_PATH=%THIRDPARTY_DEST_PATH%\post-install
set POST_INSTALL_SCRIPT_DEST_PATH=/3rdparty/post-install/post-install.sh

set ANTIGEN_URL="https://git.io/antigen"

set SUPER_CONSOLE_PACKAGE_NAME=SuperConsole.7z

rem **************************************************************
rem *                     Package Build                          *
rem **************************************************************

echo Create build dir...
if not exist "%BUILD_DIR%" mkdir %BUILD_DIR% > %temp%\nul

echo Download nuget and install additional tools...
%CURL_PATH% %NUGET_DOWNLOAD_URL% --output %NUGET_PATH% > %temp%\nul
%NUGET_PATH% install %P7ZIP_PACKAGE_NAME% -Version %P7ZIP_PACKAGE_VERSION% -OutputDir %BUILD_DIR% > %temp%\nul

echo Enter build directory...
cd %BUILD_DIR% > %temp%\nul

echo Download ConEmu...
%CURL_PATH% -LJO %CONEMU_DOWNLOAD_LINK% --output %CONEMU_PACKAGE_NAME% > %temp%\nul
echo Unpack ConEmu...
%P7ZIP_PATH% x %CONEMU_PACKAGE_NAME% -o%CONEMU_DIR% -r -y > %temp%\nul

echo Download MSYS2...
%CURL_PATH% -LJO %MSYS2_DOWNLOAD_LINK% --output %MSYS2_PACKAGE_NAME% > %temp%\nul
echo Unpack MSYS2...
%P7ZIP_PATH% x %MSYS2_PACKAGE_NAME% -so | %P7ZIP_PATH% x -aoa -si -ttar -o%MSYS2_DIR% > %temp%\nul

echo Copy post-install and helper scripts and necessary config files...
if not exist "%POST_INSTALL_DEST_PATH%" mkdir %POST_INSTALL_DEST_PATH% > %temp%\nul
copy /Y %THIRDPARTY_DIR_PATH%\*.* %THIRDPARTY_DEST_PATH% > %temp%\nul
copy /Y %POST_INSTALL_DIR_PATH%\*.* %POST_INSTALL_DEST_PATH% > %temp%\nul
copy /Y %POST_INSTALL_DIR_PATH%\nsswitch.conf %MSYS2_DIR%\msys64\etc > %temp%\nul
copy /Y %POST_INSTALL_DIR_PATH%\ConEmu.xml %MSYS2_DIR% > %temp%\nul

echo Download antigen...
%CURL_PATH% -L %ANTIGEN_URL% > %THIRDPARTY_DEST_PATH%\antigen.zsh

echo Initialize MSYS2 with first shell run...
%MSYS2_DIR%\msys64\usr\bin\bash.exe --login -c exit

echo Try to update base packages...
%MSYS2_DIR%\msys64\usr\bin\bash.exe --login -c "pacman -Suy --noconfirm && exit"

echo Run post-install script...
set MSYS2_PATH_TYPE=inherit
set MSYSTEM=MINGW64
%MSYS2_DIR%\msys64\usr\bin\bash.exe --login -c "%POST_INSTALL_SCRIPT_DEST_PATH% && exit"

set "PATH=%MSYS2_DIR%\msys64\mingw64\bin;%MSYS2_DIR%\msys64\usr\bin;%MSYS2_DIR%\msys64\3rdparty;%PATH%"
%MSYS2_DIR%\msys64\usr\bin\zsh.exe --login -i -c "antigen reset && exit"

echo Prepare SuperConsole package...
%P7ZIP_PATH% a -t7z -m0=lzma -mx=9 -mfb=64 -md=128m -ms=on %SUPER_CONSOLE_PACKAGE_NAME% %CONEMU_DIR%

cd ..

move /Y %BUILD_DIR%\%SUPER_CONSOLE_PACKAGE_NAME% .\ > %temp%\nul

pause
@echo on
