@echo off
setlocal EnableDelayedExpansion
call set Desk=\\0002sibvdi-fs01.rosneft.ru\VDI-Desktop\%username%\Desktop
cls
echo "Script otdela ocenki"
call set /p project="Imya projecta: "
if NOT EXIST "%Desk%\%project%" (
echo "Sozdanie papki %project%"
mkdir "%Desk%\%project%"
) ELSE (
echo Papka %project% suschestvuet
)
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%Desk%\PSO_check.txt") do (
echo PSO of  "%%I" & echo.
dsquery user -name "%%I" | dsget user -effectivepso | find /V "effectivepso" | find /v "dsget"
)
pause