# Set the base directory
$BaseDirectory = "E:\Api-db"

# Set the target subfolder inside each main subfolder
$TargetSubfolder = "Backups"

# Initialize an array to store results
$FileDetails = @()

# Loop through each subfolder in the base directory
foreach ($Folder in Get-ChildItem -Path $BaseDirectory -Directory) {
    # Define the full path to the 'Backups' folder inside each subfolder
    $TargetPath = Join-Path -Path $Folder.FullName -ChildPath $TargetSubfolder

    # Check if the 'Backups' folder exists
    if (Test-Path $TargetPath) {
        # Get the latest ZIP file
        $LatestZip = Get-ChildItem -Path $TargetPath -Filter "*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

        # Get the latest TXT file
        $LatestTxt = Get-ChildItem -Path $TargetPath -Filter "*.txt" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

        # Store details in an array
        $FileDetails += [PSCustomObject]@{
            Subfolder    = $Folder.Name
            LatestZip    = if ($LatestZip) { $LatestZip.Name } else { "No ZIP found" }
            ZipDate      = if ($LatestZip) { $LatestZip.LastWriteTime } else { "N/A" }
            ZipSizeKB    = if ($LatestZip) { [math]::Round($LatestZip.Length / 1KB, 2) } else { "N/A" }
            LatestTxt    = if ($LatestTxt) { $LatestTxt.Name } else { "No TXT found" }
            TxtDate      = if ($LatestTxt) { $LatestTxt.LastWriteTime } else { "N/A" }
            TxtSizeKB    = if ($LatestTxt) { [math]::Round($LatestTxt.Length / 1KB, 2) } else { "N/A" }
        }
    }
}

# Display the results in a formatted table
$FileDetails | Format-Table -AutoSize
