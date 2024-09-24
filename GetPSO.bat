chcp 866
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\PSOcheck.txt") do (
echo PSO of  %%I & echo.
dsquery user -samid "%%I" | dsget user -effectivepso | find /V "effectivepso" | find /v "dsget"
echo.) >> %USERPROFILE%\PSO_result.txt
pause
