# Adiciona os enderecos *.local no arquivo hosts do Windows (precisa de PowerShell como ADMINISTRADOR).
# Depois, deixe "minikube tunnel" rodando (outra janela, tambem como Administrador).
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\06-configurar-hosts.ps1

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Abra o PowerShell como ADMINISTRADOR (botao direito > Executar como administrador)." -ForegroundColor Red
    exit 1
}

$hosts = Join-Path $env:SystemRoot "System32\drivers\etc\hosts"
$linha = "127.0.0.1 gateway.local auth.local estoque.local pedido.local prometheus.local grafana.local"

if (Select-String -Path $hosts -Pattern "gateway\.local" -Quiet) {
    Write-Host "O arquivo hosts ja tem os enderecos do projeto. Nada a fazer." -ForegroundColor Green
} else {
    Add-Content -Path $hosts -Value ("`r`n# projeto-k8s`r`n" + $linha)
    Write-Host "Enderecos adicionados ao arquivo hosts." -ForegroundColor Green
}

Write-Host ""
Write-Host "Agora abra OUTRA janela do PowerShell como Administrador e rode (deixe aberta):"
Write-Host "    minikube tunnel"
Write-Host ""
Write-Host "Enderecos:"
Write-Host "    http://gateway.local/docs      (API Gateway)"
Write-Host "    http://estoque.local/docs      (Swagger do estoque)"
Write-Host "    http://pedido.local/docs       (Swagger do pedido)"
Write-Host "    http://auth.local/docs         (Swagger do auth)"
Write-Host "    http://grafana.local           (usuario admin / senha admin)"
Write-Host "    http://prometheus.local        (Status > Targets)"
