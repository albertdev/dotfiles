@{
    ModuleVersion = "0.0.1"
    PowerShellVersion = "5.0"
    ClrVersion = "4.0"
    RootModule = "SqlServerUtils.psm1"
	Description = 'Personal collection of Powershell functions to query a SQL Server LocalDB instance (default)'

    FunctionsToExport = @(
        'Get-DBNames',
        'Get-DBTables',
        'Get-DBColumns'
	)

	#FormatsToProcess  = @('WebVideoUtils.format.ps1xml')

	PrivateData = @{
        PSData = @{
        }
    }
}
