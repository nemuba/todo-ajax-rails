FROM ruby:2.5.9-buster

ARG USER=vscode
ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN printf 'Acquire::Check-Valid-Until "false";\nAcquire::Check-Date "false";\n' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    cat <<'EOF' > /etc/apt/sources.list
deb http://archive.debian.org/debian buster main contrib non-free
deb http://archive.debian.org/debian buster-updates main contrib non-free
deb http://archive.debian.org/debian-security buster/updates main contrib non-free
EOF

# Base packages and build tooling
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      gnupg2 \
      libffi-dev \
      libpq-dev \
      libxml2-dev \
      libxslt1-dev \
      pkg-config \
      postgresql-client \
      shared-mime-info \
      unzip \
      wget \
      xvfb \
      zsh && \
    rm -rf /var/lib/apt/lists/*

# Node.js + Yarn (para assets Rails)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Chromium e Chromedriver para testes Capybara
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      chromium \
      chromium-driver \
      fonts-liberation && \
    rm -rf /var/lib/apt/lists/*

# Ferramentas Ruby
ARG BUNDLER_VERSION=2.3.27
RUN gem update --system 3.2.3
RUN gem install bundler -v "${BUNDLER_VERSION}"

# Cria usuário não-root
RUN groupadd --gid ${GID} ${USER} && \
    useradd --uid ${UID} --gid ${GID} -m ${USER}

ENV BUNDLE_PATH=/workspace/.bundle \
    BUNDLE_BIN=/workspace/.bundle/bin \
    GEM_HOME=/workspace/.bundle \
    GEM_PATH=/workspace/.bundle:/usr/local/bundle \
    PATH=/workspace/.bundle/bin:$PATH \
    SHELL=/usr/bin/zsh \
    CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver

RUN usermod --shell /usr/bin/zsh ${USER}

RUN mkdir -p /workspace/.bundle /workspace/node_modules && \
    chown -R ${USER}:${USER} /workspace /home/${USER}

COPY .devcontainer/zshrc /tmp/zshrc
RUN mv /tmp/zshrc /home/${USER}/.zshrc && chown ${USER}:${USER} /home/${USER}/.zshrc

USER ${USER}
WORKDIR /workspace
