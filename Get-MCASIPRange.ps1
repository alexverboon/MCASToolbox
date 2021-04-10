<#
.Synopsis
   Get-MCASIPRange 
.DESCRIPTION
   Lists all the registered IP ranges or the specified one
.PARAMETER IPRangeName
    The name of the IP Range
.PARAMETER Detailed
    Lists all IP Address ranges with detailed IP address information
    
.EXAMPLE
   Get-MCASIPRange 

   List all registered IP ranges in MCAS

.EXAMPLE
    Get-MCIPRange -IPRangeName AlexHome

    List the IP range with the specified IP range name

.EXAMPLE 
    
   Get-MCASIPRange -Detailed

   Name     Category  Location    IP
    ----     --------  --------    --
    AlexHome Corporate Switzerland 77.56.152.129/32
    Sample06 Corporate             10.1.0.3/32
    Sample06 Corporate             10.1.0.2/32

#>
    [CmdletBinding()]
    Param
    (
        # MCAS IP Range Name
        [Parameter(Mandatory=$false)]
        [String]$IPRangeName,
        [switch]$Detailed

     )
    Begin{
        If(!$CASCredential){
            Write-Warning "You must first connect to MCAS" 
            Break
        }
	    [System.Management.Automation.PSCredential]$Credential = $CASCredential
    }
    Process{
        If(!$IPRangeName){
            $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential
        }
        Else{
            $CurrentIPRanges = Get-MCASSubnetCollection -Credential $Credential | Where-Object {$_.Name -like "$IPRangeName"}
        }
        If(!($Detailed)){
            $CurrentIPRanges | Select-Object Name, 
            @{Name="Location";Expression={ $($_.location.name)}},
            @{Name="Category";Expression={ switch($_.Category) { "1" {"Corporate"}
                                                                "2" {"Administrative"}
                                                                "3" {"Risky"}
                                                                "4" {"VPN"}
                                                                "5" {"Cloud Provider"}
                                                                "6" {"Other"}  }}}, 
            @{Name="Subnets";Expression={ $($_.subnets.originalString)}},@{Name="Tags";Expression={ $($_.Tags.Name)}}
        }
        else{
            $IPRangeData = [System.Collections.Generic.List[Object]]::new()
            ForEach($entry in $CurrentIPRanges)
            {
                switch($entry.category){ 
                "1" {$xcategory = "Corporate"}
                "2" {$xcategory = "Administrative"}
                "3" {$xcategory = "Risky"}
                "4" {$xcategory = "VPN"}
                "5" {$xcategory = "Cloud Provider"}
                "6" {$xcategory = "Other"}
                }

                ForEach($IPentry in $entry.Subnets)
                {
                    $object = [PSCustomObject]@{
                        Name = $entry.name
                        Category = $xcategory
                        Location = $entry.Location.Name
                        IP = $IPentry.originalString
                    }
                    [void]$IPRangeData.Add($object)
                }
            }
        }
        $IPRangeData
    }
    End{}


    