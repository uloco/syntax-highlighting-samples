@echo off

rem Simple batch script
echo Simple batch script > a.out

IF "%IDEA_JDK%" == "" SET IDEA_JDK=%JDK_HOME%

SET JAVA_EXE=%IDEA_JDK%\jre\bin\java.exe
IF NOT EXIST "%JAVA_EXE%" goto error

SET IDEA_HOME=..
SET ACC=
SET VERSION=9800.35
SET BRACKET=[]
SET JVM_ARGS=%ACC% %REQUIRED_IDEA_JVM_ARGS%
SET PATH=%IDEA_HOME%\bin;%PATH%

FOR /F "delims=" %%i in (%IDEA_HOME%\bin\idea.exe.vmoptions) DO call %IDEA_HOME%\bin\append.bat "%%i"

REM Reset variables
FOR %%A IN (1 10 100) DO SET ERR%%A=

IF ERRORLEVEL 255 GOTO Label255

echo time > a.out
echo time > echo

goto end

:error
echo ---------------------------------------------------------------------
echo ERROR: cannot start IntelliJ IDEA.
echo No JDK found to run IDEA. Please validate either IDEA_JDK or JDK_HOME points to valid JDK installation
echo ---------------------------------------------------------------------
pause
:end

