# Aplica todos os manifests da pasta k8s/ na ordem certa e espera tudo ficar pronto.
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\03-deploy.ps1

$ErrorActionPreference = "Stop"
$raiz = Split-Path -Parent $PSScriptRoot
$k8s = Join-Path $raiz "k8s"
$ns = "ecommerce"

function Aplicar($arquivo) {
    kubectl apply -f $arquivo
    if ($LASTEXITCODE -ne 0) { throw "Falha ao aplicar $arquivo" }
}

Write-Host "==> Esperando o Ingress Controller ficar pronto (evita erro ao criar os Ingress)..." -ForegroundColor Cyan
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=180s
if ($LASTEXITCODE -ne 0) {
    Write-Host "Aviso: o Ingress Controller ainda nao esta pronto. Se der erro nos Ingress, espere 1 minuto e rode este script de novo." -ForegroundColor Yellow
}

Write-Host "==> Criando o namespace..." -ForegroundColor Cyan
Aplicar (Join-Path $k8s "00-namespace.yaml")

$pastas = @("auth", "estoque", "pedido", "gateway", "observabilidade\prometheus", "observabilidade\grafana")
# Ordem: permissoes e configuracoes primeiro, depois bancos, servicos e aplicacoes.
$tipos = @("rbac", "configmap", "secret", "postgres", "service", "deployment", "ingress")

foreach ($tipo in $tipos) {
    foreach ($pasta in $pastas) {
        $arquivo = Join-Path $k8s "$pasta\$tipo.yaml"
        if (Test-Path $arquivo) {
            Write-Host "==> $pasta\$tipo.yaml" -ForegroundColor DarkGray
            Aplicar $arquivo
        }
    }
}

Write-Host ""
Write-Host "==> Esperando os pods ficarem prontos (ate 4 minutos cada)..." -ForegroundColor Cyan
foreach ($d in @("estoque-db", "pedido-db", "estoque-service", "pedido-service", "auth-service", "api-gateway", "prometheus", "grafana")) {
    kubectl rollout status "deployment/$d" -n $ns --timeout=240s
    if ($LASTEXITCODE -ne 0) {
        Write-Host "O deployment $d nao ficou pronto. Veja: kubectl describe pod -l app=$d -n $ns" -ForegroundColor Red
        throw "Deploy incompleto"
    }
}

Write-Host ""
kubectl get pods -n $ns
Write-Host ""
Write-Host "Tudo no ar. Proximo passo: scripts\05-testar-fluxo.ps1 (ou 04-status.ps1)" -ForegroundColor Green
