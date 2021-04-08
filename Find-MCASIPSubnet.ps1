
<#
.Synopsis
   Find-MCASIPSubnet searches the specified IP subnet in all registered MCAS IP ranges
.DESCRIPTION
Find-MCASIPSubnett searches the specified IP subnet in all registered MCAS IP ranges
.EXAMPLE
.\Find-MCASIPSubnet.ps1 -IPSubnet 77.56.162.123
#>

    [CmdletBinding()]
    Param
    (
        # IP Subnet
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [string]
        $IPSubnet
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
        $IPSubnetData = [System.Collections.ArrayList]::new()
        $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential
        ForEach($IPR in $CurrentIPRanges)
        {
            ForEach($subn in $IPR.subnets.originalString)
            {
                $object =[PSCustomObject]@{
                IPRangeName = $IPR.name
                Subnet = $subn
                }        
                [void]$IPSubnetData.Add($object)
            }
        }

        $Result = $IPSubnetData | Where-Object {$_.subnet -like "*$IPSubnet*"}
        If([string]::IsNullOrEmpty($Result))
        { Write-Warning "No registered IP range found in MCAS with $IPSubnet"}
        Else
        {
            $Result
        }
    }
    End
    {
    }
