# Liga o Minikube (cluster local) e os addons necessarios.
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\01-iniciar-cluster.ps1
# Parametros opcionais (computador mais fraco):  -Memoria 3072 -Cpus 2

param(
    [int]$Memoria = 4096,
    [int]$Cpus = 4
)

function Executar($texto, [scriptblock]$comando) {
    Write-Host "==> $texto" -ForegroundColor Cyan
    & $comando
    if ($LASTEXITCODE -ne 0) { throw "Falhou: $texto" }
}

Executar "Iniciando o Minikube (pode demorar na primeira vez)..." { minikube start --driver=docker --cpus=$Cpus --memory=$Memoria }
Executar "Ligando o Ingress (porta de entrada do cluster)..." { minikube addons enable ingress }
Executar "Ligando o metrics-server (usado pelo autoscaling opcional)..." { minikube addons enable metrics-server }

Write-Host ""
kubectl get nodes
Write-Host ""
Write-Host "Cluster no ar. Proximo passo: scripts\02-build-imagens.ps1" -ForegroundColor Green
