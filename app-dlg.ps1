Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
function Show-Apps($button) {
    $WPFprogram.IsEnabled, $WPFusecmd.IsEnabled, $WPFlaunch.IsEnabled, $WPFopen.IsEnabled, $WPFportable.IsEnabled = $false
    $WPFprogram.IsEnabled = $true
    $WPFprogram.Items.Clear()
    $json.($button.Content).PSObject.Properties.Name | ForEach-Object { $WPFprogram.Items.Add($_) }
}

try {
# Import and convert data
$wc = New-Object System.Net.WebClient
$branch = 'dev'
$tempFolder = Join-Path $Env:TEMP 'App-DLG'
$assets = Join-Path $tempFolder 'assets'
if (!(Test-Path $assets -PathType Container)) { New-Item -ItemType Directory -Path $assets -Force | Out-Null }
$wc.DownloadFile("https://raw.githubusercontent.com/psfer07/App-DLG/$branch/apps.json", "$assets\apps.json")
$json = Get-Content "$assets\apps.json" <# '.\apps.json' #> -Raw | ConvertFrom-Json
Add-Type -AssemblyName System.Windows.Forms
$xml = @'
<Window  x:Class="App_DLG.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        mc:Ignorable="d"
        Title="App-DLG" Height="600" Width="975" Background="#FF292929">
    <Viewbox>
        <Grid Background="#FF292929" Height="450" Width="770">
            <Label Content="App-DLG" HorizontalAlignment="Left" Margin="36,23,0,0" VerticalAlignment="Top" Height="39" Width="105" FontFamily="Segoe UI Black" Foreground="#FFE8E8E8" FontSize="20"/>
            <TextBlock HorizontalAlignment="Left" Height="17" Margin="36,80,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="445" Foreground="White" FontFamily="Segoe UI Semibold"><Run Text="This is the graphic user interface of the proyect App-DL."/></TextBlock>
            <Border BorderBrush="White" BorderThickness="1" HorizontalAlignment="Left" Height="100" Margin="26,105,0,0" VerticalAlignment="Top" Width="505"/>
            <RadioButton x:Name="cg1" Content="Category #1" HorizontalAlignment="Left" Margin="36,125,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White" GroupName="category" Cursor="Hand"/>
            <RadioButton x:Name="cg2" Content="Category #2" HorizontalAlignment="Left" Margin="196,125,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White" GroupName="category" Cursor="Hand"/>
            <RadioButton x:Name="cg3" Content="Category #3" HorizontalAlignment="Left" Margin="356,125,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White" GroupName="category" Cursor="Hand"/>
            <RadioButton x:Name="cg4" Content="Category #4" HorizontalAlignment="Left" Margin="36,164,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White" GroupName="category" Cursor="Hand"/>
            <RadioButton x:Name="cg5" Content="Category #5" HorizontalAlignment="Left" Margin="196,164,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White" GroupName="category" Cursor="Hand"/>
            <RadioButton x:Name="cg6" Content="Category #6" HorizontalAlignment="Left" Margin="356,164,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White" GroupName="category" Cursor="Hand"/>
            <Label Content="Select a following app to download:" HorizontalAlignment="Left" Height="30" Margin="26,220,0,0" VerticalAlignment="Top" Width="214" FontFamily="Segoe UI Semibold" Foreground="White"/>
            <ComboBox x:Name="program" HorizontalAlignment="Left" Margin="58,255,0,0" VerticalAlignment="Top" Width="150" Cursor="Hand"/>
            <TextBlock x:Name="syn" HorizontalAlignment="Left" Margin="249,220,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Height="80" Width="282" Foreground="White" TextAlignment="Center"/>
            <Border BorderBrush="White" BorderThickness="1" HorizontalAlignment="Left" Height="260" Margin="556,105,0,0" VerticalAlignment="Top" Width="194" Grid.ColumnSpan="2"/>
            <Label Content="     Select a folder&#xD;&#xA;to save the program" HorizontalAlignment="Left" Margin="556,109,0,0" VerticalAlignment="Top" Foreground="White" FontWeight="Bold" FontSize="14" Width="194" HorizontalContentAlignment="Center" Grid.ColumnSpan="2"/>
            <Border BorderBrush="White" BorderThickness="3" HorizontalAlignment="Left" Height="2" Margin="602,134,0,0" VerticalAlignment="Top" Width="102" Grid.ColumnSpan="2"/>
            <Border BorderBrush="White" BorderThickness="3" HorizontalAlignment="Left" Height="2" Margin="585,152,0,0" VerticalAlignment="Top" Width="136" Grid.ColumnSpan="2"/>
            <RadioButton x:Name="p1" Content="Desktop" HorizontalAlignment="Left" Margin="570,165,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="12" Foreground="White" GroupName="path" Cursor="Hand"/>
            <RadioButton x:Name="p2" Content="Documents" HorizontalAlignment="Left" Margin="570,185,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="12" Foreground="White" GroupName="path" Cursor="Hand"/>
            <RadioButton x:Name="p3" Content="Downloads" HorizontalAlignment="Left" Margin="570,205,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="12" Foreground="White" GroupName="path" Cursor="Hand"/>
            <RadioButton x:Name="p4" Content="C: drive" HorizontalAlignment="Left" Margin="570,225,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="12" Foreground="White" GroupName="path" Cursor="Hand"/>
            <RadioButton x:Name="p5" Content="Program Files" HorizontalAlignment="Left" Margin="570,245,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="12" Foreground="White" GroupName="path" Cursor="Hand"/>
            <RadioButton x:Name="p6" Content="User profile" HorizontalAlignment="Left" Margin="570,265,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="12" Foreground="White" GroupName="path" Cursor="Hand"/>
            <RadioButton x:Name="p7" Content="App-DLG temporal folder" HorizontalAlignment="Left" Margin="570,285,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="12" Foreground="White" GroupName="path" Cursor="Hand"/>
            <Button x:Name="saveFile" Content="Save in a custom folder" HorizontalAlignment="Left" Margin="588,310,0,0" VerticalAlignment="Top" Width="131" Cursor="Hand"/>
            <TextBox x:Name="path" HorizontalAlignment="Left" Margin="556,345,0,0" VerticalAlignment="Top" Width="194" Height="20" FontSize="10" Cursor="IBeam"/>
            <Label Content="Optional features" HorizontalAlignment="Left" Height="28" Margin="29,303,0,0" VerticalAlignment="Top" Width="174" FontSize="14" Foreground="White" FontWeight="Bold"/>
            <Border BorderBrush="White" BorderThickness="3" HorizontalAlignment="Left" Height="2" Margin="33,328,0,0" VerticalAlignment="Top" Width="116"/>
            <CheckBox x:Name="portable" Content="Select the portable version" HorizontalAlignment="Left" Margin="36,337,0,0" VerticalAlignment="Top" Foreground="White" Cursor="Hand"/>
            <CheckBox x:Name="open" Content="Open it when the download finishes" HorizontalAlignment="Left" Margin="36,357,0,0" VerticalAlignment="Top" Foreground="White" Cursor="Hand"/>
            <CheckBox x:Name="launch" Content="Launch program after installation" HorizontalAlignment="Left" Margin="36,377,0,0" VerticalAlignment="Top" Foreground="White" Cursor="Hand"/>
            <CheckBox x:Name="usecmd" Content="Use presets for opening the package" HorizontalAlignment="Left" Margin="36,397,0,0" VerticalAlignment="Top" Foreground="White" Cursor="Hand"/>
            <TextBlock x:Name="status" HorizontalAlignment="Left" Margin="500,389,0,0" TextWrapping="Wrap" VerticalAlignment="Top" FontSize="11"/>
            <Button x:Name="download" Content="Download" HorizontalAlignment="Left" Height="20" Margin="410,410,0,0" VerticalAlignment="Top" Width="85" FontSize="13" Cursor="Hand"/>
            <ProgressBar x:Name="downloadBar" HorizontalAlignment="Left" Height="20" Margin="500,410,0,0" VerticalAlignment="Top" Width="250" Grid.ColumnSpan="2"/>

        </Grid>
    </Viewbox>
</Window>

'@  
[xml]$XAML = $xml -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
$form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $XAML))
$XAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $form.FindName($_.Name) }

