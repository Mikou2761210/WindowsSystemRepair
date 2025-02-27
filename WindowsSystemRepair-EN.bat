::MIT License

::Copyright (c) 2025 Mikou

::Permission is hereby granted, free of charge, to any person obtaining a copy
::of this software and associated documentation files (the "Software"), to deal
::in the Software without restriction, including without limitation the rights
::to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
::copies of the Software, and to permit persons to whom the Software is
::furnished to do so, subject to the following conditions:

::The above copyright notice and this permission notice shall be included in all
::copies or substantial portions of the Software.

::THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
::IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
::FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
::AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
::LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
::OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
::SOFTWARE.




@echo off
chcp 65001 >nul
::WindowsSystemRepair
title Windows System Repair

:: Check if running with administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Administrator privileges are required. Restarting...
    powershell -Command "try { Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs -ErrorAction Stop } catch { echo User canceled. }"
    exit
)

:: For changing font color
for /f %%i in ('cmd /k prompt $e^<nul') do set ESC=%%i

echo Windows System Repair
echo Version 1.0 (Released on February 14, 2025)
echo Created by Mikou (https://github.com/Mikou2761210)
echo Project page: https://github.com/Mikou2761210/WindowsSystemRepair
echo Distribution page: https://github.com/Mikou2761210/WindowsSystemRepair/releases
echo.
echo I take no responsibility for any issues caused by using this batch file.
echo Use it at your own risk.

:Re
echo.
echo = Options =====================
echo 0: Exit
echo 1: Check and repair system files
echo 2: Check and repair system image
echo 3: Clean up system data
echo 4: Handle corrupted mount points
echo 5: Automatic mode (1→2→3→4→1)
echo 6: Help
echo =================================
choice /c 0123456 /n /m "Enter a number between 0 and 6: "
if errorlevel 7 goto :Help
call :Warning
if errorlevel 6 (call :Auto & goto :End)
if errorlevel 5 (call :Dism_Cleanup_Mountpoints & goto :End)
if errorlevel 4 (call :Dism_Online_Cleanup_Image_StartComponentCleanup & goto :End)
if errorlevel 3 (call :Dism_Online_Cleanup_Image & goto :End)
if errorlevel 2 (call :Sfc_Scannow & goto :End)
if errorlevel 1 (call :Exit & goto :End)

:End
echo ----------%ESC%[36mRepair completed.%ESC%[0m----------
echo ----------Press any key to return to the selection screen.----------
pause
goto :Re

:Warning
echo.
echo ----------%ESC%[31mDo not close the command prompt until the process is complete.%ESC%[0m----------
echo ----------%ESC%[31m(This may cause unexpected issues.)%ESC%[0m----------
echo.
goto :EOF

:Help
echo This batch file uses Windows repair commands.
echo Check and repair system files : sfc /scannow
echo Check and repair system image : Dism /Online /Cleanup-Image /ScanHealth , Dism /Online /Cleanup-Image /Restorehealth
echo Clean up system data : Dism /Online /Cleanup-Image /StartComponentCleanup
echo Handle corrupted mount points : Dism /Cleanup-Mountpoints
echo Automatic mode : Executes commands 1~4 in the appropriate order.
echo ----------Press any key to return to the selection screen.----------
pause
goto :Re

:Auto
call :Sfc_Scannow
echo.
call :Dism_Online_Cleanup_Image
echo.
call :Dism_Online_Cleanup_Image_StartComponentCleanup
echo.
call :Dism_Cleanup_Mountpoints
echo.
call :Sfc_Scannow
echo.
goto :EOF

:Dism_Online_Cleanup_Image_StartComponentCleanup
echo ----------%ESC%[30;47mCleaning up system data%ESC%[0m----------
Dism /Online /Cleanup-Image /StartComponentCleanup
echo For detailed logs, check "%windir%\Logs\DISM\dism.log".
echo ----------------------------------------
goto :EOF

:Dism_Online_Cleanup_Image
echo ----------%ESC%[30;47mChecking system image%ESC%[0m----------
Dism /Online /Cleanup-Image /ScanHealth
echo For detailed logs, check "%windir%\Logs\DISM\dism.log".
echo ----------%ESC%[30;47mRepairing system image%ESC%[0m----------
Dism /Online /Cleanup-Image /Restorehealth
echo For detailed logs, check "%windir%\Logs\DISM\dism.log".
echo ----------------------------------------
goto :EOF

:Dism_Cleanup_Mountpoints
echo ----------%ESC%[30;47mHandling corrupted mount points%ESC%[0m----------
Dism /Cleanup-Mountpoints
echo For detailed logs, check "%windir%\Logs\DISM\dism.log".
echo ----------------------------------------
goto :EOF

:Sfc_Scannow
echo ----------%ESC%[30;47mChecking and repairing system files%ESC%[0m----------
sfc /scannow
echo For detailed logs, check "%windir%\Logs\CBS\CBS.log".
echo ----------------------------------------
goto :EOF

:Exit
exit