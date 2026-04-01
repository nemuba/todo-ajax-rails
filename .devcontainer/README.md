# Dev Container

Este diretório contém a configuração necessária para desenvolver o projeto `todo-ajax-rails` dentro de um Dev Container (VS Code / Codespaces).

## Requisitos
- Docker e Docker Compose instalados localmente.
- Extensão **Dev Containers** no VS Code (ou GitHub Codespaces).

## Serviços
- `app`: container principal com Ruby 2.5.9, Node.js 18, Yarn, Chromium (para testes Capybara) e shell padrão em Zsh.
- `db`: PostgreSQL 13 com usuário/senha `postgres` (disponível na rede interna do Compose e via port forwarding do VS Code).
- `redis`: Redis 7 para cache/filas (apenas rede interna do Compose).

Somente a porta `3000` (Rails) é publicada diretamente para o host. PostgreSQL (`5432`) e Redis (`6379`) ficam disponíveis para o VS Code por meio de port forwarding automático e para os demais containers pelo hostnames `db` e `redis`. Se precisar expor essas portas para o host (por exemplo, para conectar com um cliente local), adicione os mapeamentos desejados em `docker-compose.yml`.

## Primeira inicialização
1. Abra o projeto no VS Code.
2. Execute **Dev Containers: Reopen in Container**.
3. Aguarde o término do comando `postCreate`:
   - Instala gems com `bundle install`.
   - Instala dependências JS com `yarn install`.
   - Tenta rodar `rails db:prepare` quando a `master.key` estiver disponível.

Se o banco exigir outras credenciais, ajuste as variáveis no arquivo `config/credentials.yml.enc` e atualize os valores das variáveis de ambiente no `docker-compose.yml`.

## Scripts úteis
- `boot.sh`: executado automaticamente após criar o container. Pode ser reexecutado manualmente com `./.devcontainer/boot.sh`.
- `start.sh`: remove `tmp/pids/server.pid` e inicia os processos definidos em `Procfile.dev` com `bundle exec foreman start` (cai para `rails server` caso o arquivo não exista).

## Zsh
- O usuário `vscode` utiliza Zsh como shell padrão com aliases (`be`, `rspec`, `foreman`, `rails`) e prompt configurado.
- Personalize o shell editando `~/.zshrc` (a versão inicial é copiada de `.devcontainer/zshrc` durante o build).
- O tema padrão é o `agnoster` via `promptinit`.
- O cache de gems fica em `/workspace/.bundle`, fora do diretório home, evitando conflitos de permissões com volumes Docker.
- Os `node_modules` são montados em um `tmpfs` dentro do container; toda vez que o container reinicia, o boot script executa `yarn install` para repopular a pasta com as permissões corretas.
- Se houver uma pasta `node_modules` criada anteriormente no host (por exemplo, com permissões `root`), você pode removê-la em segurança — ela não é utilizada pelo container.

## Banco de dados
- `config/database.yml` agora prioriza as variáveis de ambiente (`DATABASE_URL`, `PGHOST`, `PGUSER`, `PGPASSWORD`, etc.). O `docker-compose` já define os valores adequados (`db`/`postgres`), portanto não é necessário configurar credenciais no `master.key` dentro do container.

## Testes com Capybara
- `CHROME_BIN` e `CHROMEDRIVER_PATH` já estão definidos no container (`/usr/bin/chromium` e `/usr/bin/chromedriver`).
- Para rodar testes com Selenium/Chromium:

```bash
bundle exec rspec
```

Caso precise de flags personalizadas (ex.: modo headless), configure seu driver no código de testes usando os caminhos acima.
