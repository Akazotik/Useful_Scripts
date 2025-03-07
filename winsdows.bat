#Выгрузка групп

 

net localgroup Administrators

net localgroup "Remote Desktop Users"

net localgroup "Remote Management Users"

 

Для русской версии Windows

net localgroup Администраторы

net localgroup "Пользователи удаленного рабочего стола"

net localgroup "Пользователи удаленного управления"

 

#Парольная политика

net accounts

 

#Билеты Kerberos

gpupdate

klist

 

#Выгрузка User Rights Assigment (Параметры Allow log on..., Deny log on...)

secedit /export /areas USER_RIGHTS /cfg %USERPROFILE%\USER_RIGHTS.txt

Для перевода sid в имя групп

wmic group where 'SID="SID_группы"' get name

 

"SeInteractiveLogonRight" {"Allow log on locally"}

"SeRemoteInteractiveLogonRight" {"Allow log on through Remote Desktop Services"}

"SeDenyInteractiveLogonRight" {"Deny log on locally"}

"SeDenyRemoteInteractiveLogonRight" {"Deny log on through Remote Desktop Services"}

 

#Сетевая активность

netstat -anf | more

 

#Идентификация

dir C:\Program Files\Internet Explorer

tasklist | sort

 

#Матрица

auditpol /get /category:*

icacls C:\Windows

icacls C:\Windows\System32

icacls C:\Windows\System32\winevt\Logs

 

    разрешение - это маска разрешения, которая может задаваться в одной

    из двух форм:

        последовательность простых прав:

                N - доступ отсутствует

                F - полный доступ

                M - доступ на изменение

                RX - доступ на чтение и выполнение

                R - доступ только на чтение

                W - доступ только на запись

                D - доступ на удаление

        список отдельных прав через запятую в скобках:

                DE - удаление

                RC - чтение

                WDAC - запись DAC

                WO - смена владельца

                S - синхронизация

                AS - доступ к безопасности системы

                MA - максимально возможный

                GR - общее чтение

                GW - общая запись

                GE - общее выполнение

                GA - все общие

                RD - чтение данных, перечисление содержимого папки

                WD - запись данных, добавление файлов

                AD - добавление данных и вложенных каталогов

                REA - чтение дополнительных атрибутов

                WEA - запись дополнительных атрибутов

                X - выполнение файлов и обзор папок

                DC - удаление вложенных объектов

                RA - чтение атрибутов

                WA - запись атрибутов

        права наследования могут предшествовать любой форме и применяются

        только к каталогам:

                (OI) - наследование объектами

                (CI) - наследование контейнерами

                (IO) - только наследование

                (NP) - запрет на распространение наследования

                (I) - наследование разрешений от родительского контейнера

 

#Логи входа-выхода

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4624]][EventData[Data[@Name='TargetUserName]='ИМЯ_УЗ']]" /f:text

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4625]][EventData[Data[@Name='TargetUserName]='ИМЯ_УЗ']]" /f:text

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4634]][EventData[Data[@Name='TargetUserName]='ИМЯ_УЗ']]" /f:text

 

#Логи за 3 месяца

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4624]][System[TimeCreated[@SystemTime='2020-01-01T14:25:43Z']]]" /f:text

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4625]][System[TimeCreated[@SystemTime='2020-01-01T14:25:43Z']]]" /f:text

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4634]][System[TimeCreated[@SystemTime='2020-01-01T14:25:43Z']]]" /f:text

 

Время указывается в формате '2020-01-01T14:26:43Z'

 

#Логи запуска-завершения процесса

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4688]][EventData[Data[@Name='TargetUserName]='ИМЯ_УЗ']]" /f:text

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4689]][EventData[Data[@Name='TargetUserName]='ИМЯ_УЗ']]" /f:text

 

#Логи доступа до объектов

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4674]][EventData[Data[@Name='TargetUserName]='ИМЯ_УЗ']]" /f:text

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4656]][EventData[Data[@Name='TargetUserName]='ИМЯ_УЗ']]" /f:text

wevtutil qe Security /rd:true /c:1 /q:"*[System[EventID=4663]][EventData[Data[@Name='TargetUserName]='ИМЯ_УЗ']]" /f:text

 

#Очистка ОЗУ

reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown

 

#Антивирус

 

cd C:\Program Files (x86)\Kaspersky Lab\NetworkAgent\

klnagchk.exe

 