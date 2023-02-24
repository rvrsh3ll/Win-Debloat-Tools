Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"title-templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\debloat-helper\"windows-capability-handler.psm1"

function Remove-CapabilitiesList() {
    [CmdletBinding()]
    param (
        [Switch] $Revert
    )

    Begin {
        $DisableCapabilities = @(
            "App.StepsRecorder*" # Steps Recorder
            "Browser.InternetExplorer*" # Internet Explorer (Also has on Optional Features)
            "MathRecognizer*" # Math Recognizer
            "Microsoft.Windows.PowerShell.ISE*" # PowerShell ISE
            "Microsoft.Windows.WordPad*" # WordPad
            "Print.Fax.Scan*" # Fax features
            "Print.Management.Console*" # printmanagement.msc
        )
    }

    Process {
        Write-Title -Text "Windows Capabilities Tweaks"
        Write-Section -Text "Uninstall Windows Capabilities from Windows"

        If ($Revert) {
            Write-Status -Types "*", "Capability" -Status "Reverting the tweaks is set to '$Revert'." -Warning
            Set-CapabilityState -State Enabled -Capabilities $DisableCapabilities
        } Else {
            Set-CapabilityState -State Disabled -Capabilities $DisableCapabilities
        }
    }
}

function Main() {
    # List all Windows Capabilities:
    #Get-WindowsCapability -Online | Select-Object -Property State, Name, Online, RestartNeeded, LogPath, LogLevel | Sort-Object State, Name | Format-Table

    If (!$Revert) {
        Remove-CapabilitiesList # Disable useless capabilities which came with Windows, but are legacy now and almost nobody cares
    } Else {
        Remove-CapabilitiesList -Revert
    }
}

Main