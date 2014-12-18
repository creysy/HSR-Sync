@echo off

color 0a

REM change cygwin to cygwin64 if you have an 64bit machine
chdir C:\cygwin\bin

REM change \wherever\your\file\is\downloaded to wherever your script is
bash --login -i C:\wherever\your\file\is\downloaded