# Bypasses any execution policy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Removes last possible modules.psm1 from the computer
Remove-Item "$Env:TEMP\modules.psm1" -Force -ErrorAction SilentlyContinue

# Imports variables
#[string]$branch = 'main'
#[string]$module = "$Env:TEMP\modules.psm1"
#Invoke-WebRequest -Uri "https://raw.githubusercontent.com/psfer07/App-DLG/$branch/modules.psm1" -OutFile $module
#Import-Module $module -DisableNameChecking
#$json = Invoke-RestMethod "https://raw.githubusercontent.com/psfer07/App-DLG/$branch/apps.json"
Get-Content .\modules.psm1 -Raw
Import-Module '.\modules.psm1' -DisableNameChecking
$json = Get-Content '.\apps.json'	-Raw | ConvertFrom-Json
$inputXML = Get-Content "MainWindow.xaml"
$inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
    
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
$reader = (New-Object System.Xml.XmlNodeReader $XAML)
try {
  $Form = [Windows.Markup.XamlReader]::Load($reader)
}
catch {
  Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."
}

# Sets the xaml names as Powershell variables
$XAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) }


$nameArray = $json.psobject.Properties.Name
$filteredApps = @()

# Sets the JSON data into Powershell variables
foreach ($i in 0..($nameArray.Count - 1)) {
  $name = $nameArray[$i]; $app = $json.$name; $folder = $app.folder; $url = $app.URL; $exe = $app.exe; $syn = $app.syn; $cmd = $app.cmd; $cmd_syn = $app.cmd_syn
  $filteredApps += [PsCustomObject]@{Index = $i; Name = $name; Folder = $folder; URL = $url; Exe = $exe; Size = $size; Syn = $syn; Cmd = $cmd; Cmd_syn = $cmd_syn }
}

# Lists every single app in the JSON
#Clear-Host
Select-App
$pkg = Read-Host "`nWrite the number of the app you want to get"

# Assign the corresponding variables to the selected app
$pkg_n = [int]($pkg -replace "\."); $n = $filteredApps[$pkg_n - 1]; $program = $n.Name; $exe = $n.Exe; $syn = $n.Syn; $folder = $n.folder; $url = $n.URL; $cmd = $n.Cmd; $cmd_syn = $n.Cmd_syn; $o = Split-Path $url -Leaf

Write-Main "$program selected"
Start-Sleep -Milliseconds 2500
#Clear-Host
Show-Details

# Sets all possible paths for downloading the program
Show-Paths
[string]$p = Read-Host "`nChoose a number"
switch ($p) {
  0 { Restart-App }
  1 { $p = "$Env:USERPROFILE\Desktop"; break }
  2 { $p = "$Env:USERPROFILE\Documents"; break }
  3 { $p = "$Env:USERPROFILE\Downloads"; break }
  4 { $p = $Env:SystemDrive; break }
  5 { $p = $Env:ProgramFiles; break }
  6 { $p = $Env:HOMEPATH; break }
  'x' { $p = Read-Host 'Set the whole custom path'; break }
  'X' { $p = Read-Host 'Set the whole custom path'; break }
  default { Write-Host "Invalid input. Using default path: $Env:USERPROFILE"; $p = $Env:USERPROFILE; break }
}

Write-Main "Selected path: $p"

# Checks if the program was allocated there before
if (Test-Path "$p\$o") { Revoke-Path }
if (Test-Path "$p\$program\$folder\$exe") { Revoke-Path }
Start-Sleep -Seconds 1

# Asks the user to open the program after downloading it
Write-Secondary "Do you want to open it when finished? (y/n)"
$openAns = Read-Host
$open = $false
$openString = $null
if ($openAns -eq 'y' -or $openAns -eq 'Y') { $open = $true }
if ($open -eq $true) {$openString = ' and open'}

# Last confirmation
Write-Main "You are going to download$openString $program"
$dl = Read-Host 'Confirmation (press any key or go to the (R)estart menu)'
if ($dl -eq 'R' -or $dl -eq 'r') { Restart-App }
#Clear-Host
Invoke-RestMethod -Uri $url -OutFile "$p\$o"

if ($open -eq $true) { Open-File } else {exit}



########################
##Initialize variables##
########################

#Assign the corresponding variables to the selected app
$program = $filteredApps[$WPFprogram.SelectedItem - 1].Name
$exe = $filteredApps[$WPFprogram.SelectedItem - 1].Exe
$folder = $filteredApps[$WPFprogram.SelectedItem - 1].folder
$url = $filteredApps[$WPFprogram.SelectedItem - 1].URL



# Add event handler for selection change
$WPFprogram.Add_SelectionChanged({
    # Assign $app variable inside event handler
    $app = $filteredApps[$WPFprogram.SelectedIndex]
  })

$WPFdownload.Add_Click({
    # Access $app variable in event handler
    Write-Host $exe
  })


$Form.ShowDialog() | Out-Host