# Basis-Image (Ubuntu LTS)
FROM ubuntu:22.04

# Environment vorbereiten
ENV DEBIAN_FRONTEND=noninteractive

# Standard-Tools + PHP installieren
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    wget \
    git \
    unzip \
    zip \
    vim \
    nano \
    zsh \
    rsync \
    lsb-release \
    ca-certificates \
    gnupg \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update && apt-get install -y \
    php8.2 \
    php8.2-cli \
    php8.2-common \
    php8.2-mysql \
    php8.2-curl \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip

# Default Shell auf zsh setzen
SHELL ["/bin/zsh", "-c"]

# NVM installieren
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=20

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    npm install -g npm && \
    npm install -g bower gulp

# Oh My Zsh installieren
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended

# Theme & Plugins anpassen
RUN sed -i 's/ZSH_THEME=".*"/ZSH_THEME="agnoster"/' ~/.zshrc && \
    sed -i 's/plugins=(git)/plugins=(git docker docker-compose npm node)/' ~/.zshrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc
