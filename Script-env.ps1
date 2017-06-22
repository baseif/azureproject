param (
    [string]$storageAccesskeys,
      [string]$Storageaccount,
      [string]$path
    )
Set-ExecutionPolicy unrestricted

New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\' -Name  'DisabledComponents' -Value '0xff' -PropertyType 'DWord'

net use "s:" "\\$Storageaccount.file.core.windows.net\$path" /u:"$Storageaccount" $storageAccesskeys

copy-item S:\SourcesInstallVM\ c:\ -recurse
cd C:\SourcesInstallVM\SourceDSCprerequisites
wusa.exe C:\SourcesInstallVM\SourceDSCprerequisites\$($(get-childitem "*.msu").Name) /quiet /norestart
while (Get-Process "wusa" -ErrorAction silentlycontinue) {"WMF 4.0 is being instaled, please wait..."; start-sleep -seconds 5}
cd (get-childitem -Recurse | where { $_.Name -match "Install-WMF*" }).DirectoryName
& (get-childitem -Recurse | where { $_.Name -match "Install-WMF*" }).FullName
while (Get-Process "wusa" -ErrorAction silentlycontinue) {"WMF 5.1 is being instaled, please wait..."; start-sleep -seconds 5}
Enable-PSRemoting -Force

restart-computer -force		

netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow

restart-computer -force		
