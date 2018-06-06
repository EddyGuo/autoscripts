@echo off
set regpath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
set evname=Path
set mysqlpath=C:\Progy\MySQL Server 5.7

echo The path is:
echo %mysqlpath%
echo The environment name is:      
echo %evname%

:: 获取变量初始值
for /f "tokens=1,2,* delims= " %%a in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %evname%') do (
    set PathAll_=%%c
)
echo The initial value in %evname% is:
:: 判断初始值中是否已存在该值
echo %PathAll_%|find /i "%mysqlpath%" && set isnull=true || set isnull=false
echo -----------------------------------------------------------------------
if not %isnull%==true (
    reg add "%regpath%" /v %evname% /d "%PathAll_%;%mysqlpath%" /f
) else (
    echo This path has exists!
)

pause