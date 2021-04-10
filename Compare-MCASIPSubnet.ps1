<#
.Synopsis
   Compare-MCASIPSubnet
.DESCRIPTION
   Compares the registered IP Subnets in MCAS with a list of subnets stored in a txt file
.PARAMETER IPRangeName
    The name of the IP Range as registered in the MCAS console
.PARAMETER IPRangeFile
  External text file that contains the IP addresses or IP subnets that is used to compare the subnets registered in the specified IPRange in MCAS.

    Example: IPRange.txt with the following content:
    77.56.162.129/32
    10.0.0.1/24
    10.0.0.2/24
    10.0.0.3/24

.EXAMPLE
    .\Compare-MCASIPSubnet.ps1 -IPRangeName AlexHome -IPRangeFile .\IPRanges.txt

    IPAddress        Result
    ---------        ------
    77.56.162.129/32 Present
    10.0.0.1/24      Missing in MCAS
    10.0.0.2/24      Missing in MCAS
    10.0.0.3/24      Missing in MCAS
    138.224.20.10/16 missing in File
#>
    [CmdletBinding()]
    Param
    (
        # MCAS IP Range Name
        [Parameter(Mandatory=$true)]
        [String]$IPRangeName,
        # IP subnet reference file
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            return $true
        })]
        [System.IO.FileInfo]$IPRangeFile
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
        $TargetRange = Get-Content -Path "$IPRangeFile"
        $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential
        $RegisteredRange = $CurrentIPRanges| Select-Object Name,Subnets| Where-Object {$_.Name -like "$IPRangeName"}
        If(-not([string]::IsNullOrEmpty($RegisteredRange))){
            $SourceRange = $RegisteredRange.subnets | Select-Object -ExpandProperty originalstring
            # Compare registered Subnets in MCAS with external file content
            $IpDiff = Compare-Object -ReferenceObject $SourceRange -DifferenceObject $TargetRange -IncludeEqual

            $CompareIPResult = [System.Collections.Generic.List[Object]]::new()
            ForEach ($IPentry in $IpDiff) {
                switch ($IPEntry.SideIndicator) {
                    "==" { $Result = "Present" }
                    "=>" { $Result = "Missing in MCAS" }
                    "<=" { $Result = "missing in reference file" }
                }
                $object = [PSCustomObject]@{
                    IPAddress    = $IPEntry.InPutObject
                    Result = $Result
                }
                [void]$CompareIPResult.Add($object)
            }    
            $CompareIPResult
        }
        Else{
            Write-Warning "No IP range found in MCAS with the name $IPRangeName"
        }
    }
    End
    {
    }
