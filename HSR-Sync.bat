@echo off
color 0a

REM it starts to mount bei Z:
REM net use :U \\c206.hsr.ch\skripte /u:hsr.ch\USERNAME

REM change cygwin to cygwin64 if you have an 64bit machine
REM chdir C:\cygwin\bin

REM change \wherever\your\file\is\downloaded to wherever your script is
REM bash --login -i C:\wherever\your\file\is\downloaded

REM net use U: /delete

@echo off
setlocal
 
if not exist "%~dpn0.sh" echo Script "%~dpn0.sh" not found & exit 2

set _CYGBIN=C:\cygwin64\bin
if not exist "%_CYGBIN%" set _CYGBIN=C:\cygwin\bin
if not exist "%_CYGBIN%" echo Couldn't find Cygwin at "%_CYGBIN%" 
 
:: Resolve ___.sh to /cygdrive based *nix path and store in %_CYGSCRIPT%
for /f "delims=" %%A in ('%_CYGBIN%\cygpath.exe "%~dpn0.sh"') do set _CYGSCRIPT=%%A
 
:: Throw away temporary env vars and invoke script, passing any args that were passed to us
endlocal & %_CYGBIN%\bash --login "%_CYGSCRIPT%" %*
