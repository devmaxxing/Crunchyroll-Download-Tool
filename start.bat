@ECHO off

rem Crunchyroll Export Script DX - Last Updated 2013/10/15
rem Removes need for rtmpExplorer
rem ORIGINAL SOURCE - http://www.darkztar.com/forum/showthread.php?219034-Ripping-videos-amp-subtitles-from-Crunchyroll-%28noob-friendly%29

:SETUP

	ECHO.
	ECHO --------------------------
	ECHO ---- Start New Export ----
	ECHO --------------------------
	ECHO.
	ECHO CrunchyRoll Downloader Toolkit DX v0.98
	ECHO.
	ECHO Crunchyroll hasn't changed anything. 
	ECHO.
	ECHO If you don't have a premium account, go and sign up for one now. It's well worthit, and supports the animators.
	ECHO.
	ECHO ----------
	ECHO.
	"crunchy-xml-decoder\login.py" %1 %2
GOTO STEP1-GETVIDEO

:STEP1-GETVIDEO

	SET currentpath=%~dp0

	IF "%3"=="" GOTO Enter-URL
		SET video_url=%3
		GOTO Continue

	:Enter-URL
		ECHO Please Enter CrunchyRoll Video URL
		SET /p video_url=
		GOTO Continue

	:Continue
	ECHO.

	".\crunchy-xml-decoder\ultimate.py" %video_url%
	IF NOT EXIST *.flv (GOTO ERROR)

	ECHO Video and subtitle files should now have been downloaded.

	ECHO Moving to export folder...

	FOR /F "delims=|" %%I IN ('DIR "%~dp0\*.flv" /B /O:D') DO SET NewestVideo=%%I
	MOVE /Y "%~dp0\%NewestVideo%" ".\export\"

	SET showname=%NewestVideo%
	SET showname=%showname:.flv=%

	ECHO.
	ECHO ----------
	ECHO.
	ECHO.

GOTO STEP2-SPLITVIDEO

:STEP2-SPLITVIDEO

	ECHO Starting flv video split

	".\video-engine\FLVExtractCL.exe" -v -a -t -o ".\export\%showname%.flv"

	ECHO Video Split Complete

	ECHO.
	ECHO ----------
	ECHO.
	ECHO.

GOTO STEP3-MAKEMKV

:STEP3-MAKEMKV

	ECHO Starting mkv merge
	IF NOT EXIST ".\export\%showname%.ass" (
	"video-engine\mkvmerge.exe" -o ".\export\%showname%.mkv" ".\export\%showname%.264" --aac-is-sbr 0 ".\export\%showname%.aac"
	) ELSE (
	"video-engine\mkvmerge.exe" -o ".\export\%showname%.mkv" ".\export\%showname%.ass" ".\export\%showname%.264" --aac-is-sbr 0 ".\export\%showname%.aac"
	)

	ECHO Merge process complete

	ECHO.
	ECHO ----------
	ECHO.
	ECHO.

GOTO STEP4-CLEANUP

:STEP4-CLEANUP

	ECHO Starting Final Cleanup

	DEL /q ".\export\%showname%.aac" ".\export\%showname%.264" ".\export\%showname%.flv" ".\export\%showname%.txt" ".\export\%showname%.ass"

	ECHO Cleanup Complete

	ECHO.
	ECHO ----------
	ECHO.
	ECHO.

	ECHO ****** Job completed successfully *****
	ECHO.
	EXIT
rem	PAUSE


:ERROR

	ECHO An error has occured. Please check "error.log" for the affected page url.