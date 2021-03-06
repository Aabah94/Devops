function Get-VSPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version)        
        
    $Versions = @('15.0', '16.0', '17.0')
    Trace-VstsEnteringInvocation $MyInvocation

    try {
        if ( !($Version -in $Versions )) {
          Write-Warning "Please enter one of the versions 15.0, 16.0, 17.0" 
          } else { 
            $VersionNumber = [int]$Version.Remove(2)
            # Search for more than 15.0 Willow instance.
                if (($instance = Get-VisualStudio $VersionNumber) -and
                    $instance.installationPath) {
                    
                    return $instance.installationPath
                }
         
            if ($path = (Get-ItemProperty -LiteralPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\$Version" -Name 'ShellFolder' -ErrorAction Ignore).ShellFolder) {
                    return $path
            }
          }
    } finally {
        Trace-VstsLeavingInvocation $MyInvocation
    }
}