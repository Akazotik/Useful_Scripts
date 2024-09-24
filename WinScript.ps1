Write-output "#####PUNKT 1.1.1.1######"

Get-LocalGroupMember "Администраторы"
Get-LocalGroupMember "Пользователи удаленного рабочего стола"
Get-LocalGroupMember "Пользователи удаленного рабочего стола"

$admins = Get-LocalGroupMember "Администраторы" | Select-String "ROSNEFT"
$rdp = Get-LocalGroupMember "Пользователи удаленного рабочего стола" | Select-String "ROSNEFT"
$rdpmanage = Get-LocalGroupMember "Пользователи удаленного рабочего стола" | Select-String "ROSNEFT"

$admins -replace "ROSNEFT\W", "" | Out-File -Append -FilePath C:\IT\Groups.txt
$rdp -replace "ROSNEFT\W", "" | Out-File -Append -FilePath C:\IT\Groups.txt
$rdpmanage -replace "ROSNEFT\W", "" | Out-File -Append -FilePath C:\IT\Groups.txt

$Groups = Get-Content -Path C:\IT\Groups.txt

ForEach ($item in $Groups)
{
get-date | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

Write-Output ":`n`n" | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

Write-Output "Состав группы " | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

Get-ADGroup -Filter {Name -eq $item} | Select-Object name | Format-Table -hideTableHeaders | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

Write-Output ":`n`n" | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

$ADUser = Get-ADGroup -Filter {Name -eq $item} -Properties members | Select-Object -ExpandProperty members 

Write-Output "Users:" | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt"

$ADUser |  Get-ADUser | Select-Object SamAccountName | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt"

Write-Output "Groups:" | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt"

$ADGroup = $ADUser |  Get-ADGroup | Select-Object name  | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt"

Write-Output "`n" | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

}

$user = Get-Content -Path "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy ).txt"

$user -replace "CN=",""  -replace ",OU=.+$","" | Out-File -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt"


Write-Output "#####PUNKT 1.1.1.3#######"
net accounts | Out-File -FilePath "C:\IT\PassPol.txt"


Write-Output "#####PUNKT 1.1.1.5#####"
# Query server to check User rights
$hostname = hostname  
secedit /export /areas USER_RIGHTS /cfg "C:\IT\Temp.txt"
    $AuditPath = Get-Content "C:\IT\Temp.txt"
    $Audit = $AuditPath | Select-String '^(Se\S+) = (\S+)'
    $Audit | Foreach-Object {
               
              $Privilege = $null
              $Principals = $null

              $Privilege = $_.Matches[0].Groups[1].Value
              $Principals = $_.Matches[0].Groups[2].Value -split ','      

              foreach ( $Principal in $Principals ) 
              {     
                  If ( $Principal[0] -eq "*" ) 
                  {
                      $TName = $null
                      $TName = (New-Object System.Security.Principal.SecurityIdentifier($Principal.Substring(1))).Translate([Security.Principal.NTAccount]).Value
                      $Principal=$TName
                  }
                  else {
                    $Principal = $Principal
                  }
                      $Val =  Switch ( $Privilege )
                            {
                                "SeTrustedCredManAccessPrivilege" {"Access Credential Manager as a trusted caller"}
                                "SeNetworkLogonRight" {"Access this computer from the network"}
                                "SeTcbPrivilege" {"Act as part of the operating system"}
                                "SeMachineAccountPrivilege" {"Add workstations to domain"}
                                "SeIncreaseQuotaPrivilege" {"Adjust memory quotas for a process"}
                                "SeInteractiveLogonRight" {"Allow log on locally"}
                                "SeRemoteInteractiveLogonRight" {"Allow log on through Remote Desktop Services"}
                                "SeBackupPrivilege" {"Back up files and directories"}
                                "SeChangeNotifyPrivilege" {"Bypass traverse checking"}
                                "SeSystemtimePrivilege" {"Change the system time"}
                                "SeTimeZonePrivilege" {"Change the time zone"}
                                "SeCreatePagefilePrivilege" {"Create a pagefile"}
                                "SeCreateTokenPrivilege" {"Create a token object"}
                                "SeCreateGlobalPrivilege" {"Create global objects"}
                                "SeCreatePermanentPrivilege" {"Create permanent shared objects"}
                                "SeCreateSymbolicLinkPrivilege" {"Create symbolic links"}
                                "SeDebugPrivilege" {"Debug programs"}
                                "SeDenyNetworkLogonRight" {"Deny access to this computer from the network"}
                                "SeDenyBatchLogonRight" {"Deny log on as a batch job"}
                                "SeDenyServiceLogonRight" {"Deny log on as a service"}
                                "SeDenyInteractiveLogonRight" {"Deny log on locally"}
                                "SeDenyRemoteInteractiveLogonRight" {"Deny log on through Remote Desktop Services"}
                                "SeEnableDelegationPrivilege" {"Enable computer and user accounts to be trusted for delegation"}
                                "SeRemoteShutdownPrivilege" {"Force shutdown from a remote system"}
                                "SeAuditPrivilege" {"Generate security audits"}
                                "SeImpersonatePrivilege" {"Impersonate a client after authentication"}
                                "SeIncreaseWorkingSetPrivilege" {"Increase a process working set"}
                                "SeIncreaseBasePriorityPrivilege" {"Increase scheduling priority"}
                                "SeLoadDriverPrivilege" {"Load and unload device drivers"}
                                "SeLockMemoryPrivilege" {"Lock pages in memory"}
                                "SeBatchLogonRight" {"Log on as a batch job"}
                                "SeServiceLogonRight" {"Log on as a service"}
                                "SeSecurityPrivilege" {"Manage auditing and security log"}
                                "SeRelabelPrivilege" {"Modify an object label"}
                                "SeSystemEnvironmentPrivilege" {"Modify firmware environment values"}
                                "SeManageVolumePrivilege" {"Perform volume maintenance tasks"}
                                "SeProfileSingleProcessPrivilege" {"Profile single process"}
                                "SeSystemProfilePrivilege" {"Profile system performance"}
                                "SeUndockPrivilege" {"Remove computer from docking station"}
                                "SeAssignPrimaryTokenPrivilege" {"Replace a process level token"}
                                "SeRestorePrivilege" {"Restore files and directories"}
                                "SeShutdownPrivilege" {"Shut down the system"}
                                "SeSyncAgentPrivilege" {"Synchronize directory service data"}
                                "SeTakeOwnershipPrivilege" {"Take ownership of files or other objects"}
                            }
                      "$Privilege = $Val = $Principal" | Out-File -Append -FilePath "C:\IT\UserRights_$($hostname).txt"         
                    }
                }
