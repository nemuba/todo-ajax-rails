#!/usr/bin/env bash
set -euo pipefail

cd /workspace

echo "==> Instalando gems com bundler"
BUNDLE_DIR="${BUNDLE_PATH:-/workspace/.bundle}"
mkdir -p "${BUNDLE_DIR}"
if ! bundle check > /dev/null 2>&1; then
  bundle install
fi

if [ -f node_modules ]; then
  echo "==> Removendo node_modules existente"
  rm -rf node_modules
fi

if command -v yarn >/dev/null 2>&1 && [ -f package.json ]; then
  echo "==> Instalando dependências Yarn"
  mkdir -p node_modules
  yarn install --check-files
fi

if [ -f config/master.key ] || [ -n "${RAILS_MASTER_KEY:-}" ]; then
  echo "==> Preparando banco de dados (db:prepare)"
  bundle exec rails db:prepare || echo "Falha ao preparar banco (verifique credenciais)"
else
  echo "==> Pulando db:prepare (master.key não encontrado)"
fi

echo "==> Ambiente pronto. Use .devcontainer/start.sh para iniciar os processos do Procfile via Foreman."
