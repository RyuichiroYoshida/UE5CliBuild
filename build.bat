@REM 文字コード設定
chcp 65001 > nul

@REM 変数の定義
set BUILD_TOOL_PATH="UEのエディターのフォルダ内に格納されてる"
set PROJECT_PATH="プロジェクトのフォルダパス"
set VS_MS_BUILD_PATH="VSのMSBuildのパス"
set BUILD_BATCH_PATH="ビルドバッチファイルのパス"
set EXPORT_PATH="G:\その他のパソコン\マイ コンピュータ\Artifacts\Team2024\TeamD"
set GAS_URI="GASのURI"

call :setup
@REM UEプロジェクトをビルド、コンパイル、パッケージングするコマンド
"%BUILD_BATCH_PATH%" BuildCookRun -rocket -compile -compileeditor -installed -nop4 -project="%PROJECT_PATH%\TeamD.uproject" -cook -stage -archive -archivedirectory="%PROJECT_PATH%\temp\Development\x64" -package -clientconfig=Shipping -ue5exe=UnrealEditor-Cmd.exe -clean -pak -prereqs -nodebuginfo -targetplatform=Win64 -build -utf8output

move /Y "%PROJECT_PATH%\TeamA.zip" %EXPORT_PATH%
if not %errorlevel% == 0 (
	exit /b 1
)

curl %GAS_URI%


@REM Build前準備サブルーチン
: setup
@REM 環境をクリーンにする
if exist "%PROJECT_PATH%" (
    rmdir /s /q "%PROJECT_PATH%"
)

@REM UnrealBuildToolを実行して、プロジェクトのソリューションファイルを生成
"%BUILD_TOOL_PATH%" -projectfiles -project="%PROJECT_PATH%\TeamD.uproject" -game -rocket -progress

@REM VSのMSBuildツールを実行して、指定したソリューションファイルでプロジェクトをビルド
"%VS_MS_BUILD_PATH%" "%PROJECT_PATH%\TeamD.sln" /t:build /p:Configuration="Development Editor";Platform=Win64;verbosity=diagnostic

exit /b