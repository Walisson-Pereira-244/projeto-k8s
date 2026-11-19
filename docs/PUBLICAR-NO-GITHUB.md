# Como publicar este projeto no seu GitHub e compartilhar com o Cauê

## 1. Criar o repositório vazio (no site)
1. Entre em https://github.com/new
2. **Repository name:** `projeto-k8s` (pode ser outro nome)
3. Deixe **sem** README, sem .gitignore e sem licença (o projeto já tem os seus).
4. Clique em **Create repository**.

## 2. Enviar o projeto (no terminal, dentro da pasta `projeto-k8s`)
Troque `SEU_USUARIO` pelo seu usuário do GitHub:

```powershell
git init
git add .
git commit -m "feat: projeto T3 com Kubernetes, CI/CD e observabilidade"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/projeto-k8s.git
git push -u origin main

git checkout -b develop
git push -u origin develop
```

Se o Git pedir nome e e-mail:
```powershell
git config --global user.name "Seu Nome"
git config --global user.email "seu-email@exemplo.com"
```

## 3. Convidar o Cauê
No repositório: **Settings → Collaborators → Add people** → usuário do GitHub do Cauê. Ele recebe um e-mail e precisa aceitar.

## 4. O Cauê baixa o projeto
```powershell
git clone https://github.com/SEU_USUARIO/projeto-k8s.git
cd projeto-k8s
git checkout develop
```

## 5. Rotina de trabalho dos dois
```powershell
git checkout develop
git pull
git checkout -b feature/nome-da-tarefa     # crie uma branch por tarefa
# ... edite os arquivos ...
git add -A
git commit -m "descricao curta do que mudou"
git push -u origin feature/nome-da-tarefa
```
Depois, no GitHub: **Compare & pull request** → base `develop` → espere os checks verdes → **Merge**.
Para publicar na `main`: novo Pull Request com base `main` e compare `develop`.

## 6. Versão (opcional)
```powershell
git checkout main
git pull
git tag v1.0.0
git push origin v1.0.0
```
Isso dispara o workflow **Release**, que publica as 4 imagens no GitHub Container Registry (aba *Packages*).

## 7. Conferir
- Aba **Actions**: o workflow **CI** deve ficar verde (testes, build das imagens e validação dos manifests).
- Aba **Pull requests**: o Dependabot vai abrir PRs de atualização de dependências. Não faça merge deles perto da entrega.
