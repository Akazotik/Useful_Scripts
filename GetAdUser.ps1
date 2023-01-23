ForEach ($item in $Groups)
{
get-date | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

Write-Output ":`n`n" | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

Write-Output "РЎРѕСЃС‚Р°РІ РіСЂСѓРїРїС‹ " | Out-File -Append -FilePath "C:\IT\Groups $(Get-Date -Format HH-mm-dd-MM-yyyy).txt" -NoNewline

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
