FROM java:8

ENV BOOT_VERSION=2.7.2
ENV BOOT_INSTALL=/usr/local/bin/

WORKDIR /tmp

RUN mkdir -p $BOOT_INSTALL \
&& wget -q https://github.com/boot-clj/boot-bin/releases/download/2.7.2/boot.sh \
&& echo "Comparing installer checksum..." \
&& echo "f717ef381f2863a4cad47bf0dcc61e923b3d2afb *boot.sh" | sha1sum -c - \
&& mv boot.sh $BOOT_INSTALL/boot \
&& chmod 0755 $BOOT_INSTALL/boot

ENV PATH=$PATH:$BOOT_INSTALL
ENV BOOT_AS_ROOT=yes

RUN boot

RUN apt-get update && apt-get install -y \
apt-transport-https \
wget \
unzip \
fontconfig \
locales \
gconf-service \
libasound2 \
libatk1.0-0 \
libc6 \
libcairo2 \
libcups2 \
libdbus-1-3 \
libexpat1 \
libfontconfig1 \
libgcc1 \
libgconf-2-4 \
libgdk-pixbuf2.0-0 \
libglib2.0-0 \
libgtk-3-0 \
libnspr4 \
libpango-1.0-0 \
libpangocairo-1.0-0 \
libstdc++6 \
libx11-6 \
libx11-xcb1 \
libxcb1 \
libxcomposite1 \
libxcursor1 \
libxdamage1 \
libxext6 \
libxfixes3 \
libxi6 \
libxrandr2 \
libxrender1 \
libxss1 \
libxtst6 \
ca-certificates \
fonts-liberation \
libappindicator1 \
libnss3 \
lsb-release \
xdg-utils

RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update && apt-get install -y \
google-chrome-stable

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Add Chrome as a user
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
&& mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

RUN npm install -g karma karma-cljs-test karma-cli karma-chrome-launcher

# Run Chrome non-privileged
USER chrome
