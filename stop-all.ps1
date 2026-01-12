<#
.SYNOPSIS
    Stoppt alle MCP Server
.DESCRIPTION
    Beendet alle laufenden MCP Server Prozesse auf Ports 8001, 8003, 8004
#>

Write-Host "=== MCP Connector Stopper ===" -ForegroundColor Cyan
Write-Host ""

$ports = @(8001, 8003, 8004)
$stoppedCount = 0

foreach ($port in $ports) {
    Write-Host "Suche Prozesse auf Port $port..." -ForegroundColor Yellow
    
    # Finde Prozess auf diesem Port
    $connections = netstat -ano | Select-String ":$port\s" | Select-String "LISTENING"
    
    foreach ($conn in $connections) {
        $parts = $conn -split '\s+' | Where-Object { $_ -ne '' }
        $pid = $parts[-1]
        
        if ($pid -match '^\d+$') {
            try {
                $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
                if ($process) {
                    Write-Host "  Stoppe Prozess $($process.Name) (PID: $pid)..." -ForegroundColor Gray
                    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
                    $stoppedCount++
                    Write-Host "  OK Prozess beendet" -ForegroundColor Green
                }
            }
            catch {
                Write-Host "  Fehler beim Beenden von PID $pid" -ForegroundColor Red
            }
        }
    }
}

Write-Host ""
if ($stoppedCount -gt 0) {
    Write-Host "$stoppedCount Prozess(e) beendet." -ForegroundColor Green
} else {
    Write-Host "Keine laufenden MCP Server gefunden." -ForegroundColor Yellow
}
