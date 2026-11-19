# Roteiro de apresentação (10 a 12 minutos)

## 15 minutos antes (no computador que vai apresentar)
1. Abra o **Docker Desktop** e espere ficar verde.
2. `minikube start` (se já criou o cluster antes, os pods voltam sozinhos).
3. `powershell -ExecutionPolicy Bypass -File .\scripts\04-status.ps1` — todos os pods `Running`, 2 por serviço.
4. `powershell -ExecutionPolicy Bypass -File .\scripts\05-testar-fluxo.ps1` — deve terminar com "TODOS OS TESTES PASSARAM".
5. Deixe `minikube tunnel` rodando (PowerShell como Administrador) e o `hosts` configurado (script 06).
6. Abra abas prontas: `http://gateway.local/docs`, `http://grafana.local`, `http://prometheus.local/targets`, o repositório no GitHub (aba Actions).
7. Deixe um terminal aberto na pasta do projeto.

## Sequência da apresentação
1. **Visão geral (1 min).** Mostre a pasta `k8s/` e diga: "um conjunto de arquivos por microsserviço: Deployment, Service, ConfigMap, Secret e Ingress".
2. **Réplicas (2 min).** `04-status.ps1` → "cada serviço tem 2 pods". Mostre `READY 2/2`.
3. **Configuração (2 min).**
   - `kubectl get configmap,secret -n ecommerce`
   - `kubectl describe configmap estoque-service-config -n ecommerce`
   - Abra `auth-service/main.py` e mostre `os.environ["JWT_SECRET"]`: "nada fixo no código".
4. **Aplicação funcionando (2 min).** `05-testar-fluxo.ps1` ou o teste manual. Explique o caminho:
   navegador → Ingress → gateway → auth (token) → pedido → estoque.
5. **Ingress (1 min).** Abra `http://gateway.local/docs` e `http://estoque.local/docs`.
6. **Escalabilidade e auto-recuperação (2 min).** `07-demo-replicas.ps1`: escala o estoque para 3, volta para 2 e apaga um pod do pedido (o Kubernetes recria).
7. **Observabilidade (2 min).** Em `prometheus.local/targets`: 2 pods por serviço, todos `UP`.
   No Grafana: dashboard "Microsserviços no Kubernetes". Rode o `05-testar-fluxo.ps1` de novo e mostre os gráficos mexendo,
   inclusive "Requisições por segundo (por pod)" mostrando as duas réplicas recebendo carga.
8. **CI/CD (1 min).** No GitHub, aba Actions: testes, build das imagens e validação dos manifests.

## Perguntas prováveis
- **O que é um Pod? E um Deployment?** Pod = um container rodando. Deployment = "mantenha N pods deste serviço no ar" (aqui N = 2).
- **Para que serve o Service?** Dá um endereço fixo e reparte as chamadas entre as réplicas.
- **Diferença entre ConfigMap e Secret?** ConfigMap = configuração comum; Secret = dado sensível (senha, chave).
- **O que o Ingress faz?** Liga um endereço externo (`gateway.local`) a um Service dentro do cluster.
- **Por que os bancos têm 1 réplica?** Banco de dados não é stateless; replicar exigiria replicação do próprio Postgres.
- **Como o Prometheus acha as réplicas?** Pela API do Kubernetes: coleta o `/metrics` de todo pod com a anotação `prometheus.io/scrape: "true"`.
- **O que acontece se um pod cair?** O Deployment cria outro automaticamente (mostrado na etapa 6).
- **Por que as imagens são construídas "dentro do Minikube"?** O Minikube tem o próprio Docker; ele não enxerga as imagens do Docker comum.
- **O Secret é seguro?** Aqui é acadêmico (valores no repositório). Em produção usam-se Sealed Secrets, Vault ou um gerenciador de segredos da nuvem.
- **Qual a diferença entre o T2 e o T3?** T2: deploy em nuvem (Render) com pipelines por serviço. T3: tudo orquestrado no Kubernetes local, com réplicas e observabilidade dentro do cluster.

## Plano B
| Problema | O que fazer |
|---|---|
| `gateway.local` não abre | use `kubectl port-forward svc/api-gateway 8080:8080 -n ecommerce` e abra `http://localhost:8080/docs` |
| Pod preso em `ContainerCreating` | espere 1 minuto (primeira vez baixa imagens) e rode `kubectl get pods -n ecommerce` |
| Grafana sem dados | rode `05-testar-fluxo.ps1` 2 ou 3 vezes e espere 30 segundos |
| Cluster não sobe na hora | mostre os prints de `docs/evidencias/` e explique os arquivos de `k8s/` |
