FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt -y update && \
    apt -y install \
        supervisor \
        xvfb \
        xfce4 \
        xfce4-terminal \
        x11vnc \
    && \
    apt clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    mkdir -p ~/.vnc && \
    x11vnc -storepasswd secret ~/.vnc/passwd
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
    } > /etc/supervisor/conf.d/desktop.conf
EXPOSE 5900
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
