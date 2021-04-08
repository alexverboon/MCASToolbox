<#
.Synopsis
   Connect-MCASApi
.DESCRIPTION
   Connect-MCASAPI connects with Microsoft Cloud App Security
.EXAMPLE
    $mcastoken = "YOUR TOKEN"
    $mcasurl = "eCorp.eu2.portal.cloudappsecurity.com"
    .\Connect-MCASApi.ps1 -MCASToken $MCASToken -MCASUrl $mcasurl
#>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCredential])]
    Param
    (
        # MCAS Token generated in the MCAS portal
        [Parameter(Mandatory=$true)]
        $MCASToken,
        # MCAS instance URL
        [Parameter(Mandatory=$true)]
        $MCASUrl
    )
    Begin
    {
        $ModuleName = "MCAS"
        if (Get-Module -ListAvailable -Name $ModuleName){
            Write-output "Module $ModuleName is present"
        }else{
            Write-Warning "Module $ModuleName does not exist, install the module using the following command: Install-Module -Scope CurrentUser"
        }
    }
    Process
    {
        $User=$MCASUrl
        $PWord=ConvertTo-SecureString -String "$MCASToken" -AsPlainText -Force
	[System.Management.Automation.PSCredential]$Global:CASCredential=New-Object -TypeName System.Management.Automation.PSCredential -argumentList $User, $PWord

        Try{
            $Conf=Get-MCASConfiguration -Credential $CASCredential -ErrorAction Stop
            If(-not ([string]::IsNullOrEmpty($Conf))){
                Write-verbose "Connection to MCAS $MCASUrl OK!"
        	$CASCredential
            }
        }Catch{
            write-error "Can't run the MCAS cmdlet Get-MCASConfiguration, something isn't working!"
        }
    }
    End
    {
    }
