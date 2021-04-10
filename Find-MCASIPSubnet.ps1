<#
.Synopsis
    Find-MCASIPSubnet
.DESCRIPTION
    Find-MCASIPSubnett searches the specified IP Address in all registered MCAS IP ranges
.PARAMETER IPAddress
    IP Address
.EXAMPLE
    .\Find-MCASIPSubnet.ps1 -IPAddress 77.56.162.123
#>
    [CmdletBinding()]
    Param
    (
        # IP Address
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [string]
        $IPAddress
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
    Process{
        $IPSubnetData = [System.Collections.ArrayList]::new()
        $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential
        ForEach($IPR in $CurrentIPRanges)
        {
            ForEach($subn in $IPR.subnets.originalString){
                $object =[PSCustomObject]@{
                IPRangeName = $IPR.name
                Subnet = $subn}        
                [void]$IPSubnetData.Add($object)
            }
        }
        $Result = $IPSubnetData | Where-Object {$_.subnet -like "*$IPAddress*"}
        If([string]::IsNullOrEmpty($Result))
        { Write-Warning "No registered IP range found in MCAS with IP Address $IPAddress"}
        Else{
            $Result
        }
    }
    End{}
