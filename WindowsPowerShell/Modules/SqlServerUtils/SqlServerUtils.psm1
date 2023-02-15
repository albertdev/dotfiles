#
# Script module for module 'SqlServerUtils'
#
Set-StrictMode -Version Latest

Function Get-DBNames {
    param(
        [Parameter(Mandatory = $false)]
        [string]$ServerInstance = "(localdb)\MSSQLLocalDB",

        [parameter(Mandatory = $false, ValueFromRemainingArguments=$true)]
        [string[]]$Filter
    )
    # Build filter query
    if ($Filter -and $Filter.Count -gt 1) {
    }

    Invoke-Sqlcmd -ServerInstance $ServerInstance -Database master -Query "SELECT name FROM dbo.sysdatabases"
}

Function Get-DBTables {
    param(
        [Parameter(Mandatory = $false)]
        [string]$ServerInstance = "(localdb)\MSSQLLocalDB",

        [Parameter(Mandatory = $true)]
        [string]$Database,

        [parameter(Mandatory = $false, ValueFromRemainingArguments=$true)]
        [string[]]$Filter
    )

    # Build filter query
    if ($Filter -and $Filter.Count -gt 1) {
    }
    #Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT DISTINCT TABLE_SCHEMA AS SchemaName,TABLE_NAME AS TableName FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME like '%Pers%' ORDER BY SchemaName,TableName"
    Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT DISTINCT TABLE_SCHEMA AS SchemaName,TABLE_NAME AS TableName FROM INFORMATION_SCHEMA.COLUMNS ORDER BY SchemaName,TableName"
}

Function Get-DBColumns {
    param(
        [Parameter(Mandatory = $false)]
        [string]$ServerInstance = "(localdb)\MSSQLLocalDB",

        [Parameter(Mandatory = $true)]
        [string]$Database,

        # TODO: Make optional
        [Parameter(Mandatory = $true)]
        [string]$TableName,

        [parameter(Mandatory = $false, ValueFromRemainingArguments=$true)]
        [string[]]$Filter
    )

    # Build filter query
    if ($Filter -and $Filter.Count -gt 1) {
    }
    Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $Database -Query "SELECT TABLE_SCHEMA AS SchemaName,TABLE_NAME AS TableName,COLUMN_NAME AS ColumnName FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME like '%$TableName%' ORDER BY SchemaName,TableName,ColumnName"
}



Export-ModuleMember -Function 'Get-DBNames', 'Get-DBTables', 'Get-DBColumns'

