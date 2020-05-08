# install-module navcontainerhelper -force

# Login to Azure
# az login
$azDownload = az artifacts universal download `
  --organization "https://dev.azure.com/Notora/" `
  --project "e5e5fc37-d4b5-415f-8d05-ed6745719bd5" `
  --scope project `
  --feed "Licenses" `
  --name "bc-16" `
  --version "1.0.0" `
  --path Build/Docker
$licensefile = ($azDownload | ConvertFrom-Json).Description
$licensepath = Join-Path "./Build/Docker/" $licensefile

# set accept_eula to $true to accept the eula found here: https://go.microsoft.com/fwlink/?linkid=861843
$accept_eula = $true

$containername = 'pegboard'
$navdockerimage = 'mcr.microsoft.com/businesscentral/sandbox:dk'
$appbacpacuri = ''
$tenantbacpacuri = ''

$additionalParameters = @()
if ($appbacpacuri -ne '' -and $tenantbacpacuri -ne '') {
    $additionalParameters = @("--env appbacpac=""$appbacpacuri""","--env tenantBacpac=""$tenantbacpacuri""", "--restart no")
}
$additionalParameters = @("-m 5G")

$secpasswd = ConvertTo-SecureString "password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("admin", $secpasswd)
New-BcContainer -accept_eula:$accept_eula `
                 -accept_outdated:$true `
                 -containername $containername `
                 -auth "NavUserPassword" `
                 -Credential $credential `
                 -alwaysPull `
                 -doNotExportObjectsToText `
                 -enableTaskScheduler `
                 -usessl:$false `
                 -updateHosts `
                 -assignPremiumPlan `
                 -imageName $navdockerimage `
                 -licenseFile $licensepath `
                 -shortcuts None `
                 -additionalParameters $additionalParameters 

Remove-Item -Path $licensepath
                 
# Prevent container from starting after reboot
docker update $containername --restart unless-stopped

Setup-NavContainerTestUsers -containerName $containername -credential $credential -password $credential.Password
