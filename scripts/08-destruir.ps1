# Remove tudo do projeto do cluster (apaga o namespace inteiro, inclusive os bancos).
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\08-destruir.ps1
# Para desligar o Minikube sem apagar nada:  minikube stop
# Para apagar o cluster inteiro:             minikube delete

kubectl delete namespace ecommerce
Write-Host "Namespace removido. Para subir de novo: scripts\03-deploy.ps1" -ForegroundColor Green
