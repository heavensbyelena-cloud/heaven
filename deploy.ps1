# Script de deploiement Cloudflare - Contourne les problemes EPERM sur Windows
# Execute ce script au lieu de "npm run deploy"

Write-Host "=== Preparation du deploiement ===" -ForegroundColor Cyan

# 1. Supprimer .open-next (evite EPERM au debut du build)
Write-Host "`n1. Nettoyage du dossier .open-next..." -ForegroundColor Yellow
$openNextPath = Join-Path $PSScriptRoot ".open-next"

if (Test-Path $openNextPath) {
    # Methode 1: Remove-Item
    try {
        Remove-Item -Path $openNextPath -Recurse -Force -ErrorAction Stop
        Write-Host "   Suppression reussie." -ForegroundColor Green
    } catch {
        # Methode 2: cmd rmdir (parfois plus efficace sur Windows)
        Write-Host "   Methode 1 echouee, tentative avec cmd..." -ForegroundColor Yellow
        $cmdResult = cmd /c "rmdir /s /q `"$openNextPath`""
        if (Test-Path $openNextPath) {
            Write-Host "`nERREUR: Impossible de supprimer .open-next" -ForegroundColor Red
            Write-Host "Faites manuellement:" -ForegroundColor Yellow
            Write-Host "  1. Fermez TOUS les terminaux et Cursor" -ForegroundColor White
            Write-Host "  2. Ouvrez l'Explorateur de fichiers" -ForegroundColor White
            Write-Host "  3. Supprimez le dossier .open-next dans: $PSScriptRoot" -ForegroundColor White
            Write-Host "  4. Relancez: npm run deploy" -ForegroundColor White
            exit 1
        }
    }
} else {
    Write-Host "   Dossier .open-next absent (OK)." -ForegroundColor Green
}

# 2. Deploy
Write-Host "`n2. Lancement du deploiement..." -ForegroundColor Yellow
Set-Location $PSScriptRoot
npm run deploy
