chcp 866
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\AD_result.txt") do (
dsget group %%I -samid | find /V "samid" | find /V "dsget" 
IF ERRORLEVEL 1 echo %%I && echo.
dsget user %%I -samid | find /V "samid" | find /V "dsget"
)>>"%USERPROFILE%\AD_samid.txt"
pause