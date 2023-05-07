# Bypasses any execution policy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Removes last possible modules.psm1 from the computer
Remove-Item "$Env:TEMP\modules.psm1" -Force -ErrorAction SilentlyContinue

# Imports variables
#[string]$branch = 'main'
#$json = Invoke-RestMethod "https://raw.githubusercontent.com/psfer07/App-DLG/$branch/apps.json"
#$inputXML = Invoke-RestMethod "https://raw.githubusercontent.com/psfer07/App-DLG/$branch/Mainwindow.xaml"
$json = Get-Content '.\apps.json'	-Raw | ConvertFrom-Json
$inputXML = Get-Content "MainWindow.xaml"
$inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
    
# Assigns the XAML properties to be imported as a WPF
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
$reader = (New-Object System.Xml.XmlNodeReader $XAML)
$Form = [Windows.Markup.XamlReader]::Load($reader)


# Sets the XAML names as Powershell variables
$XAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) }



# Sets the JSON data into Powershell variables
$nameArray = $json.psobject.Properties.Name
$filteredApps = @()
foreach ($i in 0..($nameArray.Count - 1)) {
  $name = $nameArray[$i]; $app = $json.$name; $folder = $app.folder; $url = $app.URL; $exe = $app.exe; $syn = $app.syn; $cmd = $app.cmd; $cmd_syn = $app.cmd_syn
  $filteredApps += [PsCustomObject]@{Index = $i; Name = $name; Folder = $folder; URL = $url; Exe = $exe; Size = $size; Syn = $syn; Cmd = $cmd; Cmd_syn = $cmd_syn }
}

# Lists every single app in the JSON
foreach ($i in 0..($filteredApps.Count - 1)) {
  $app = $filteredApps[$i]
  $WPFprogram.Items.Add($($app.Name))
}

# Assign the corresponding variables to the selected app
$n = $filteredApps[$($WPFprogram.SelectedValue)]; $program = $n.Name; $exe = $n.Exe; $syn = $n.Syn; $folder = $n.folder; $url = $n.URL; $cmd = $n.Cmd; $cmd_syn = $n.Cmd_syn; #$o = Split-Path $url -Leaf

Write-Host "$program selected"
Start-Sleep -Milliseconds 2500
#Show-Details

#$p = "$env:HOMEPATH\Desktop"


# Checks if the program was allocated there before

# Asks the user to open the program after downloading it


# Last confirmation
Write-Host "You are going to download$openString $program"
#$dl = Read-Host 'Confirmation (press any key or go to the (R)estart menu)'
#Invoke-RestMethod -Uri $url -OutFile "$p\$o"



#Assign the corresponding variables to the selected app
$app = $filteredApps[$($WPFprogram.SelectedValue)]
$program = $app.Name
$exe = $app.Exe
$folder = $app.folder
$url = $app.URL

$WPFsyn.Text = "$program's properties:
$program is $syn
Size: $size
Saved in : $folder
Recommended parameters do: $cmd_syn
Parameters are: $cmd"

# Add event handler for selection change
$WPFprogram.Add_SelectionChanged({})

$WPFdownload.Add_Click({
    Write-Host $exe
  })


$Form.ShowDialog() | Out-Host