chcp 866
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\AD_Groups.txt") do (
echo Members of %%I & echo.
dsquery group -name "%%I" | dsget group -members -expand 
echo.) >> %USERPROFILE%\AD_result.txt
pause