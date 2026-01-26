<#
.SYNOPSIS
    Einmalige Installation aller Dependencies für MCP Connector
.DESCRIPTION
    Installiert alle benötigten Python-Pakete in einer gemeinsamen venv
#>

$ErrorActionPreference = "Stop"

Write-Host "=== MCP Connector Setup ===" -ForegroundColor Cyan
Write-Host ""

# Prüfe ob uv installiert ist
try {
    $uvVersion = uv --version
    Write-Host "UV gefunden: $uvVersion" -ForegroundColor Green
} catch {
    Write-Host "FEHLER: uv ist nicht installiert!" -ForegroundColor Red
    Write-Host "Installiere uv mit: pip install uv" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Installiere alle Dependencies..." -ForegroundColor Yellow
Write-Host ""

# Installiere alle Dependencies mit uv
uv sync

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "Installation erfolgreich!" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Nächste Schritte:" -ForegroundColor White
    Write-Host "  1. Konfiguriere .env Datei" -ForegroundColor Gray
    Write-Host "  2. Starte alle Services mit: .\start-all.ps1" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "FEHLER: Installation fehlgeschlagen!" -ForegroundColor Red
    exit 1
}
