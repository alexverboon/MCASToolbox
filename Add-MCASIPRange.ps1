<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
        Add-MCASIPRange -IPRangeName "Sample06" -IPRangeCategory Corporate -IPRangeTag "Tag06" -IPRangeSubnets "10.1.0.3/32","10.1.0.2/32"

.EXAMPLE
        Add-MCASIPRange -IPRangeName "Sample04" -IPRangeCategory Corporate -IPRangeTag "Tag04" -IPRangeFile C:\data\MCAS\IPRanges.txt
  
#>
    [CmdletBinding(DefaultParameterSetName = 'IpRangeInputParam', SupportsShouldProcess=$true)]
    Param
    (
        # MCAS IP Range Name
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$IPRangeName,

        # MCAS IP Range Category
        [Parameter(Mandatory=$true)]
        [ValidateSet('Corporate', 'Administrative','Risky','VPN','Cloud provider','Other')]
        [string]$IPRangeCategory,

        # MCAS IP Range Category
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$IPRangeTag,

        # MCAS IP Range from file
        [Parameter(Mandatory=$true,ParameterSetName = 'InputFile')]
        [ValidateNotNullOrEmpty()]
        [string]$IPRangeFile,

        # MCAS IP Range value
        [Parameter(Mandatory=$true,ParameterSetName = 'IpRangeInputParam')]
        ##[ValidateNotNullOrEmpty()]
        [array]$IPRangeSubnets
    )

    Begin
    {
        If(!$CASCredential)
        {
            Write-Warning "You must first connect to MCAS" 
            Break
        }
	[System.Management.Automation.PSCredential]$Credential = $CASCredential

        If($IPRangeSubnets){
            Write-Verbose "Using $IPRangeSubnets as input"
            $IPRangeSubnetsInput = $IPRangeSubnets 
        }

        If($IPRangeFile){
            Write-Verbose "Using $IPRangeFile as input"
            $IPRangeSubnetsInput = Get-Content -Path $IPRangeFile
        }
    }
    Process
    {
     if ($pscmdlet.ShouldProcess("Microsoft Cloud App Security", "Adding IPRange $IPRangeName"))
     {
        Try{
            New-MCASSubnetCollection -Credential $Credential -Name $IPRangeName -Category $IPRangeCategory -Tags $IPRangeTag -Subnets $IPRangeSubnetsInput 
        }
        Catch{
            Write-Warning $error[0]
        }
        }
    }
    End
    {
    }

