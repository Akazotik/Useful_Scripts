chcp 866

setlocal EnableDelayedExpansion

call set /p project="Project Name: "

call set /p array="Groups List: "

FOR %%I in (!array!) do (

echo Members_of_%%I & echo.

dsquery group -name "%%I" | dsget group -members -expand

echo.) >> "%USERPROFILE%\%project%_result.txt"

FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\%project%_result.txt") do (

dsget group %%I -samid | find /V "samid" | find /V "dsget"

IF ERRORLEVEL 1 echo %%I && echo.

dsget user %%I -samid | find /V "samid" | find /V "dsget"

)>>"%USERPROFILE%\%project%_samid.txt"

DEL "%USERPROFILE%\%project%_result.txt"

FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\%project%_samid.txt") do (

call set str=%%I

call echo !str: =!

)>>"%USERPROFILE%\%project%_delspaces.txt"

pause

