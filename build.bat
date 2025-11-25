@echo off
REM ======================================================
REM bvault Build Script (Windows) - Makefile-free
REM ======================================================

SET BUILD_DIR=build
SET SRC_DIR=src
SET LIBSODIUM_BIN=libs/libsodium/bin
SET DLL_NAME=libsodium-23.dll

REM ======================================================
REM Check for clean argument
REM Usage: build.bat clean
REM ======================================================
IF "%1"=="clean" (
    echo Cleaning build directory...
    if exist %BUILD_DIR% rmdir /s /q %BUILD_DIR%
    echo Done.
    exit /b
)

REM ======================================================
REM Create build directory if it doesn't exist
REM ======================================================
if not exist %BUILD_DIR% mkdir %BUILD_DIR%

REM ======================================================
REM Compile each .c file into .o + .d
REM ======================================================
for %%f in (%SRC_DIR%\*.c) do (
    echo Compiling %%f ...
    gcc -Wall -Wextra -Iinclude -Ilibs/libsodium/include -I%SRC_DIR% -std=c11 -MMD -MP -c %%f -o %BUILD_DIR%\%%~nf.o
)

REM ======================================================
REM Link all object files into final executable
REM ======================================================
echo Linking executable...
gcc %BUILD_DIR%\*.o -Llibs/libsodium/lib -lsodium -lws2_32 -o %BUILD_DIR%\bvault.exe

REM ======================================================
REM Copy libsodium DLL into build folder
REM ======================================================
if exist %LIBSODIUM_BIN%\%DLL_NAME% (
    copy /Y %LIBSODIUM_BIN%\%DLL_NAME% %BUILD_DIR%\
    echo Copied %DLL_NAME% into %BUILD_DIR%
) else (
    echo WARNING: %DLL_NAME% not found in %LIBSODIUM_BIN%
)

REM ======================================================
REM Finished
REM ======================================================
echo.
echo Build finished! You can now run your program:
echo %BUILD_DIR%\bvault.exe
pause
