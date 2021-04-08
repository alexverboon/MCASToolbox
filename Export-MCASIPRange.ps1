<#
.Synopsis
  Export-MCASIpRange
.DESCRIPTION
  Exports all IP ranges registered in mcas to a json formatted file
.EXAMPLE
  Export-MCASIPRange -ExportFolder c:\temp

#>
    [CmdletBinding()]
    Param
    (
        # MCAS export folder
        [Parameter(Mandatory=$true)]
        [string]$ExportFolder
    )
    Begin
    {
        If(!$CASCredential)
        {
            Write-Warning "You must first connect to MCAS" 
            Break
        }
	[System.Management.Automation.PSCredential]$Credential = $CASCredential
    }
    Process
    {
        $ReportTime = Get-Date -Format "yyyy-MM-dd_HH-mm"
        $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential
        ForEach($IPR in $CurrentIPRanges)
        {
            Write-Verbose "Exporting MCAS IP Range: $($IPR.Name) to $ExportFolder\$($IPR.Name)-$ReportTime.json"
            $IPR | ConvertTo-Json  | Out-File "$ExportFolder\$($IPR.Name)$ReportTime.json" -Force
        }
    }
    End
    {
    }
