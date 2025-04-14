FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VOLTA_HOME=/root/.volta
ENV PATH=$VOLTA_HOME/bin:$PATH
ENV NODE_VERSION=20

# System-Tools & PHP vorbereiten
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    curl \
    wget \
    git \
    unzip \
    zip \
    vim \
    nano \
    rsync \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && apt-get install -y --no-install-recommends \
    php7.4 php7.4-cli php7.4-common php7.4-curl php7.4-mysql php7.4-mbstring php7.4-xml php7.4-zip php7.4-gd \
    php8.0 php8.0-cli php8.0-common php8.0-curl php8.0-mysql php8.0-mbstring php8.0-xml php8.0-zip php8.0-gd \
    php8.1 php8.1-cli php8.1-common php8.1-curl php8.1-mysql php8.1-mbstring php8.1-xml php8.1-zip php8.1-gd \
    php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-mysql php8.2-mbstring php8.2-xml php8.2-zip php8.2-gd \
    php8.3 php8.3-cli php8.3-common php8.3-curl php8.3-mysql php8.3-mbstring php8.3-xml php8.3-zip php8.3-gd \
    php8.4 php8.4-cli php8.4-common php8.4-curl php8.4-mysql php8.4-mbstring php8.4-xml php8.4-zip php8.4-gd && \
    update-alternatives --install /usr/bin/php php /usr/bin/php7.4 74 && \
    update-alternatives --install /usr/bin/php php /usr/bin/php8.0 80 && \
    update-alternatives --install /usr/bin/php php /usr/bin/php8.1 81 && \
    update-alternatives --install /usr/bin/php php /usr/bin/php8.2 82 && \
    update-alternatives --install /usr/bin/php php /usr/bin/php8.3 83 && \
    update-alternatives --install /usr/bin/php php /usr/bin/php8.4 84 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer installieren
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Volta installieren + Standard-Node-Version
RUN curl https://get.volta.sh | bash && \
    /root/.volta/bin/volta install node@$NODE_VERSION && \
    /root/.volta/bin/volta install npm bower gulp && \
    ln -s /root/.volta/bin/volta /usr/local/bin/volta

# NVM-Shim (als Wrapper für Volta)
RUN echo '#!/bin/bash' > /usr/local/bin/nvm && \
    echo 'set -e' >> /usr/local/bin/nvm && \
    echo 'if [[ "$1" == "install" && -n "$2" ]]; then' >> /usr/local/bin/nvm && \
    echo '  VERSION="$2"' >> /usr/local/bin/nvm && \
    echo '  volta install node@$VERSION' >> /usr/local/bin/nvm && \
    echo '  case "$VERSION" in' >> /usr/local/bin/nvm && \
    echo '    12*) volta install npm@6.14.18 ;;' >> /usr/local/bin/nvm && \
    echo '    14*) volta install npm@6.14.14 ;;' >> /usr/local/bin/nvm && \
    echo '    16*) volta install npm@8.19.4 ;;' >> /usr/local/bin/nvm && \
    echo '    18*) volta install npm@9.9.1 ;;' >> /usr/local/bin/nvm && \
    echo '    20*) volta install npm@10.7.0 ;;' >> /usr/local/bin/nvm && \
    echo '    *) volta install npm ;;' >> /usr/local/bin/nvm && \
    echo '  esac' >> /usr/local/bin/nvm && \
    echo 'elif [[ "$1" == "use" && -n "$2" ]]; then' >> /usr/local/bin/nvm && \
    echo '  echo "Using node version $2 via Volta..."' >> /usr/local/bin/nvm && \
    echo '  volta install node@$2 > /dev/null' >> /usr/local/bin/nvm && \
    echo 'else' >> /usr/local/bin/nvm && \
    echo '  echo "nvm shim via Volta. Supported: install, use"' >> /usr/local/bin/nvm && \
    echo 'fi' >> /usr/local/bin/nvm && \
    chmod +x /usr/local/bin/nvm
