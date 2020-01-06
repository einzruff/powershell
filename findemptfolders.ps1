# Powershell Script - Recurse Empty Folders then Write to Log
# 2020-1-6 Daphne Lundquist
Write-Host "[Recurse Empty Folders then Write to Log]"

$emptlist = New-Object System.Collections.ArrayList
$delim = "C:\ADIRECTORY"
Get-Location | Tee-Object -Variable workingdir
Push-Location -Path $workingdir
Set-Location -Path $delim

dir -recurse | 
Where-Object { $_.PSIsContainer } |   
Where-Object { $_.GetFiles().Count -eq 0 } |   
Where-Object { $_.GetDirectories().Count -eq 0 } |   
ForEach-Object { $_.FullName }  | Tee-Object -Variable emptVar | Out-Null
#-join($emptVar, "zz")
#foreach-object { -join($emptVar, "zz") }

$delim = $delim,"."
#Write-Host "Delim is: " $delim

$option = [System.StringSplitOptions]::RemoveEmptyEntries
#$option = [System.StringSplitOptions]::None
$emptlist = @($emptVar.Split($delim,$option))

Pop-Location
$DST = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$DST = $DST.ToLower()
$LOGFILE = "logfile" + $DST + ".txt"

foreach ($str in $emptlist) 
{ 
    Write-Host $str
    Add-Content $LOGFILE $str
}
