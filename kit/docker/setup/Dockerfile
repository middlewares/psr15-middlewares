FROM ubuntu:latest

LABEL org.opencontainers.image.authors="filisfutsarov@gmail.com"

ARG KIT_USER=$KIT_USER
ARG KIT_UID=$KIT_UID
ARG KIT_GID=$KIT_GID

RUN test -n $KIT_USER
RUN test -n $KIT_UID
RUN test -n $KIT_GID

#ENV USER=$USER
#ENV UID=$UID
#ENV GID=$GID

ENV NVM_DIR="/home/$KIT_USER/nvm"
ENV PATH="/home/$KIT_USER/bin":$PATH

RUN apt-get update && \
    apt-get --no-install-recommends -q -y install apt-utils curl unzip 7zip wget libzip-dev libicu-dev libpng-dev git zip less ca-certificates apt-transport-https software-properties-common lsb-release sudo

# https://github.com/ilikenwf/apt-fast?tab=readme-ov-file#installation
RUN add-apt-repository ppa:apt-fast/stable && apt-get -y install apt-fast
RUN echo debconf apt-fast/maxdownloads string 16 \
    | debconf-set-selections && echo debconf apt-fast/dlflag boolean true \
    | debconf-set-selections && echo debconf apt-fast/aptmanager string apt-get \
    | debconf-set-selections

# this is mainly to a avoid Timezone questions when installing PHP
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN add-apt-repository ppa:ondrej/php -y
COPY inside/install_php.sh /opt/src/scripts/setup.sh
RUN --mount=type=cache,target=/tmp/cache ["/opt/src/scripts/setup.sh"]

RUN mkdir -p "/home/$KIT_USER"

# COMPOSER
RUN mkdir -p "/home/$KIT_USER/bin"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir="/home/$KIT_USER/bin" --filename=composer

# NVM (node version manager)
#RUN mkdir -p "$NVM_DIR"
#RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
#    && . $NVM_DIR/nvm.sh \
#    && nvm install --lts \
#    && nvm alias default lts/* \
#    && nvm use default

RUN cp /root/.bashrc /home/$KIT_USER/
RUN chown -R $UID:$GID "/home/$KIT_USER"

#    && rm -rf /var/lib/apt/lists/*

# this is mainly to be able to switch PHP versions (update-alternatives)
RUN adduser $KIT_USER && usermod -aG sudo $KIT_USER && echo "$KIT_USER:$KIT_USER" | chpasswd
RUN echo "$KIT_USER	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

#RUN composer self-update --2.2 # LTS to support php7.1 ...

ENTRYPOINT ["/src/kit/docker/setup/inside/entrypoint.sh"]
