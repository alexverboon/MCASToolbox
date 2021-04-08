<#
.Synopsis
   Get-MCASIPRange 
.DESCRIPTION
   Lists all the registered IP ranges or the specified one
.EXAMPLE
   Get-MCASIPRange 

   List all registered IP ranges in MCAS

.EXAMPLE
    Get-MCIPRange -IPRangeName AlexHome

    List the IP range with the specified IP range name

#>
    [CmdletBinding()]
    Param
    (
        # MCAS IP Range Name
        [Parameter(Mandatory=$false)]
        [String]$IPRangeName
     )

    Begin
    {
        If(!$CASCredential){
            Write-Warning "You must first connect to MCAS" 
            Break
        }
	[System.Management.Automation.PSCredential]$Credential = $CASCredential

    }
    Process
    {
        If(!$IPRangeName){
             $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential
        }
        Else{
            $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential | Where-Object {$_.Name -like "$IPRangeName"}
        }
        $CurrentIPRanges | Select-Object Name,Location, Category, @{Name="Subnets";Expression={ $($_.subnets.originalString)}},@{Name="Tags";Expression={ $($_.Tags.Name)}}
    }
    End{
    }
