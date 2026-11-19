# Confere se as ferramentas necessarias estao instaladas e se o Docker esta ligado.
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\00-verificar-ferramentas.ps1

$ok = $true
foreach ($cmd in @("docker", "minikube", "kubectl", "git")) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        Write-Host "[OK]    $cmd encontrado" -ForegroundColor Green
    } else {
        Write-Host "[FALTA] $cmd nao encontrado" -ForegroundColor Red
        $ok = $false
    }
}

if (Get-Command docker -ErrorAction SilentlyContinue) {
    docker info *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK]    Docker Desktop esta ligado" -ForegroundColor Green
    } else {
        Write-Host "[FALTA] Docker Desktop esta fechado: abra o programa e espere ficar verde" -ForegroundColor Red
        $ok = $false
    }
}

if (-not $ok) {
    Write-Host ""
    Write-Host "Para instalar o que falta (PowerShell como Administrador):"
    Write-Host "  winget install Kubernetes.minikube"
    Write-Host "  winget install Kubernetes.kubectl"
    Write-Host "Depois feche e abra o terminal de novo."
    exit 1
}
Write-Host ""
Write-Host "Tudo pronto. Proximo passo: scripts\01-iniciar-cluster.ps1" -ForegroundColor Cyan
