# Demonstracao guiada de replicas, escalabilidade e auto-recuperacao (para o professor).
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\07-demo-replicas.ps1
# Aperte ENTER para avancar cada etapa.

$ns = "ecommerce"

Write-Host "ETAPA 1 - Cada servico roda com 2 pods (replicas)" -ForegroundColor Cyan
kubectl get pods -n $ns -l part-of=ecommerce -o wide
Read-Host "ENTER para continuar"

Write-Host "ETAPA 2 - Escalando o estoque de 2 para 3 pods" -ForegroundColor Cyan
kubectl scale deployment estoque-service --replicas=3 -n $ns
kubectl rollout status deployment/estoque-service -n $ns
kubectl get pods -n $ns -l app=estoque-service
Read-Host "ENTER para continuar"

Write-Host "ETAPA 3 - Voltando para 2 pods" -ForegroundColor Cyan
kubectl scale deployment estoque-service --replicas=2 -n $ns
Start-Sleep -Seconds 5
kubectl get pods -n $ns -l app=estoque-service
Read-Host "ENTER para continuar"

Write-Host "ETAPA 4 - Auto-recuperacao: apagando 1 pod do pedido (o Kubernetes recria sozinho)" -ForegroundColor Cyan
$pod = kubectl get pods -n $ns -l app=pedido-service -o jsonpath="{.items[0].metadata.name}"
Write-Host "Apagando o pod $pod"
kubectl delete pod $pod -n $ns --wait=false
Start-Sleep -Seconds 3
kubectl get pods -n $ns -l app=pedido-service
Write-Host ""
Write-Host "Observe: um pod novo (ContainerCreating) aparece para manter as 2 replicas." -ForegroundColor Yellow
Start-Sleep -Seconds 15
kubectl get pods -n $ns -l app=pedido-service
