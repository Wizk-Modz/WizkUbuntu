FROM ubuntu:latest

ENV TZ=Asia/Ho_Chi_Minh
ENV CODENAME=resolute

# Cấu hình timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Tắt recommends/suggests
RUN printf '%s\n' \
        'APT::Install-Recommends "false";' \
        'APT::Install-Suggests "false";' \
        > /etc/apt/apt.conf.d/99no-recommends

# Cấu hình Ubuntu mirror
RUN printf '%s\n' \
        'Types: deb' \
        'URIs: http://mirror.bizflycloud.vn/ubuntu/' \
        "Suites: ${CODENAME} ${CODENAME}-updates ${CODENAME}-backports" \
        'Components: main universe restricted multiverse' \
        'Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg' \
        '' \
        'Types: deb' \
        'URIs: http://security.ubuntu.com/ubuntu/' \
        "Suites: ${CODENAME}-security" \
        'Components: main universe restricted multiverse' \
        'Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg' \
        > /etc/apt/sources.list.d/ubuntu.sources

# Update package list
RUN apt-get update

# Cài package
RUN apt-get install -y --no-install-recommends \
        apt-utils \
        nano \
        curl \
        wget \
        dialog \
        ca-certificates \
        xz-utils \
        zip \
        unzip \
        tree \
        git \
        locales \
        sudo \
        tzdata \
        openssh-client \
        libcrypt1 \
        libstdc++6 \
        libgcc-s1

# Dọn cache
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy bashrc
RUN cp /etc/skel/.bashrc /root/.bashrc

# Copy Python
#COPY File/python/ /opt/python/

# Copy Node.js
#COPY File/node/ /opt/node/

# Cấp quyền
#RUN chmod -R a+rX /opt/python /opt/node \
#    && chmod a+x /opt/python/bin/* /opt/node/bin/*

# PATH
#ENV PATH="/opt/python/bin:/opt/node/bin:${PATH}"

CMD ["bash"]
