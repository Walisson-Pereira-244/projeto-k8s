# Teste de ponta a ponta pelo API Gateway: login -> produto -> pedido -> cancelamento.
# Usa "port-forward", entao NAO precisa de hosts nem de minikube tunnel.
# Uso:  powershell -ExecutionPolicy Bypass -File .\scripts\05-testar-fluxo.ps1

$ErrorActionPreference = "Stop"
$base = "http://localhost:18080"
$falhas = 0

function Conferir($descricao, $obtido, $esperado) {
    if ("$obtido" -eq "$esperado") {
        Write-Host "[OK]    $descricao (valor: $obtido)" -ForegroundColor Green
    } else {
        Write-Host "[FALHA] $descricao (esperado: $esperado, obtido: $obtido)" -ForegroundColor Red
        $script:falhas++
    }
}

function Chamar($metodo, $caminho, $corpo, $cabecalhos) {
    $parametros = @{ Method = $metodo; Uri = "$base$caminho"; ContentType = "application/json" }
    if ($corpo) { $parametros.Body = ($corpo | ConvertTo-Json -Compress) }
    if ($cabecalhos) { $parametros.Headers = $cabecalhos }
    return Invoke-RestMethod @parametros
}

Write-Host "==> Abrindo acesso temporario ao api-gateway (porta 18080)..." -ForegroundColor Cyan
$pf = Start-Process -FilePath "kubectl" -ArgumentList @("port-forward", "svc/api-gateway", "18080:8080", "-n", "ecommerce") -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 5

try {
    Write-Host "==> 1. Health do gateway" -ForegroundColor Cyan
    $h = Chamar "GET" "/health"
    Conferir "gateway responde" $h.status "ok"

    Write-Host "==> 2. Login (auth-service gera o token JWT)" -ForegroundColor Cyan
    $login = Chamar "POST" "/login" @{ username = "admin"; password = "123456" }
    $headers = @{ Authorization = "Bearer $($login.access_token)" }
    Conferir "token recebido" ([bool]$login.access_token) "True"

    $codigo = "K8S" + (Get-Date -Format "HHmmss")

    Write-Host "==> 3. Cadastrar produto $codigo com 10 unidades (gateway -> estoque)" -ForegroundColor Cyan
    $p = Chamar "POST" "/produtos" @{ codigo = $codigo; nome = "Produto de teste"; quantidade = 10 } $headers
    Conferir "produto criado" $p.quantidade 10

    Write-Host "==> 4. Criar pedido de 2 unidades (gateway -> pedido -> estoque)" -ForegroundColor Cyan
    $ped = Chamar "POST" "/pedidos" @{ codigo_produto = $codigo; quantidade = 2 } $headers
    Conferir "pedido confirmado" $ped.status "CONFIRMADO"

    Write-Host "==> 5. Estoque deve ter baixado para 8" -ForegroundColor Cyan
    $p = Chamar "GET" "/produtos/$codigo" $null $headers
    Conferir "quantidade apos o pedido" $p.quantidade 8

    Write-Host "==> 6. Cancelar o pedido (Saga: estorno no estoque)" -ForegroundColor Cyan
    $c = Chamar "PUT" "/pedidos/$($ped.id)/cancelar" $null $headers
    Conferir "pedido cancelado" $c.status "CANCELADO"

    Write-Host "==> 7. Estoque deve ter voltado para 10" -ForegroundColor Cyan
    $p = Chamar "GET" "/produtos/$codigo" $null $headers
    Conferir "quantidade apos o estorno" $p.quantidade 10

    Write-Host "==> 8. Sem token deve ser bloqueado (401)" -ForegroundColor Cyan
    try {
        Chamar "GET" "/produtos/$codigo" | Out-Null
        Conferir "acesso sem token bloqueado" "liberado" "bloqueado"
    } catch {
        Conferir "acesso sem token bloqueado" $_.Exception.Response.StatusCode.value__ 401
    }
}
catch {
    Write-Host "Erro durante o teste: $($_.Exception.Message)" -ForegroundColor Red
    $falhas++
}
finally {
    Stop-Process -Id $pf.Id -Force -ErrorAction SilentlyContinue
}

Write-Host ""
if ($falhas -eq 0) {
    Write-Host "TODOS OS TESTES PASSARAM: a aplicacao funciona por completo no cluster." -ForegroundColor Green
} else {
    Write-Host "$falhas verificacao(oes) falharam. Veja: kubectl logs -l app=pedido-service -n ecommerce" -ForegroundColor Red
    exit 1
}
