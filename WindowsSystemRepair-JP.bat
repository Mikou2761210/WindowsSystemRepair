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
title Windowsシステム修復

:: 管理者権限で実行されているかチェック
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 管理者権限が必要です。再実行します...
    powershell -Command "try { Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs -ErrorAction Stop } catch { echo ユーザーがキャンセルしました。 }"
    exit
)

::フォント色変更用
for /f %%i in ('cmd /k prompt $e^<nul') do set ESC=%%i

echo Windowsシステム修復
echo バージョン 1.0 (2025年2月14日リリース)
echo ミコウ 作  (https://github.com/Mikou2761210)
echo プロジェクトページ: https://github.com/Mikou2761210/WindowsSystemRepair
echo 配布ページ: https://github.com/Mikou2761210/WindowsSystemRepair/releases
echo.
echo このバッチファイルを使用することによる問題については一切責任を負いません。
echo 使用は自己責任で行ってください。

:Re
echo.
echo =選択肢======================
echo 0: 終了
echo 1: システムファイルのチェックと修復
echo 2: システムイメージのチェックと修復
echo 3: システムデータのクリーンアップ
echo 4: 破損したマウントポイントの処理
echo 5: 全自動 (1→2→3→4→1)
echo 6: ヘルプ
echo =============================
choice /c 0123456 /n /m "0~6の数字を入力してください。"
if errorlevel 7 goto :Help
call :Warning
if errorlevel 6 (call :Auto & goto :End)
if errorlevel 5 (call :Dism_Cleanup_Mountpoints & goto :End)
if errorlevel 4 (call :Dism_Online_Cleanup_Image_StartComponentCleanup & goto :End)
if errorlevel 3 (call :Dism_Online_Cleanup_Image & goto :End)
if errorlevel 2 (call :Sfc_Scannow & goto :End)
if errorlevel 1 (call :Exit & goto :End)

:End
echo ----------%ESC%[36m修復が完了しました。%ESC%[0m----------
echo ----------キーを押して選択画面に戻ります。----------
pause
goto :Re

:Warning
echo.
echo ----------%ESC%[31m作業が完了するまでコマンドプロンプトを閉じないでください。%ESC%[0m----------
echo ----------%ESC%[31m(不具合の原因になる可能性があります)%ESC%[0m----------
echo.
goto :EOF


:Help
echo このbatファイルはWindowsの修復コマンドを使用しています。
echo システムファイルのチェックと修復 : sfc /scannow
echo システムイメージのチェックと修復 : Dism /Online /Cleanup-Image /ScanHealth  ,  Dism /Online /Cleanup-Image /Restorehealth
echo システムデータのクリーンアップ : Dism /Online /Cleanup-Image /StartComponentCleanup
echo 破損したマウントポイントの処理 : Dism /Cleanup-Mountpoints
echo 全自動 : 1~4のコマンドを適切な順番で呼び出します。
echo ----------キーを押して選択画面に戻ります。----------
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
echo ----------%ESC%[30;47mシステムデータのクリーンアップ%ESC%[0m----------
Dism /Online /Cleanup-Image /StartComponentCleanup
echo 詳細なログは"%windir%\Logs\DISM\dism.log"を参照してください。
echo ----------------------------------------
goto :EOF

:Dism_Online_Cleanup_Image
echo ----------%ESC%[30;47mシステムイメージのチェック%ESC%[0m----------
Dism /Online /Cleanup-Image /ScanHealth
echo 詳細なログは"%windir%\Logs\DISM\dism.log"を参照してください。
echo ----------%ESC%[30;47mシステムイメージの修復%ESC%[0m----------
Dism /Online /Cleanup-Image /Restorehealth
echo 詳細なログは"%windir%\Logs\DISM\dism.log"を参照してください。
echo ----------------------------------------
goto :EOF


:Dism_Cleanup_Mountpoints
echo ----------%ESC%[30;47m破損したマウントポイントの処理%ESC%[0m----------
Dism /Cleanup-Mountpoints
echo 詳細なログは"%windir%\Logs\DISM\dism.log"を参照してください。
echo ----------------------------------------
goto :EOF


:Sfc_Scannow
echo ----------%ESC%[30;47mシステムファイルのチェックと修復%ESC%[0m----------
sfc /scannow
echo 詳細なログは"%windir%\Logs\CBS\CBS.log"を参照してください。
echo ----------------------------------------
goto :EOF

:Exit
exit