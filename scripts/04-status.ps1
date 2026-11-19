# Mostra o estado do cluster: pods (com as replicas), deployments, services e ingress.
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\04-status.ps1
# Esta e a EVIDENCIA de "multiplos pods em execucao" pedida no enunciado.

$ns = "ecommerce"
Write-Host "=== PODS (cada servico deve ter 2 pods Running) ===" -ForegroundColor Cyan
kubectl get pods -n $ns -o wide
Write-Host ""
Write-Host "=== DEPLOYMENTS (coluna READY: 2/2) ===" -ForegroundColor Cyan
kubectl get deployments -n $ns
Write-Host ""
Write-Host "=== SERVICES ===" -ForegroundColor Cyan
kubectl get services -n $ns
Write-Host ""
Write-Host "=== INGRESS ===" -ForegroundColor Cyan
kubectl get ingress -n $ns
Write-Host ""
Write-Host "=== CONFIGMAPS E SECRETS ===" -ForegroundColor Cyan
kubectl get configmaps,secrets -n $ns
