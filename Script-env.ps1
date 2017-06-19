Set-ExecutionPolicy unrestricted
net use "s:" "\\c4reftstwksvmstorage.file.core.windows.net\c4sources" /u:"c4reftstwksvmstorage" "ls3P9GYP6qM7cCTUy3jmkqIlZdpZtZNdgiRhOuASUgqpJhs5yrM8TzNZU+8BUHrhxnKafRuDr75+2TxConsCzQ=="

copy-item S:\SourcesInstallVM\ c:\ -recurse
Copy-Item S:\SourcesInstallVM\SourceDSCprerequisites C:\SourcesInstallVM\SourceDSCprerequisites -recurse
cd C:\SourcesInstallVM\SourceDSCprerequisites
wusa.exe C:\SourcesInstallVM\SourceDSCprerequisites\$($(get-childitem "*.msu").Name) /quiet /norestart
while (Get-Process "wusa" -ErrorAction silentlycontinue) {"WMF 4.0 is being instaled, please wait..."; start-sleep -seconds 5}
cd (get-childitem -Recurse | where { $_.Name -match "Install-WMF*" }).DirectoryName
& (get-childitem -Recurse | where { $_.Name -match "Install-WMF*" }).FullName
while (Get-Process "wusa" -ErrorAction silentlycontinue) {"WMF 5.1 is being instaled, please wait..."; start-sleep -seconds 5}
Enable-PSRemoting -Force
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
