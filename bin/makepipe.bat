rem #! /bin/bash

rem %1 is the application
rem %2 is the script directory
rem %3 is the pow root directory
rem %4 is the file to run


set APP=%1
set RUNDIR=%2
set ROOT=%3
set FILE=%4


echo %APP% %RUNDIR% %ROOT% %FILE% >> %ROOT%/pow/log/access.txt

cd "%RUNDIR%"
set REDIRECT_STATUS="200"
set SCRIPT_NAME=%FILE%
set SCRIPT_FILENAME=%FILE%

echo %POST_STRING% | "%APP%" > %ROOT%/pow/data/powpipe.txt 2>> %ROOT%/pow/log/error.txt

rem type %ROOT%/pow/data/pipe
rem @pause
exit 0

