<#
.Synopsis
   Add-MCASIPRange
.DESCRIPTION
   Add MCASIPRange registers a new IP range in Microsoft Cloud App Security.

.PARAMETER IPRangeName
    The name of the IP Range

.PARAMETER Category
    Defines the IP Range category, possible values are: "Corporate', 'Administrative','Risky','VPN','Cloud provider' or 'Other'

.PARAMETER IPRangeTag
    Tag associated with the IP Range

.PARAMETER IPRangeFile
    External text file that contains the IP addresses or IP subnets to register

    Example: IPRange.txt with the following content:
    10.0.0.1/8
    10.0.0.2/8

.PARAMETER IPRangeSubnet
    The IP subnets to register, use this option when you only have 1 or 2 subnets to register, otherwise use the IPRangeFile opton. 

.EXAMPLE
        Add-MCASIPRange -IPRangeName "Sample06" -IPRangeCategory Corporate -IPRangeTag "Tag06" -IPRangeSubnet "10.1.0.3/32","10.1.0.2/32"

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

        # MCAS IP Range Tag
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$IPRangeTag,

        # MCAS IP Range source file
        [Parameter(Mandatory=$true,ParameterSetName = 'InputFile')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            return $true
        })]
        [System.IO.FileInfo]$IPRangeFile,
        # MCAS IP Range value
        [Parameter(Mandatory=$true,ParameterSetName = 'IpRangeInputParam')]
        ##[ValidateNotNullOrEmpty()]
        [array]$IPRangeSubnet
    )
    Begin
    {
        If(!$CASCredential)
        {
            Write-Warning "You must first connect to MCAS" 
            Break
        }
	    [System.Management.Automation.PSCredential]$Credential = $CASCredential

        If($IPRangeSubnet){
            Write-Verbose "Using $IPRangeSubnets as input"
            $IPRangeSubnetInput = $IPRangeSubnet 
        }

        If($IPRangeFile){
            Write-Verbose "Using file: $IPRangeFile as input"
            $IPRangeSubnetInput = Get-Content -Path $IPRangeFile
        }
    }
    Process
    {
     if ($pscmdlet.ShouldProcess("Microsoft Cloud App Security", "Adding IPRange $IPRangeName"))
     {
        Try{
            New-MCASSubnetCollection -Credential $Credential -Name $IPRangeName -Category $IPRangeCategory -Tags $IPRangeTag -Subnet $IPRangeSubnetInput 
        }
        Catch{
            Write-Warning $error[0]
            }
        }
    }
    End
    {}