@echo off
chcp 866
setlocal EnableDelayedExpansion
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\AD_Groups.txt") do (
dsquery group -name %%I
dsquery group -name %%I | dsget group -members
echo.) >> %USERPROFILE%\AD_result.txt

FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%USERPROFILE%\AD_result.txt") do (
dsget group %%I -samid
if ERRORLEVEL 0 (
echo.
dsget group %%I -members | dsget user -samid | find /V "samid" | find /V "dsget" | sort
echo.
) ELSE (
dsget user %%I -samid | find /V "samid" | find /V "dsget" | sort
echo.
) 
) >> %USERPROFILE%\AD_samid.txt

