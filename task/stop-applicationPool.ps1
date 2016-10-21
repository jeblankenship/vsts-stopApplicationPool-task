[CmdletBinding()]
param(
    [string]$server,
    [string]$appPoolName
)

Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

Write-Verbose "Entering script $($MyInvocation.MyCommand.Name)"
Write-Verbose "Parameter Values"
$PSBoundParameters.Keys | % { Write-HOST "  ${_} = $($PSBoundParameters[$_])" }
$command = {
    param(
        [string]$appPoolName
    )
    Import-Module WebAdministration
    Write-Host "Stop Application Pool Task: Starting..."
    $appPoolPath = "IIS:\AppPools\$AppPoolName"    
    if(Test-Path $appPoolPath) {
        Write-Host "Checking Application Pool State..."
	    $ApplicationPoolStatus = Get-WebAppPoolState $appPoolName
        if ($ApplicationPoolStatus.Value -ne "Stopped")
	    {
            Write-Host "Stopping application pool: $appPoolName"
            Stop-WebAppPool -Name $appPoolName
	    } else {
            Write-Host "Application pool already stopped."
        }
    } else {
        Write-Host "Application pool not found: $appPoolName"
    }
    Write-Host "Application Pool Stop Task: Completed"
}
Invoke-Command -ComputerName $server $command -ArgumentList $appPoolName
