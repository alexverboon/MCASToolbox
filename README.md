# MCAS Toolbox

PowerShell scripts for managing Microsoft Cloud App Security

This repository contains scripts for managing Microsoft Cloud App Security.

---

## Get Started

1. First you must register an API token within the Microsoft Cloud App Security Console.
You find instructions for this here [Managing API tokens](https://docs.microsoft.com/en-us/cloud-app-security/api-authentication)

2. The MCAS Toolbox functions have a dependency on the MCAS PowerShell module.

```powershell
Install-Module -Name "MCAS" -Scope CurrentUser
```powershell

2. Before you can run the MCAS Toolbox functions you must first connect with MCAS

```powershell
    $mcastoken = "<YOUR TOKEN GOES HERE>"
    $mcasurl = "eCorp.eu2.portal.cloudappsecurity.com"
    .\Connect-MCASApi.ps1 -MCASToken $MCASToken -MCASUrl $mcasurl
```

If the previous steps completed successfully, you can run the following function to get a list of registered IP ranges in MCAS.

```powershell
   .\Get-MCIPRange -IPRangeName AlexHome
```

---

## Functions

* Add-MCASIPRange
* Compare-MCASIPSubnet
* Connect-MCASApi
* Export-MCASIpRange
* Find-MCASIPSubnet
* Get-MCASIPRange

---

## Release Notes

| Version |    Date    |                           Notes                                |
| ------- | ---------- | -------------------------------------------------------------- |
| 1.0.0   | 09.04.2021 | Initial Release                                                |

## TODO

* Import-MCASIpRange
