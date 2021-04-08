# MCASToolbox
PowerShell scripts for managing Microsoft Cloud App Security

This repository contains scripts for managing Microsoft Cloud App Security. At present these
are indivdidual functions. 

---

## Get Started
1. First you must register an API token within the Microsoft Cloud App Security Console. 
You find instructions for this here [Managing API tokens](https://docs.microsoft.com/en-us/cloud-app-security/api-authentication)

2. Before you can run the MCAS Toolbox functions you must first connect with MCAS

```powershell
    $mcastoken = "<YOUR TOKEN GOES HERE>"
    $mcasurl = "eCorp.eu2.portal.cloudappsecurity.com"
    .\Connect-MCASApi.ps1 -MCASToken $MCASToken -MCASUrl $mcasurl
```

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
| 1.0.0   | 08.04.2021 | Initial Release                                                |


## TODO

- Import-MCASIpRange



