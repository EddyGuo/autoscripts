@echo off
:: ======================================= 卸载MySQL ========================================================
call mysql卸载.bat
echo MySQL卸载成功！

:: ======================================= MySQL配置 ========================================================
echo ========================== MySQL配置信息 ===================================
set server_port=3306
echo server_port=%server_port%
set password=123456
echo password=%password%
set database=dpvr
echo database=%database%
set table="use %database%;create table E3C(SN varchar(20) not null,Type int,Date datetime,ARMVersion bigint,CalGyroX double,CalGyroY double,CalGyroZ double,MagScale1 float,MagScale2 float,MagScale3 float,AcceX float,AcceY float,AcceZ float,GyroX double,GyroY double,GyroZ double,SNVer bigint,VIREPCBAVer bigint,VIRECALVer bigint,VIREVer bigint,MagVer bigint,CalGyroVer bigint,SensorVer bigint,LensVer bigint,SNDate datetime,VIREPCBADate datetime,VIRECALDate datetime,VIREDate datetime,MagDate datetime,CalGyroDate datetime,SensorDate datetime,LensDate datetime,SNFailed smallint,VIREPCBAFailed smallint,VIRECALFailed smallint,VIREFailed smallint,MagFailed smallint,CalGyroFailed smallint,SensorFailed smallint,LensFailed smallint,comment1 VARCHAR(1000),comment2 VARCHAR(1000),primary key(SN));"

set MYSQL_HOME=%~dp0
echo MYSQL_HOME=%MYSQL_HOME%
echo server_port=%server_port%

:: ======================================= MySQL路径配置 ========================================================
set regpath_=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
set evname_=Path
set pathname_=MySQL
set path_=%MYSQL_HOME%bin

echo ======================= MySQL路径配置 ================================
echo 注册表路径为：
echo %regpath_%
echo MySQL路径为：
echo %path_%
echo 环境变量名为：      
echo %evname_%

:: ========================= 添加路径 ==============================
for /f "tokens=1,2,* delims= " %%a in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %evname_%') do (
    set pathall_=%%c
)
echo %evname_%的初始值为：
echo %pathall_%|find /i "%path_%" && set isnull=false || set isnull=true && echo %pathall_%
echo ======================= 路径添加状态 ================================
if %isnull%==true (
    reg add "%regpath_%" /v %evname_% /d "%pathall_%;%path_%" /f
	echo 成功保存路径！
	echo %evname_%的新值为：
    echo "%pathall_%;%path_%"
) else (
	echo 路径已存在！
)

::=============================生成my.ini===============================
echo ====================== 安装MySQL==============================
cd %MYSQL_HOME%
echo [mysql] >> my.ini
echo default-character-set=utf8 >> my.ini
echo [mysqld] >> my.ini
echo port=%server_port% >> my.ini
echo basedir=%MYSQL_HOME% >> my.ini
echo datadir=%MYSQL_HOME%data >> my.ini
echo max_connections=200 >> my.ini
echo character-set-server=utf8 >> my.ini
echo default-storage-engine=INNODB >> my.ini
echo my.ini配置文件生成成功

::============================安装MySQL================================
cd %MYSQL_HOME%bin
echo 正在安装MySQL，请稍等...
mysqld --initialize
mysqld install
echo 安装成功！
net stop mysql
cd %MYSQL_HOME%
echo skip-grant-tables >> my.ini
taskkill /F /IM mysqld.exe
net start mysql
cd %MYSQL_HOME%bin
mysql -e "use mysql"
mysql -e "update mysql.user set authentication_string=password(%password%) where user='root';"
mysql -e "flush privileges;"
cd %MYSQL_HOME%
echo [client] >> my.ini
echo user=root >> my.ini
echo password=%password% >> my.ini
cd %MYSQL_HOME%bin
mysql --connect-expired-password -e "SET PASSWORD = PASSWORD('%password%');"
mysql -e "create database %database%;"
mysql -e %table%
echo 创建表成功！
pause