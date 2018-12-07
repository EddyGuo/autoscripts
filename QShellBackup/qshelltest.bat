@echo off
chcp 65001
::==================LOGIN===========================
:ACCOUNT
set /P account=Account: 
::echo %account%
if "%account%"=="" goto ACCOUNT
:PASSWORD
set /P password=Password: 
if "%password%"=="" goto PASSWORD

qrsctl login %account% %password%
qrsctl info>temp

for /F "delims=" %%a in (temp) do (
    if "%%a"=="User info not provided" (
	    echo =====LOGIN FAILED!=====
		set account=>nul
		set password=>nul
		goto ACCOUNT
	)
)


echo =====LOGIN SUCCESSFULLY!=====
qrsctl appinfo>temp

for /F "tokens=1,* delims=:" %%a in ('find "AccessKey:" temp') do (
    set AccessKey=%%b
)

for /F "tokens=1,* delims=:" %%a in ('find "SecretKey:" temp') do (
    set SecretKey=%%b
)

echo AccessKey: %AccessKey%
echo SecretKey: %SecretKey%

::=============================================
qshell account %AccessKey% %SecretKey% %account%

for /F "delims=" %%i in (bucketlist.txt) do (
    qshell.bat %%i
)

del /F temp
pause