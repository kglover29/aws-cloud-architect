<powershell>
//
//  This script does the following:
//  - installs IIS
//  - downloads website content
//

Write-Output "Install IIS"
Install-WindowsFeature -name Web-Server

Write-Output "Downloading web documents"
Copy-S3Object -BucketName kglover-aws-cloud-architect -Key  -LocalFolder c:\Inetpub\wwwroot

</powershell>
