Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Import and convert data
$json = Get-Content .\apps.json -Raw | ConvertFrom-Json
Add-Type -AssemblyName System.Windows.Forms
$xml = @'
<Window x:Class="App_DLG.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        mc:Ignorable="d"
        Title="App-DLG" Height="600" Width="975" Background="#FF292929">
    <Viewbox>
        <Grid Background="#FF292929" Height="450" Width="770">
            <Label Content="App-DLG" HorizontalAlignment="Left" Margin="36,23,0,0" VerticalAlignment="Top" Height="39" Width="105" FontFamily="Segoe UI Black" Foreground="#FFE8E8E8" FontSize="20"/>
            <TextBlock HorizontalAlignment="Left" Height="17" Margin="36,80,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="445" Foreground="White" FontFamily="Segoe UI Semibold"><Run Text="This is a graphic user interface for downloading and managing various programs."/></TextBlock>
            <RadioButton x:Name="cg1" Content="Category #1" HorizontalAlignment="Left" Margin="36,125,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White"/>
            <RadioButton x:Name="cg2" Content="Category #2" HorizontalAlignment="Left" Margin="196,125,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White"/>
            <RadioButton x:Name="cg3" Content="Category #3" HorizontalAlignment="Left" Margin="356,125,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White"/>
            <RadioButton x:Name="cg4" Content="Category #4" HorizontalAlignment="Left" Margin="36,164,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White"/>
            <RadioButton x:Name="cg5" Content="Category #5" HorizontalAlignment="Left" Margin="196,164,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White"/>
            <RadioButton x:Name="cg6" Content="Category #6" HorizontalAlignment="Left" Margin="356,164,0,0" VerticalAlignment="Top" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White"/>
            <Label Content="Select a following app to download:" HorizontalAlignment="Left" Height="29" Margin="518,119,0,0" VerticalAlignment="Top" Width="214" FontFamily="Segoe UI Semibold" Foreground="White"/>
            <ComboBox x:Name="program" HorizontalAlignment="Left" Margin="550,160,0,0" VerticalAlignment="Top" Width="150"/>
            <TextBlock x:Name="syn" HorizontalAlignment="Left" Margin="344,238,0,0" TextWrapping="Wrap" Text="Select an app to see what is it about" VerticalAlignment="Top" Height="100" Width="400" Foreground="White" TextAlignment="Center" ScrollViewer.HorizontalScrollBarVisibility="Auto"/>
            <Label Content="Optional features" HorizontalAlignment="Left" Height="28" Margin="36,231,0,0" VerticalAlignment="Top" Width="174" FontFamily="Segoe UI Semibold" FontSize="14" Foreground="White"/>
            <Border BorderBrush="White" BorderThickness="50" HorizontalAlignment="Left" Height="1" Margin="38,255,0,0" VerticalAlignment="Top" Width="116"/>
            <CheckBox x:Name="portable" Content="Select the portable version" HorizontalAlignment="Left" Margin="36,270,0,0" VerticalAlignment="Top" Foreground="White"/>
            <CheckBox x:Name="open" Content="Open it when the download finishes" HorizontalAlignment="Left" Margin="36,300,0,0" VerticalAlignment="Top" Foreground="White"/>
            <CheckBox x:Name="launch" Content="Launch program after installation" HorizontalAlignment="Left" Margin="36,330,0,0" VerticalAlignment="Top" Foreground="White"/>
            <CheckBox x:Name="usecmd" Content="Use presets for opening the package" HorizontalAlignment="Left" Margin="36,360,0,0" VerticalAlignment="Top" Foreground="White"/>
            <Button x:Name="download" Content="Download" HorizontalAlignment="Left" Height="24" Margin="635,400,0,0" VerticalAlignment="Top" Width="105" FontSize="13"/>

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
$WPFprogram.IsEnabled, $WPFusecmd.IsEnabled, $WPFlaunch.IsEnabled, $WPFopen.IsEnabled, $WPFportable.IsEnabled = $false

$WPFcg1.Add_Click({
        $WPFprogram.IsEnabled = $true
        $WPFprogram.Items.Clear()
        $json.$($WPFcg1.Content).PSObject.Properties.Name | ForEach-Object { $WPFprogram.Items.Add($_) }
    })
$WPFcg2.Add_Click({
        $WPFprogram.IsEnabled = $true
        $WPFprogram.Items.Clear()
        $json.$($WPFcg2.Content).PSObject.Properties.Name | ForEach-Object { $WPFprogram.Items.Add($_) }
    })
$WPFcg3.Add_Click({
        $WPFprogram.IsEnabled = $true
        $WPFprogram.Items.Clear()
        $json.$($WPFcg3.Content).PSObject.Properties.Name | ForEach-Object { $WPFprogram.Items.Add($_) }
    })
$WPFcg4.Add_Click({
        $WPFprogram.IsEnabled = $true
        $WPFprogram.Items.Clear()
        $json.$($WPFcg4.Content).PSObject.Properties.Name | ForEach-Object { $WPFprogram.Items.Add($_) }
    })
$WPFcg5.Add_Click({
        $WPFprogram.IsEnabled = $true
        $WPFprogram.Items.Clear()
        $json.$($WPFcg5.Content).PSObject.Properties.Name | ForEach-Object { $WPFprogram.Items.Add($_) }
    })
$WPFcg6.Add_Click({
        $WPFprogram.IsEnabled = $true
        $WPFprogram.Items.Clear()
        $json.$($WPFcg6.Content).PSObject.Properties.Name | ForEach-Object { $WPFprogram.Items.Add($_) }
    })


$form.ShowDialog() | Out-Null