function Get-AppSize {
  Param ([int]$length)
  if ($length -gt 1GB) { [string]::Format("{0:0.00} GB", $length / 1GB) }
  elseIf ($length -gt 1MB) { [string]::Format("{0:0.00} MB", $length / 1MB) }
  elseIf ($length -gt 1KB) { [string]::Format("{0:0.00} kB", $length / 1KB) }
  elseIf ($length -gt 0) { [string]::Format("{0:0.00} B", $length) }
}
function Revoke-Path { <# Just needs a dialog form #> }
function Open-File {
  # Opens the app
  Write-Main "Launching $program..."
  
  if ($o -like "*.zip") {
    if (Test-Path -Path "$p\$program\$folder") {
      Write-Main "$program is uncompressed in $p, so opening it directly..."
      Start-Sleep -Milliseconds 500
      Start-Process -FilePath "$p\$program\$folder\$exe" -ErrorAction SilentlyContinue
      Start-Sleep 1
      Exit
    }
    # It uncompresses it and opens the app
    elseif (Test-Path -LiteralPath "$p\$o") {
      Write-Main 'Zip file detected'
      Write-Secondary "$program is saved as a zip file, so uncompressing..."
      Start-Sleep -Milliseconds 200
      Expand-Archive -Literalpath "$p\$o" -DestinationPath "$p\$program" -Force
      if ($?) {
        Write-Main 'Package successfully extracted...'
      }
      else {
        Write-Warning "Failed to extract package. Error: $($_.Exception.Message)"
        Read-Host "Press any key to continue..."
      }
      Start-Sleep 2
      Clear-Host
      Write-Main "Running $program directly"
      Start-Sleep -Milliseconds 500
      Start-Process -FilePath "$p\$program\$folder\$exe" -ErrorAction SilentlyContinue
      Start-Sleep -Milliseconds 200
      Exit
    }
  }
  
  if ($o -like "*.exe") {
    # If there are any recommended parameters for the executable, asks for using them.
    if ($cmd) {
      Write-Host "There is a preset for running $program $($cmd_syn). Do you want to do it (if not, it will just launch it as normal)? (y/n)"
      $runcmd = Read-Host
      if ($runcmd -eq 'y' -or $runcmd -eq 'Y') {
          
        Write-Main "Running $program $($cmd_syn)"
        Start-Process -FilePath "$p\$o" -ArgumentList $($cmd) -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 200
        Exit
      }
    }
    if ($runcmd -ne 'y' -or $runcmd -ne 'Y') {
        
      Write-Main "Running $program directly"
      Start-Process -FilePath "$p\$o" -ErrorAction SilentlyContinue
      Start-Sleep -Milliseconds 200
      Exit
    }
  }
}
function Restart-App {
  powershell.exe -command "Invoke-RestMethod "https://raw.githubusercontent.com/psfer07/App-DL/$branch/app-dl.ps1" | Invoke-Expression"
}
function Select-Folder() {
  [CmdletBinding()]
  param (
    [String] $Description = "Select a folder",
    [String] $InitialDirectory = "$env:SystemDrive"
  )

  [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
  $FolderName = New-Object System.Windows.Forms.FolderBrowserDialog
  $FolderName.Description = $Description
  $FolderName.rootfolder = "MyComputer"
  $FolderName.SelectedPath = $InitialDirectory
  $Response = $FolderName.ShowDialog()

  If ($Response -eq "OK") {
    $Folder += $FolderName.SelectedPath
    Write-Host "Folder Selected: $Folder"
  }
  ElseIf ($Response -eq "Cancel") {
    Write-Host "Aborting..."
  }

  return $Folder
}
function Use-WindowsForm() {
  [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null # Load assembly
}
function Show-Message() {
  [CmdletBinding()]
  [OutputType([System.Windows.Forms.DialogResult])]
  param (
    [String] $Title = "Insert title here",
    [Array]  $Message = "`nCrash`nBandicoot",
    [String] $BoxButtons = "OK", # AbortRetryIgnore, OK, OKCancel, RetryCancel, YesNo, YesNoCancel
    [String] $BoxIcon = "Information" # Information, Question, Warning, Error or None
  )

  Use-WindowsForm
  [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::$BoxButtons, [System.Windows.Forms.MessageBoxIcon]::$BoxIcon)
}
function Show-Question() {
  [CmdletBinding()]
  [OutputType([System.Windows.Forms.DialogResult])]
  param (
    [String] $Title = "Insert title here",
    [Array]  $Message = "Crash`nBandicoot",
    [String] $BoxButtons = "YesNoCancel", # With Yes, No and Cancel, the user can press Esc to exit
    [String] $BoxIcon = "Question"
  )

  Use-WindowsForm
  $Answer = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::$BoxButtons, [System.Windows.Forms.MessageBoxIcon]::$BoxIcon)

  return $Answer
}
function Request-Privileges {
  param($Privilege)
  $Definition = @"
  using System;
  using System.Runtime.InteropServices;

  public class AdjPriv {
      [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
          internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);

      [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
          internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);

      [DllImport("advapi32.dll", SetLastError = true)]
          internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);

      [StructLayout(LayoutKind.Sequential, Pack = 1)]
          internal struct TokPriv1Luid {
              public int Count;
              public long Luid;
              public int Attr;
          }

      internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
      internal const int TOKEN_QUERY = 0x00000008;
      internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;

      public static bool EnablePrivilege(long processHandle, string privilege) {
          bool retVal;
          TokPriv1Luid tp;
          IntPtr hproc = new IntPtr(processHandle);
          IntPtr htok = IntPtr.Zero;
          retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
          tp.Count = 1;
          tp.Luid = 0;
          tp.Attr = SE_PRIVILEGE_ENABLED;
          retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
          retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
          return retVal;
      }
  }
"@
  $ProcessHandle = (Get-Process -id $pid).Handle
  $type = Add-Type $definition -PassThru
  $type[0]::EnablePrivilege($processHandle, $Privilege)
}