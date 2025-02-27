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
chcp 932 >nul
title Windows�V�X�e���C��

:: �Ǘ��Ҍ����Ŏ��s����Ă��邩�`�F�b�N
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo �Ǘ��Ҍ������K�v�ł��B�Ď��s���܂�...
    powershell -Command "try { Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs -ErrorAction Stop } catch { echo ���[�U�[���L�����Z�����܂����B }"
    exit
)

::�t�H���g�F�ύX�p
for /f %%i in ('cmd /k prompt $e^<nul') do set ESC=%%i

echo Windows�V�X�e���C��
echo �o�[�W���� 1.0 (2025�N2��14�������[�X)
echo �~�R�E ��  (https://github.com/Mikou2761210)
echo �v���W�F�N�g�y�[�W: https://github.com/Mikou2761210/WindowsSystemRepair
echo �z�z�y�[�W: https://github.com/Mikou2761210/WindowsSystemRepair/releases
echo.
echo ���̃o�b�`�t�@�C�����g�p���邱�Ƃɂ����ɂ��Ă͈�ؐӔC�𕉂��܂���B
echo �g�p�͎��ȐӔC�ōs���Ă��������B

:Re
echo.
echo =�I����======================
echo 0: �I��
echo 1: �V�X�e���t�@�C���̃`�F�b�N�ƏC��
echo 2: �V�X�e���C���[�W�̃`�F�b�N�ƏC��
echo 3: �V�X�e���f�[�^�̃N���[���A�b�v
echo 4: �j�������}�E���g�|�C���g�̏���
echo 5: �S���� (1��2��3��4��1)
echo 6: �w���v
echo =============================
choice /c 0123456 /n /m "0~6�̐�������͂��Ă��������B"
if errorlevel 7 goto :Help
call :Warning
if errorlevel 6 (call :Auto & goto :End)
if errorlevel 5 (call :Dism_Cleanup_Mountpoints & goto :End)
if errorlevel 4 (call :Dism_Online_Cleanup_Image_StartComponentCleanup & goto :End)
if errorlevel 3 (call :Dism_Online_Cleanup_Image & goto :End)
if errorlevel 2 (call :Sfc_Scannow & goto :End)
if errorlevel 1 (call :Exit & goto :End)

:End
echo ----------%ESC%[36m�C�����������܂����B%ESC%[0m----------
echo ----------�L�[�������đI����ʂɖ߂�܂��B----------
pause
goto :Re

:Warning
echo.
echo ----------%ESC%[31m��Ƃ���������܂ŃR�}���h�v�����v�g����Ȃ��ł��������B%ESC%[0m----------
echo ----------%ESC%[31m(�s��̌����ɂȂ�\��������܂�)%ESC%[0m----------
echo.
goto :EOF


:Help
echo ����bat�t�@�C����Windows�̏C���R�}���h���g�p���Ă��܂��B
echo �V�X�e���t�@�C���̃`�F�b�N�ƏC�� : sfc /scannow
echo �V�X�e���C���[�W�̃`�F�b�N�ƏC�� : Dism /Online /Cleanup-Image /ScanHealth  ,  Dism /Online /Cleanup-Image /Restorehealth
echo �V�X�e���f�[�^�̃N���[���A�b�v : Dism /Online /Cleanup-Image /StartComponentCleanup
echo �j�������}�E���g�|�C���g�̏��� : Dism /Cleanup-Mountpoints
echo �S���� : 1~4�̃R�}���h��K�؂ȏ��ԂŌĂяo���܂��B
echo ----------�L�[�������đI����ʂɖ߂�܂��B----------
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
echo ----------%ESC%[30;47m�V�X�e���f�[�^�̃N���[���A�b�v%ESC%[0m----------
Dism /Online /Cleanup-Image /StartComponentCleanup
echo �ڍׂȃ��O��"%windir%\Logs\DISM\dism.log"���Q�Ƃ��Ă��������B
echo ----------------------------------------
goto :EOF

:Dism_Online_Cleanup_Image
echo ----------%ESC%[30;47m�V�X�e���C���[�W�̃`�F�b�N%ESC%[0m----------
Dism /Online /Cleanup-Image /ScanHealth
echo �ڍׂȃ��O��"%windir%\Logs\DISM\dism.log"���Q�Ƃ��Ă��������B
echo ----------%ESC%[30;47m�V�X�e���C���[�W�̏C��%ESC%[0m----------
Dism /Online /Cleanup-Image /Restorehealth
echo �ڍׂȃ��O��"%windir%\Logs\DISM\dism.log"���Q�Ƃ��Ă��������B
echo ----------------------------------------
goto :EOF


:Dism_Cleanup_Mountpoints
echo ----------%ESC%[30;47m�j�������}�E���g�|�C���g�̏���%ESC%[0m----------
Dism /Cleanup-Mountpoints
echo �ڍׂȃ��O��"%windir%\Logs\DISM\dism.log"���Q�Ƃ��Ă��������B
echo ----------------------------------------
goto :EOF


:Sfc_Scannow
echo ----------%ESC%[30;47m�V�X�e���t�@�C���̃`�F�b�N�ƏC��%ESC%[0m----------
sfc /scannow
echo �ڍׂȃ��O��"%windir%\Logs\CBS\CBS.log"���Q�Ƃ��Ă��������B
echo ----------------------------------------
goto :EOF

:Exit
exit