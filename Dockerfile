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

RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN npm install karma karma-cljs-test --save-dev
RUN npm install -g karma-cli
RUN npm install karma-chrome-launcher
