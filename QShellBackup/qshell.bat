@echo off
set bucket=%1
set bucketlist=%bucket%.txt
set bucket_namelist=%bucket%_name.txt
set bucketbackup=%bucket%backup
set config=%bucket%.conf

qshell listbucket %bucket%>%bucketlist%

if exist "%bucket_namelist%" (
    del /F %bucket_namelist%
)

for /F "tokens=1,* delims=	" %%a in (%bucketlist%) do (
    echo %%a>> %bucket_namelist%
)


qrsctl mkbucket2 %bucketbackup%
qrsctl private %bucketbackup% 0
qshell domains %bucketbackup%>temp
for /F "delims=" %%a in (temp) do (
    set domain=%%a
)

::set /P domain=<temp<nul
echo domain: %domain%

echo =========BACKUP==========
qshell batchcopy %bucket% %bucketbackup% -i %bucket_namelist%
mkdir %bucket%

(
echo {
echo     "dest_dir"   :   "%bucket%",
echo     "bucket"     :   "%bucketbackup%",
echo     "prefix"     :   "",
echo     "suffixes"   :   "",
echo     "cdn_domain" :   "http://%domain%",
echo     "referer"    :   "",
echo     "log_file"   :   "download.log",
echo     "log_level"  :   "info",
echo     "log_rotate" :   1,
echo     "log_stdout" :   false
echo }
)>%config%


qshell qdownload %config%


del /F %bucketlist%
echo =====%bucket% backup successfully!=====
echo Enter to confirm!
pause>nul
