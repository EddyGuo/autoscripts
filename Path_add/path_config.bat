for /f "tokens=1,* delims==" %%i in ('find "regpath_" path_config.ini') do (
    set regpath_=%%j
)
for /f "tokens=1,* delims==" %%i in ('find "evname_" path_config.ini') do (
    set evname_=%%j
)
for /f "tokens=1,* delims==" %%i in ('find "pathname_" path_config.ini') do (
    set pathname_=%%j
)
for /f "tokens=1,* delims==" %%i in ('find "path_" path_config.ini') do (
    set path_=%%j
)