Remove-Item -Path "C:\IT\Temp.txt"


Write-Output "#####PUNKT 1.1.1.6#####"
$nameuser = Read-Host "Enter username for resultant pso"
Get-ADUser -Identity $nameuser -Properties msds-resultantpso | Select-Object msds-resultantpso | Out-File -FilePath "C:\IT\ResultantPso.txt"

Write-Output "######PUNKT 1.1.1.7"
klist | Out-File -FilePath "C:\IT\Klist.txt"

Write-Output "#####PUNKT  1.2.1.1#######"
Get-NetTCPConnection | Sort-Object LocalAddress | Out-File -FilePath "C:\IT\NetActivity.txt"

Write-Output "####PUNKT 1.3.1.1#####"
Set-Location 'C:\Program Files\Internet Explorer'
dir | Out-File -FilePath C:\it\dir.txt
Get-ChildItem | Out-File C:\IT\child.txt
$dir = Get-Content "C:\IT\dir.txt"
$child = "C:\IT\child.txt"
$compare = Compare-Object -ReferenceObject $($dir) -DifferenceObject $($child) -IncludeEqual
if ($compare) {Write-Output "files are same" | Out-File -FilePath "C:\IT\Compare.txt"} else {Write-Output "files are different" |  Out-File -FilePath "C:\IT\Compare.txt"}  
Remove-Item "C:\IT\dir.txt" 
Remove-Item "C:\IT\child.txt"
Set-Location ~

Write-Output "#####PUNKT 1.4.1.1#####"
$folder = Read-Host "Enter file path or folder"
Get-Acl $folder | Format-List | Out-File -FilePath "C:\IT\FileOrFolderSecurityProperty.txt"

Write-Output "#####PUNKT 2.1.1.1#####"
Write-Output N | gpupdate /force
auditpol /backup /file:C:\IT\auditpolicy.csv

Write-Output "########PUNKT 2.1.1.2#######"
$nameuser = Read-Host "Enter username for events"
Get-EventLog -LogName Security -UserName $nameuser -InstanceId 4624 -Newest 5 | Select-Object EventID, TimeGenerated, @{Name="UserName";Expression={ $_.ReplacementStrings[1]}}, EntryType | Out-File -Append -FilePath "C:\IT\Events.txt"
Get-EventLog -LogName Security -UserName $nameuser -InstanceId 4634 -Newest 5 | Select-Object EventID, TimeGenerated, @{Name="UserName";Expression={ $_.ReplacementStrings[1]}}, EntryType | Out-File -Append -FilePath "C:\IT\Events.txt"
Get-EventLog -LogName Security -UserName $nameuser -InstanceId 4625 -Newest 5 | Select-Object EventID, TimeGenerated, @{Name="UserName";Expression={ $_.ReplacementStrings[1]}}, EntryType | Out-File -Append -FilePath "C:\IT\Events.txt"

Write-Output "#####PUNKT 2.1.1.5#####"
Get-LocalGroupMember "EventLogReaders" | Out-File -FilePath "C:\IT\GroupEventLogReader.txt"

Write-Output "#####PUNKT 2.2.1.2#####"
$nameuser = Read-Host "Enter username for events"
Get-EventLog -LogName Security -UserName $nameuser -InstanceId 4688 -Newest 5 | Select-Object EventID, TimeGenerated, @{Name="UserName";Expression={ $_.ReplacementStrings[1]}}, EntryType | Out-File -Append -FilePath "C:\IT\Events.txt"
Get-EventLog -LogName Security -UserName $nameuser -InstanceId 4689 -Newest 5 | Select-Object EventID, TimeGenerated, @{Name="UserName";Expression={ $_.ReplacementStrings[1]}}, EntryType | Out-File -Append -FilePath "C:\IT\Events.txt"

Write-Output "#####PUNKT 2.3.1.1######"
$folder = Read-Host "Enter folder for security properties"
Set-Location $folder
Get-Acl | Format-List | Out-File -Append -FilePath "C:\IT\FileOrFolderSecurityProperty.txt"
Set-Location ~

Write-Output "#####PUNKT 2.3.1.2######"
$nameuser = Read-Host "Enter username for events"
Get-EventLog -LogName Security -UserName $nameuser -InstanceId 4674 -Newest 5 | Select-Object EventID, TimeGenerated, @{Name="UserName";Expression={ $_.ReplacementStrings[1]}}, EntryType | Out-File -Append -FilePath "C:\IT\Events.txt"

Write-Output "######PUNKT 2.4.1.2########"
Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' | Out-File -FilePath "C:\IT\Reg.txt"