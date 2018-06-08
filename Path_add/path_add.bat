@echo off
:: ========================= Path Configuration ==============================
call path_config.bat

:: set regpath_=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
:: set evname_=Path
:: set pathname_=MySQL
:: set path_=C:\Program Files\MySQL\MySQL Server 5.7\bin
echo ======================= Path Configuration ================================
echo The registry path is:
echo %regpath_%
echo The %pathname_% path is:
echo %path_%
echo The environment name is:      
echo ฮารว%evname_%

:: ========================= Add Path ==============================
for /f "tokens=1,2,* delims= " %%a in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %evname_%') do (
    set pathall_=%%c
)
echo The initial value in %evname_% is:
echo %pathall_%|find /i "%path_%" && set isnull=false || set isnull=true && echo %pathall_%
echo ======================= State ================================
if %isnull%==true (
    reg add "%regpath_%" /v %evname_% /d "%pathall_%;%path_%" /f
    echo The path has been saved successfully!
    echo The new value in %evname_% is:
    echo "%pathall_%;%path_%"
) else (
    echo The path has exists!
)

pause