@echo off
echo ���²�����ɾ�����ݿ����ݣ�����
echo �Ƿ�������س��Լ���
pause>nul
echo.
set MYSQL_HOME=%~dp0
cd %MYSQL_HOME%
net stop mysql 1> nul 2> nul && echo MySQLֹͣ����ɹ��� || echo MySQLδ������
sc delete mysql 1> nul 2> nul && echo MySQL�ɹ�ɾ���� || echo MySQLδ��װ��
taskkill /F /IM mysqld.exe 2> nul
del /F my.ini 1> nul 2> nul && echo MySQL�����ļ��ɹ�ɾ���� || echo  MySQL�����ļ�������!
rd /s /q data 1> nul 2> nul && echo MySQL dataɾ���ɹ��� || echo MySQL data�����ڣ�
