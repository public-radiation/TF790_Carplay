# Thank you, source: https://kunyichen.wordpress.com/2023/07/18/note-dockerfile-for-build-allwinner-tina-linux/
FROM ubuntu:18.04
ARG userid
ARG groupid
ARG username

RUN sed -i'' 's/archive\.ubuntu\.com/us\.archive\.ubuntu\.com/' /etc/apt/sources.list
# RUN sed -i'' 's/archive\.ubuntu\.com/old-releases\.ubuntu\.com/' /etc/apt/sources.list
# RUN sed -i'' 's/security.ubuntu\.com/old-releases\.ubuntu\.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    build-essential cvs subversion mercurial git-core \
    libncurses5-dev zlib1g-dev gawk flex quilt openssl libssl-dev \
    xsltproc libxml-parser-perl bzr ecj unzip \
    lib32z1 lib32z1-dev libc6-i386 lib32ncurses5 \
    lib32stdc++6 libstdc++6 rsync vim wget curl bc busybox \
    linux-tools-common gperf net-tools p7zip-full  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
 && chmod a+x /usr/local/bin/repo

RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username >/root/username \
 && echo "export USER="$username >>/home/$username/.gitconfig

COPY gitconfig /home/$username/.gitconfig

RUN chown $userid:$groupid /home/$username/.gitconfig

ENV HOME=/home/$username
ENV USER=$username
ENV WORKFOLDER=/home/$username

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -c "cd $WORKFOLDER && exec /bin/bash -i"