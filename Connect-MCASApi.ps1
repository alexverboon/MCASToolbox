<#
.Synopsis
    Connect-MCASApi

.DESCRIPTION
    Connect-MCASAPI imports a set of credentials into your session (or, optionally, a variable) to be used by other
    Cloud App Security Toolbox functions.

    When using Connect-MCASApi you will need to provide your Cloud App Security tenant URL as well as an OAuth
    Token that must be created manually in the console.

    Connect-MCASApi takes the tenant URL and OAuth token and stores them in a special global session variable
    called $CASCredential and converts the OAuth token to a 64-bit secure string while in memory.

    All MCAS Toolbox functions reference that special global variable to pass requests to your Cloud App Security tenant.

.PARAMETER MCASToken
    The tenant OAuth token generated within the MCAS portal

.PARAMETER MCASUrl
    Specifies the portal URL of your MCAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
   

.EXAMPLE
    $mcastoken = 432c1750f80d66a1cf2849afb6b10a7fcdf6738f5f554e32c9915fb006bd799a"
    $mcasurl = "contoso.portal.cloudappsecurity.com"
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
