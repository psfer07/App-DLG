$branch = "main"
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
    
$XAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) }


########################
##Initialize variables##
########################

$json = Invoke-RestMethod "https://raw.githubusercontent.com/psfer07/App-DLG/$branch/apps.json"
$nameArray = $json.psobject.Properties.Name
$propMapping = @{}
$filteredApps = @()


#Assigns the JSON's properties into Powershell objects
foreach ($i in 0..($nameArray.Count - 1)) {
  $name = $nameArray[$i]
  $app = $json.$name
  $folder = $app.folder
  $url = $app.URL
  $exe = $app.exe
  $size = $app.size
  $syn = $app.syn
  $propMapping.Add($name, $url)
  $filteredApps += [PsCustomObject]@{Index = $i; Name = $name; Folder = $folder; URL = $url; Exe = $exe; Size = $size; Syn = $syn }
}



Write-Main "Available apps"
foreach ($i in 0..($filteredApps.Count - 1)) {
  $app = $filteredApps[$i]
  $WPFprogram.Items.Add($($app.Name))
  Write-Host $app.Size
  Write-Host $app.Syn
}


#Assign the corresponding variables to the selected app
$program = $filteredApps[$WPFprogram.SelectedItem - 1].Name
$exe = $filteredApps[$WPFprogram.SelectedItem - 1].Exe
$folder = $filteredApps[$WPFprogram.SelectedItem - 1].folder
$url = $filteredApps[$WPFprogram.SelectedItem - 1].URL
Clear-Host
Write-Host `n"$program selected"


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
