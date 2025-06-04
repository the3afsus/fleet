# Import the WSUS module
Import-Module UpdateServices
# Connect to the WSUS server
$wsusServer = Get-WSUSServer -Name "YourWSUSServerName" -Port 8530
# Specify the date range (last three years)
$startDate = (Get-Date).AddYears(-3)
# Get the computer groups you want to report on
$computerGroups = $wsusServer.GetComputerTargetGroups() | Where-Object { $_.Name -eq "YourComputerGroupName" }
# Get updates that were installed in the specified date range
$updates = $wsusServer.GetUpdates() | Where-Object { $_.UpdateClassificationTitle -eq "Updates" -and $_.CreationDate -ge $startDate }
# Create an empty array to store the report data
$reportData = @()
# Iterate through each update and get the installation status for each computer group
foreach ($update in $updates) {
    foreach ($group in $computerGroups) {
        $statusSummary = $update.GetUpdateInstallationInfoPerComputerTargetGroup($group.Id)
        foreach ($status in $statusSummary) {
            $reportData += [PSCustomObject]@{
                'ComputerGroup' = $group.Name
                'UpdateTitle' = $update.Title
                'UpdateDate' = $update.CreationDate
                'Installed' = $status.InstalledCount
                'NotInstalled' = $status.NotInstalledCount
                'Unknown' = $status.UnknownCount
            }
        }
    }
}
# Export the report data to a CSV file
$reportData | Export-Csv -Path "C:\Path\To\Export\WSUSReport.csv" -NoTypeInformation
Write-Host "WSUS report generated and exported successfully."
