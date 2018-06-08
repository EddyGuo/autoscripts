@echo off
set MYSQL_HOME=%~dp0
cd %MYSQL_HOME%
:: ======================================= ��Ⲣж��MySQL ========================================================
echo ����Ƿ��Ѱ�װ���ļ�����MySQL...
call mysqlж��.bat
:: ======================================= MySQL���� ========================================================
echo ========================== MySQL������Ϣ ===================================
set server_port=3306
echo server_port=%server_port%
set password=123456
echo password=%password%
set database=dpvr
echo database=%database%
set table="use %database%;create table E3C(SN varchar(20) not null,Type int,Date datetime,ARMVersion bigint,CalGyroX double,CalGyroY double,CalGyroZ double,MagScale1 float,MagScale2 float,MagScale3 float,AcceX float,AcceY float,AcceZ float,GyroX double,GyroY double,GyroZ double,SNVer bigint,VIREPCBAVer bigint,VIRECALVer bigint,VIREVer bigint,MagVer bigint,CalGyroVer bigint,SensorVer bigint,LensVer bigint,SNDate datetime,VIREPCBADate datetime,VIRECALDate datetime,VIREDate datetime,MagDate datetime,CalGyroDate datetime,SensorDate datetime,LensDate datetime,SNFailed smallint,VIREPCBAFailed smallint,VIRECALFailed smallint,VIREFailed smallint,MagFailed smallint,CalGyroFailed smallint,SensorFailed smallint,LensFailed smallint,comment1 VARCHAR(1000),comment2 VARCHAR(1000),primary key(SN));"

echo MYSQL_HOME=%MYSQL_HOME%
echo server_port=%server_port%

:: ======================================= MySQL·������ ========================================================
set regpath_=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
set evname_=Path
set pathname_=MySQL
set path_=%MYSQL_HOME%bin

echo ======================= MySQL·������ ================================
echo ע���·��Ϊ��
echo %regpath_%
echo MySQL·��Ϊ��
echo %path_%
echo ����������Ϊ��      
echo %evname_%

::=============================����my.ini===============================
echo ====================== ��װMySQL==============================
echo [mysql] >> my.ini
echo default-character-set=utf8 >> my.ini
echo [mysqld] >> my.ini
echo port=%server_port% >> my.ini
echo basedir=%MYSQL_HOME% >> my.ini
echo datadir=%MYSQL_HOME%data >> my.ini
echo max_connections=200 >> my.ini
echo character-set-server=utf8 >> my.ini
echo default-storage-engine=INNODB >> my.ini
echo my.ini�����ļ����ɳɹ���
echo.

::============================��װMySQL================================
cd %MYSQL_HOME%bin
echo ���ڰ�װMySQL�����Ե�...
mysqld --initialize
mysqld install
echo ��װ�ɹ���
net stop mysql 2> nul
cd %MYSQL_HOME%
echo skip-grant-tables >> my.ini
taskkill /F /IM mysqld.exe 2> nul

echo ====================== ��װ��������Ϣ =============================
net start mysql && goto USAGE || goto FAIL

:USAGE
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
echo ������ɹ���

cd %MYSQL_HOME%
del /F my.ini
echo [mysql] >> my.ini
echo default-character-set=utf8 >> my.ini
echo [mysqld] >> my.ini
echo port=%server_port% >> my.ini
echo basedir=%MYSQL_HOME% >> my.ini
echo datadir=%MYSQL_HOME%data >> my.ini
echo max_connections=200 >> my.ini
echo character-set-server=utf8 >> my.ini
echo default-storage-engine=INNODB >> my.ini

:: ========================= ���·�� ==============================
echo ========================== ���·�� ============================
for /f "tokens=1,2,* delims= " %%a in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %evname_%') do (
    set pathall_=%%c
)
echo %evname_%�ĳ�ʼֵΪ��
echo %pathall_%|find /i "%path_%" && set isnull=false || set isnull=true && echo %pathall_%
echo.
if %isnull%==true (
    reg add "%regpath_%" /v %evname_% /d "%pathall_%;%path_%" /f
	echo �ɹ�����·����
	echo %evname_%����ֵΪ��
    echo "%pathall_%;%path_%"
) else (
	echo ·���Ѵ��ڣ�
)
echo.
echo MySQL�ɹ���װ�����ã�
echo.
echo ===========================================================
echo =====================���������ԣ�����======================
echo ===========================================================
echo.
pause
goto EOF

:FAIL
echo ��װʧ�ܣ�
call mysqlж��.bat
echo ��װ�����������
echo.
echo ===============================================================================================
echo =====================�볢���Թ���Ա��ʽ���иĳ��򣬲�ȷ����data�ļ���ɾ��======================
echo ===============================================================================================
echo.
pause
goto EOF