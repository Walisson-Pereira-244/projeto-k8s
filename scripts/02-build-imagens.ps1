# Constroi as 4 imagens Docker DENTRO do Minikube (ele nao enxerga as imagens do Docker comum).
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\02-build-imagens.ps1
# Rode de novo sempre que mudar o codigo de algum servico.

$ErrorActionPreference = "Stop"
$raiz = Split-Path -Parent $PSScriptRoot

Write-Host "==> Apontando o Docker para dentro do Minikube..." -ForegroundColor Cyan
minikube -p minikube docker-env --shell powershell | Invoke-Expression

foreach ($servico in @("api-gateway", "auth-service", "estoque-service", "pedido-service")) {
    Write-Host "==> Construindo ${servico}:1.0" -ForegroundColor Cyan
    docker build -t "${servico}:1.0" (Join-Path $raiz $servico)
    if ($LASTEXITCODE -ne 0) { throw "Falha ao construir $servico" }
}

Write-Host ""
docker images --filter "reference=*-service" --filter "reference=api-gateway"
Write-Host ""
Write-Host "Imagens prontas. Proximo passo: scripts\03-deploy.ps1" -ForegroundColor Green
