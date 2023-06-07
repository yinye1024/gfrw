@echo off

set "GAME_ROOT_DIR=%~dp0..\..\"
set "SCRIPTS_DIR=%GAME_ROOT_DIR%\scripts"

set "ES_SCRIPT_FILE=%SCRIPTS_DIR%\es\es_game"

set "param=%1"


if "%param%"=="start" (
    goto :start_server
)else if "%param%"=="stop" (
    goto :stop_server
)  else if "%param%"=="live" (
    goto :live_server
)  else if "%param%"=="attach" (
     goto :attach
 ) else (
    echo Invalid parameter.
)
:start_server
echo Starting server...
escript "%ES_SCRIPT_FILE%" D:\allen_github\yinye1024\gfrw\proj\game start
exit /b

:stop_server
echo Stoping server...
escript "%ES_SCRIPT_FILE%" D:\allen_github\yinye1024\gfrw\proj\game stop
exit /b

:live_server
echo attach server...
for /f "delims=" %%t in ('escript "%ES_SCRIPT_FILE%" D:\allen_github\yinye1024\gfrw\proj\game live') do (
echo %%t
%%t
)
exit /b


:attach
echo attach server...
for /f "delims=" %%t in ('escript "%ES_SCRIPT_FILE%" D:\allen_github\yinye1024\gfrw\proj\game attach') do (
echo %%t
%%t
)
exit /b


