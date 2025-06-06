# Définir le chemin vers le dossier SYSVOL Policies
$domain = (Get-ADDomain).DNSRoot
$sysvolPath = "\\$domain\SYSVOL\$domain\Policies"

# Récupérer les GPOs (chaque sous-dossier correspond à un GUID de GPO)
$gpoFolders = Get-ChildItem -Path $sysvolPath -Directory

# Rechercher les paramètres WSUS dans chaque GPO
foreach ($gpo in $gpoFolders) {
    $gptIniPath = Join-Path $gpo.FullName "GPT.INI"
    $machineRegPath = Join-Path $gpo.FullName "Machine\Microsoft\Windows NT\SecEdit\GptTmpl.inf"
    $registryPolPath = Join-Path $gpo.FullName "Machine\Registry.pol"

    Write-Host "`nInspecting GPO: $($gpo.Name)"

    # Vérifier si Registry.pol existe (paramètres de stratégie de registre)
    if (Test-Path $registryPolPath) {
        # Extraire les clés WSUS du fichier Registry.pol
        $tmp = "$env:TEMP\regpol_$($gpo.Name).txt"

        # Convert Registry.pol to readable text using LGPO tool if available (optional)
        if (Get-Command .\LGPO.exe -ErrorAction SilentlyContinue) {
            .\LGPO.exe /parse /m $registryPolPath /n > $tmp
            Select-String -Path $tmp -Pattern "WindowsUpdate", "WUServer", "WUStatusServer" |
                ForEach-Object {
                    Write-Host "  $_"
                }
            Remove-Item $tmp
        }
        else {
            Write-Warning "  Cannot read Registry.pol without LGPO.exe (Microsoft LocalGPO utility)."
        }
    }
    else {
        Write-Host "  No Registry.pol found in Machine folder."
    }
}
