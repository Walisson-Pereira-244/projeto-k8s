# Evidências para a entrega

Salve os prints em `docs/evidencias/` com estes nomes e marque quando tirar.

| # | Print | Como gerar | Arquivo |
|---|---|---|---|
| 1 | Cluster ligado | `kubectl get nodes` | `01-nodes.png` |
| 2 | **Múltiplos pods (2 por serviço)** | `kubectl get pods -n ecommerce -o wide` | `02-pods.png` |
| 3 | Deployments com `READY 2/2` | `kubectl get deployments -n ecommerce` | `03-deployments.png` |
| 4 | Services e Ingress | `kubectl get services,ingress -n ecommerce` | `04-services-ingress.png` |
| 5 | ConfigMaps e Secrets | `kubectl get configmaps,secrets -n ecommerce` | `05-config-secrets.png` |
| 6 | Teste de ponta a ponta passando | `scripts\05-testar-fluxo.ps1` | `06-fluxo.png` |
| 7 | Swagger pelo Ingress | `http://gateway.local/docs` | `07-ingress-swagger.png` |
| 8 | Escalabilidade (3 pods) | `scripts\07-demo-replicas.ps1` (etapa 2) | `08-escala.png` |
| 9 | Auto-recuperação | `scripts\07-demo-replicas.ps1` (etapa 4) | `09-autorecuperacao.png` |
| 10 | Prometheus: todos os alvos UP | `http://prometheus.local/targets` | `10-prometheus-targets.png` |
| 11 | Grafana: dashboard com dados | `http://grafana.local` → *Microsserviços no Kubernetes* | `11-grafana.png` |
| 12 | CI verde no GitHub | aba *Actions* | `12-ci.png` |

Dica: rode o `05-testar-fluxo.ps1` 3 vezes antes do print do Grafana, para os gráficos terem dados.
