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
timeout 2 > NUL
)
cls
:MENU_START
echo Vyberite script kotoriy hotite:
echo 1. Vygruzit gruppy iz AD vmeste s vlozhennymi
echo 2. Vygruzit parolnuyu politiku dlya UZ
echo 3. VYHOD
call set /p punkt="Vyberite punkt: "
IF %punkt%==1 GOTO OPTION1
IF %punkt%==2 GOTO OPTION2
IF %punkt%==3 GOTO OPTION3

echo Vy vibrali nepravilny nomer
timeout 5 > NUL
GOTO MENU_START

:OPTION1
cls
echo Vygruzka chlenov grupp
echo Pered startom ubedites chto AD_Groups.txt suschestvuet in %Desk%
if EXIST "%Desk%\AD_Groups.txt" (
echo File suschestvuet
timeout 5 > NUL
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%Desk%\AD_Groups.txt") do (
dsquery group -samid "%%I"
dsquery group -samid "%%I" | dsget group -members
) >> %Desk%\%project%\%project%_AD_result.txt
if EXIST %Desk%\%project%\%project%_AD_samid.txt (
del %Desk%\%project%\%project%_AD_samid.txt)
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%Desk%\%project%\%project%_AD_result.txt") do (
dsget group %%I -samid | find /V "samid" | find /V "dsget"
if ERRORLEVEL 0 (
echo.
dsget group %%I -members | dsget user -samid | find /V "samid" | find /V "dsget" | sort
echo.
) ELSE (
echo.
dsget user %%I -samid | find /V "samid" | find /V "dsget" | sort
echo.
) 
) >> %Desk%\%project%\%project%_AD_samid.txt
date /t >> %Desk%\%project%\%project%_AD_samid.txt
time /t >> %Desk%\%project%\%project%_AD_samid.txt
del %Desk%\%project%\%project%_AD_result.txt
cls
echo Zaberite resultat v %Desk%\%project%\%project%_AD_samid
timeout 5 > NUL
notepad %Desk%\%project%\%project%_AD_samid.txt
GOTO MENU_START
) else (
echo file ne suschestvuet, sozdaite file
timeout 5 > NUL
GOTO MENU_START
)

:OPTION2
cls
echo Vygruzka parolnoi politiki dlya UZ
echo Pered startom ubedites chto PSO_check.txt suschestvuet v %Desk%
if EXIST "%Desk%\PSO_check.txt" (
echo File exist
timeout 5 > NUL
if EXIST %Desk%\%project%\%project%_PSO_result.txt (
del %Desk%\%project%\%project%_PSO_result.txt)
FOR /F "usebackq eol=$ tokens=* delims=" %%I in ("%Desk%\PSO_check.txt") do (
dsquery user -samid "%%I" | findstr /R "CN=" >nul
if errorlevel 1 (
echo "%%I" ne sozdana v AD
echo .
) else (
echo PSO of  "%%I" & echo.
dsquery user -samid "%%I" | dsget user -effectivepso | find /V "effectivepso" | find /v "dsget"
IF ERRORLEVEL 1 (
echo.
dsquery user -samid "%%I"
echo.
)
echo.) 
) >> %Desk%\%project%\%project%_PSO_result.txt 2>&1
date /t >> %Desk%\%project%\%project%_PSO_result.txt
time /t >> %Desk%\%project%\%project%_PSO_result.txt
cls
echo Zaberite resultat v %Desk%\%project%\%project%_PSO_result
timeout 5 > NUL
notepad %Desk%\%project%\%project%_PSO_result.txt
GOTO MENU_START
) else (
echo file ne suschestvuet, sozdaite
timeout 5 > NUL
GOTO MENU_START
)

:OPTION3
cls
echo Poka, poka
timeout 5 > NUL
exit /b

