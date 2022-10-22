@{
    ModuleVersion = "0.0.1"
    PowerShellVersion = "5.0"
    ClrVersion = "4.0"
    RootModule = "WebVideoUtils.psm1"
	Description = 'Personal collection of Powershell functions to make yt-dlp easier to use in PS'

    FunctionsToExport = @(
        'Backup-Video',
        'List-VideoSubtitle',
        'Backup-VideoDescription',
        'Backup-VideoSubtitle'
	)

	#FormatsToProcess  = @('WebVideoUtils.format.ps1xml')

	PrivateData = @{
        PSData = @{
        }
    }
}
