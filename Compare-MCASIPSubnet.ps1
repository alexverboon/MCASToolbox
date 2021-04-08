
<#
.Synopsis
   Compares the registered IP Subnets in MCAS with a list of subnets stored in a txt file
.DESCRIPTION
   Compares the registered IP Subnets in MCAS with a list of subnets stored in a txt file
.EXAMPLE
.\Compare-MCASIPSubnet.ps1 -IPRangeName AlexHome -IPSubnetFile .\IPRanges.txt
#>
    [CmdletBinding()]

    Param
    (
        # MCAS IP Range Name
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true
                   )]
        [String]$IPRangeName,
        # IP subnet file
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true
                   )]
        [String]$IPSubnetFile
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
        $TargetRange = Get-Content -Path "$IPSubnetFile"
        $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential
        $RegisteredRange = $CurrentIPRanges| Select-Object Name,Subnets| Where-Object {$_.Name -like "$IPRangeName"}
        If(-not([string]::IsNullOrEmpty($RegisteredRange))){
            $SourceRange = $RegisteredRange.subnets | Select-Object -ExpandProperty originalstring
            # Compare registered Subnets in MCAS with external file content
            $IpDiff = Compare-Object -ReferenceObject $SourceRange -DifferenceObject $TargetRange 
            If([string]::IsNullOrEmpty($IpDiff)){
                Write-Output "No differences found in MCAS IP range: $IPRangeName and the file: $IPSubnetFile"
            }
            Else{
                $IpDiff
            }
        }
        Else{
            Write-Warning "No IP range found in MCAS with the name $IPRangeName"
        }
    }
    End
    {
    }
