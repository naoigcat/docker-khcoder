FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=ja_JP.UTF-8 \
    LC_ALL=${LANG} \
    LANGUAGE=${LANG} \
    TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt -y update && \
    apt -y install \
        fonts-noto \
        ibus-anthy \
        language-pack-ja \
        language-pack-ja-base \
        supervisor \
        xvfb \
        xfce4 \
        xfce4-terminal \
        x11vnc \
    && \
    apt clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    mkdir -p ~/.vnc && \
    x11vnc -storepasswd secret ~/.vnc/passwd && \
    locale-gen ja_JP.UTF-8 && \
    localedef -f UTF-8 -i ja_JP ja_JP.utf8 && \
    LANG=C xdg-user-dirs-update --force
RUN { \
        echo "[supervisord]" ; \
        echo "nodaemon=true" ; \
        echo "" ; \
        echo "[program:X11]" ; \
        echo "command=/usr/bin/Xvfb :0 -screen 0 1280x800x16" ; \
        echo "autorestart=true" ; \
        echo "stdout_logfile=/var/log/Xvfb.log" ; \
        echo "stderr_logfile=/var/log/Xvfb.err" ; \
        echo "" ; \
        echo "[program:startxfce4]" ; \
        echo "priority=10" ; \
        echo "directory=/root" ; \
        echo "command=/usr/bin/startxfce4" ; \
        echo "user=root" ; \
        echo "autostart=true" ; \
        echo "autorestart=true" ; \
        echo "stopsignal=QUIT" ; \
        echo "environment=DISPLAY=':0',HOME='/root'" ; \
        echo "stdout_logfile=/var/log/xfce4.log" ; \
        echo "stderr_logfile=/var/log/xfce4.err" ; \
        echo "" ; \
        echo "[program:x11vnc]" ; \
        echo "command=/usr/bin/x11vnc -display :0 -xkb -forever -shared -usepw" ; \
        echo "autorestart=true" ; \
        echo "stdout_logfile=/var/log/x11vnc.log" ; \
        echo "stderr_logfile=/var/log/x11vnc.err" ; \
        echo "" ; \
        echo "[program:ibus-daemon]" ; \
        echo "command=ibus-daemon" ; \
        echo "autorestart=true" ; \
        echo "environment=DISPLAY=':0',HOME='/root',USER='root'" ; \
    } > /etc/supervisor/conf.d/desktop.conf
EXPOSE 5900
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
