@echo off
set regpath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
set evname=Path
set pathname=MySQL
set path_=C:\Program Files\MySQL\MySQL Server 5.7\bin

echo The %pathname% path is:
echo %path_%
echo The environment name is:      
echo %evname%

:: 获取变量初始值
for /f "tokens=1,2,* delims= " %%a in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %evname%') do (
    set pathall_=%%c
)
echo The initial value in %evname% is:
:: 判断初始值中是否已存在该值
echo %pathall_%|find /i "%path_%" && set isnull=false || set isnull=true && echo %pathall_%
echo -----------------------------------------------------------------------
if %isnull%==true (
    reg add "%regpath%" /v %evname% /d "%pathall_%;%path_%" /f
    echo The path has been saved successfully!
    echo The new value in %evname% is:
    echo "%pathall_%;%path_%"
) else (
    echo The path has exists!
)
echo -----------------------------------------------------------------------
pause