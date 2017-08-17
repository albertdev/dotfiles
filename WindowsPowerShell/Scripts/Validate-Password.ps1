Add-Type -path .\Microsoft.AspNet.Identity.Core.dll

$hasher = New-Object -TypeName 'Microsoft.AspNet.Identity.PasswordHasher'
$hasher.VerifyHashedPassword('pwhash', 'passwordtoverify')
