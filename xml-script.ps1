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

$json = Invoke-RestMethod "https://raw.githubusercontent.com/psfer07/App-DL/$branch/apps.json"
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
  $filteredApps += [PsCustomObject]@{Index = $i; Name = $name; Folder = $folder; URL = $url; Exe = $exe; Size = $size; Syn = $syn}
}

foreach ($i in 0..($filteredApps.Count - 1)) {
  $app = $filteredApps[$i]
  $WPFprogram.Items.Add($($app.Name))
}

# Add event handler for selection change
  
$WPFprogram.Add_SelectionChanged({
  $program = $WPFprogram.SelectedItem
  $selectedApp = $filteredApps | Where-Object { $_.Name -eq $program }
  $exe = $selectedApp.Exe
  $folder = $selectedApp.Folder
  $url = $selectedApp.URL
})


$WPFdownload.Add_Click({Write-Host $WPFprogram.SelectedItem})

$Form.ShowDialog() | Out-Host
