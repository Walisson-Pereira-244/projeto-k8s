# Divisão de tarefas — Walisson e Cauê

O repositório já vem com os manifests, os scripts e o README prontos. O trabalho de vocês agora é
**rodar, entender, validar, tirar as evidências e ensaiar**. Cada um é "dono" de uma parte e **precisa saber explicar
a parte do outro em uma frase** (o professor pode perguntar a qualquer um).

## Quem cuida de quê

| Parte | Walisson | Cauê |
|---|---|---|
| Serviços no cluster | `k8s/estoque/` (app + banco) | `k8s/pedido/`, `k8s/auth/`, `k8s/gateway/` |
| Observabilidade | `k8s/observabilidade/` (Prometheus + Grafana + dashboard) | revisa e confere os prints |
| Código | confere o estoque (`/metrics`, `ENABLE_DOCS`) | confere auth (`JWT_SECRET` por variável), gateway e pedido |
| Evidências (`docs/EVIDENCIAS.md`) | Prometheus Targets e Grafana | pods com 2 réplicas, teste de fluxo, Ingress |
| Apresentação | cluster/namespace, ConfigMap e Secret, observabilidade | réplicas e escalabilidade, fluxo ponta a ponta, Ingress |
| Git | branches `feature/walisson-*` | branches `feature/caue-*` |

## Etapas (em ordem)

### Etapa 1 — Publicar o repositório (Walisson, 15 min)
Siga `docs/PUBLICAR-NO-GITHUB.md`. Depois adicione o Cauê em *Settings → Collaborators*.

### Etapa 2 — Cada um sobe o cluster no próprio computador (os dois, 1 a 2 h)
Siga o README, seção 4 (scripts 00 a 05). Cada um deve chegar ao **"TODOS OS TESTES PASSARAM"**.
Se travar, anote o erro e olhe a tabela "Problemas comuns" do README.

### Etapa 3 — Entender a sua parte (cada um, 1 h)
- **Walisson:** leia `k8s/estoque/*.yaml` e `k8s/observabilidade/**/*.yaml`. Abra o Prometheus (*Status → Targets*) e o Grafana.
- **Cauê:** leia `k8s/pedido/*.yaml`, `k8s/auth/*.yaml` e `k8s/gateway/*.yaml`. Rode `07-demo-replicas.ps1`.
- Os comentários dentro dos YAMLs explicam o que cada arquivo faz.

### Etapa 4 — Evidências (os dois, 1 h)
Tirem os prints listados em `docs/EVIDENCIAS.md` e salvem em `docs/evidencias/`.

### Etapa 5 — Pull Requests (os dois, 30 min)
Qualquer mudança vai por uma branch `feature/...` → Pull Request para `develop` → merge → Pull Request `develop` → `main`.
O CI (testes, build das imagens, validação dos manifests) roda sozinho no PR.

### Etapa 6 — Ensaio (os dois, 1 h)
Siga `docs/ROTEIRO-APRESENTACAO.md` do começo ao fim, no computador que vai apresentar,
**começando do zero** (`minikube delete` e os scripts 01 a 05).

## Regras do grupo
- Não editem os mesmos arquivos ao mesmo tempo: cada um mexe só na sua pasta de `k8s/`.
- Antes de mexer: `git pull`. Depois de mexer: commit pequeno e push na sua branch.
- Mudou código de um serviço? Rode de novo `02-build-imagens.ps1` e `kubectl rollout restart deployment/<nome> -n ecommerce`.
- **Quem apresenta** (um só computador): deixe o cluster ligado 15 minutos antes e não mexa mais.