# Category assignment
$i = 1
foreach ($category in $json.PSObject.Properties.Name) {
    $cgs = Get-Variable -Name WPFcg$i -ValueOnly
    $cgs.Content = $category
    $i++
}

# App selection
$WPFcg1.Add_Click({ Show-Apps $WPFcg1 })
$WPFcg2.Add_Click({ Show-Apps $WPFcg2 })
$WPFcg3.Add_Click({ Show-Apps $WPFcg3 })
$WPFcg4.Add_Click({ Show-Apps $WPFcg4 })
$WPFcg5.Add_Click({ Show-Apps $WPFcg5 })
$WPFcg6.Add_Click({ Show-Apps $WPFcg6 })
    
    
$WPFprogram.Add_SelectionChanged({
        $name = $WPFprogram.SelectedItem
        $appCategory = $json.PSobject.Properties | Where-Object { $_.Value.PSObject.Properties.Name -ieq $name } | Select-Object -ExpandProperty Name
        $appProperties = $json.$appCategory.$name
        $properties = 'versions', 'details', 'size', 'syn', 'cmd_syn'
        foreach ($property in $properties) {
            if ($appProperties.$property -is [array]) { $value = $appProperties.$property[$ver] } else { $value = $appProperties.$property }
            if ($property -eq 'details' -and ($ver -eq 0 -or $ver -eq 1)) { $value = $value.Substring($ver, 1) }
            New-Variable -Name $property -Value $value -ErrorAction SilentlyContinue
        }
        $WPFusecmd.IsChecked, $WPFlaunch.IsChecked, $WPFopen.IsChecked, $WPFportable.IsChecked = $false, $false, $false, $false
        $WPFsyn.Text = @"
        $name is $syn
        Size: $size

"@
        if ($null -eq $WPFprogram.SelectedItem) { $WPFsyn.Text = "Select an app to see what is it about" }
        if ($versions -eq 'PI') { $WPFusecmd.IsEnabled, $WPFlaunch.IsEnabled, $WPFopen.IsEnabled, $WPFportable.IsEnabled = $true }
        if ($versions -eq 'P') {
            $WPFportable.IsChecked = $true
            $WPFopen.IsEnabled = $true
            if ($app.details -contains 'i') { $WPFlaunch.IsEnabled = $true }
        }

    })

if ($WPFportable.IsChecked) {
    
}

# Path selection
$WPFp1.Add_Click({ $WPFpath.Text = "$Env:USERPROFILE\Desktop" })
$WPFp2.Add_Click({ $WPFpath.Text = "$Env:USERPROFILE\Documents" })
$WPFp3.Add_Click({ $WPFpath.Text = "$Env:USERPROFILE\Downloads" })
$WPFp4.Add_Click({ $WPFpath.Text = $Env:SystemDrive })
$WPFp5.Add_Click({ $WPFpath.Text = $Env:ProgramFiles })
$WPFp6.Add_Click({ $WPFpath.Text = "$Env:SystemDrive$Env:HOMEPATH" })
$WPFp7.Add_Click({ $WPFpath.Text = "$tempFolder\Downloads" })
$WPFsaveFile.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $folderBrowser.Description = "Select a folder or create a new one to save the package"
        $folderBrowser.ShowDialog()
        $WPFpath.Text = $folderBrowser.SelectedPath
    })

$form.ShowDialog() | Out-Null
}
finally { Remove-Item "$Env:TEMP\App-DLG" -Recurse -Force | Out-Null }