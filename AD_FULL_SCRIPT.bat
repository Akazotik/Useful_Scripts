@echo off
chcp 866 
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\AD_Groups.txt") do (
echo Members_of_%%I & echo.
dsquery group -name "%%I" | dsget group -members -expand 
echo.) >> %USERPROFILE%\AD_result.txt
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\AD_result.txt") do (
dsget group %%I -samid | find /V "samid" | find /V "dsget" 
IF ERRORLEVEL 1 echo %%I && echo.
dsget user %%I -samid | find /V "samid" | find /V "dsget" | sort
)>>"%USERPROFILE%\AD_samid.txt"
