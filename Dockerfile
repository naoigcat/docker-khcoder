FROM ubuntu:18.04
LABEL maintainer="naoigcat <17925623+naoigcat@users.noreply.github.com>"
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8 \
    LANGUAGE=ja_JP.UTF-8 \
    PERL_MM_USE_DEFAULT=1 \
    TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get -y update && \
    apt-get -y install \
        busybox \
        fonts-noto \
        git \
        ibus-anthy \
        language-pack-ja \
        language-pack-ja-base \
        leafpad \
        locales \
        software-properties-common \
        supervisor \
        x11vnc \
        xvfb \
        xfce4 \
        xfce4-terminal \
        xfce4-goodies \
        wget \
    && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    locale-gen ja_JP.UTF-8 && \
    localedef -f UTF-8 -i ja_JP ja_JP.utf8 && \
    echo LANG=$LANG >> /etc/default/locale && \
    LANG=C xdg-user-dirs-update --force
RUN apt-get -y update && \
    apt-get -y install \
        "mysql-server=5.7.*" \
        "mysql-client=5.7.*" \
    && \
    mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld && \
    apt-get -y install \
        build-essential \
        cpanminus \
        libdbd-mysql-perl \
        libmecab-dev \
        libmysqlclient-dev \
        libyaml-perl \
        mecab \
        mecab-ipadic-utf8 \
        tk-dev \
    && \
    perl -MCPAN -e 'install Jcode' && \
    perl -MCPAN -e 'install Tk' && \
    perl -MCPAN -e 'install DBI' && \
    perl -MCPAN -e 'install DBD::CSV' && \
    perl -MCPAN -e 'install File::BOM' && \
    perl -MCPAN -e 'install Net::Telnet' && \
    perl -MCPAN -e 'install Proc::Background' && \
    perl -MCPAN -e 'install Unicode::Escape' && \
    perl -MCPAN -e 'install Lingua::Sentence' && \
    perl -MCPAN -e 'install Lingua::JA::Regular::Unicode' && \
    perl -MCPAN -e 'install Excel::Writer::XLSX' && \
    perl -MCPAN -e 'install Spreadsheet::ParseExcel::FmtJapan' && \
    perl -MCPAN -e 'install Spreadsheet::ParseXLSX' && \
    perl -MCPAN -e 'install Statistics::ChisqIndep' && \
    perl -MCPAN -e 'install Statistics::Lite' && \
    perl -MCPAN -e 'install Text::Diff' && \
    perl -MCPAN -e 'install Algorithm::NaiveBayes' && \
    perl -MCPAN -e 'install DBD::CSV' && \
    apt-get -y install \
        libcairo2-dev \
        libcurl4-openssl-dev \
        r-base \
        r-base-dev \
        r-recommended \
    && \
    R -e 'install.packages("remotes")' && \
    R -e 'require("remotes"); install_version("RColorBrewer")' && \
    R -e 'require("remotes"); install_version("ade4")' && \
    R -e 'require("remotes"); install_version("amap")' && \
    R -e 'require("remotes"); install_version("ggdendro")' && \
    R -e 'require("remotes"); install_version("ggnetwork")' && \
    R -e 'require("remotes"); install_version("intergraph")' && \
    R -e 'require("remotes"); install_version("maptools")' && \
    R -e 'require("remotes"); install_version("scatterplot3d")' && \
    R -e 'require("remotes"); install_version("wordcloud")' && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
RUN apt-get -y update && \
    apt-get -y install \
        libfile-copy-recursive-perl \
    && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
RUN { \
        echo "[supervisord]" ; \
        echo "nodaemon=true" ; \
        echo "user=root" ; \
        echo "silent=true" ; \
        echo "logfile=/var/log/supervisord.log" ; \
        echo "pidfile=/var/run/supervisord.pid" ; \
        echo "" ; \
        echo "[program:X11]" ; \
        echo "priority=1" ; \
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
        echo "" ; \
        echo "[program:mysql]" ; \
        echo "command=/usr/bin/pidproxy /var/run/mysqld/mysqld.pid /usr/bin/mysqld_safe --datadir=/var/lib/mysql --socket=/var/run/mysqld/mysqld.sock --pid-file=/var/run/mysqld/mysqld.pid --basedir=/usr --user=mysql" ; \
        echo "autorestart=true" ; \
        echo "" ; \
        echo "[program:khcoder]" ; \
        echo "directory=/root/Desktop/khcoder" ; \
        echo "command=perl /root/Desktop/khcoder/kh_coder.pl" ; \
        echo "stdout_logfile=/dev/fd/1" ; \
        echo "stdout_logfile_maxbytes=0" ; \
        echo "stderr_logfile=/dev/fd/2" ; \
        echo "stderr_logfile_maxbytes=0" ; \
        echo "" ; \
        echo "[program:leafpad]" ; \
        echo "environment=DISPLAY=:0.0" ; \
        echo "command=/usr/bin/leafpad" ; \
    } > /etc/supervisor/conf.d/desktop.conf && \
    cd /root/Desktop && \
    wget -O - https://khcoder.net/tutorial_data_3x.zip | busybox unzip -d /root/Desktop - && \
    git clone https://github.com/ko-ichi-h/khcoder.git -b 3.Beta.07h && \
    cd khcoder && \
    { \
        echo "chasenrc_path	" ; \
        echo "grammarcha_path	" ; \
        echo "mecab_unicode	1" ; \
        echo "mecabrc_path	" ; \
        echo "stanf_jar_path	" ; \
        echo "stanf_tagger_path_en	" ; \
        echo "stanf_tagger_path_cn	" ; \
        echo "stanf_seg_path	" ; \
        echo "stanford_port	32020" ; \
        echo "stanford_ram	2g" ; \
        echo "han_dic_path	" ; \
        echo "freeling_dir	" ; \
        echo "freeling_port	32021" ; \
        echo "freeling_lang	en" ; \
        echo "stanford_lang	en" ; \
        echo "stemming_lang	en" ; \
        echo "last_lang	jp" ; \
        echo "last_method	mecab" ; \
        echo "c_or_j	mecab" ; \
        echo "unify_words_with_same_lemma	0" ; \
        echo "msg_lang	jp" ; \
        echo "msg_lang_set	0" ; \
        echo "r_path	" ; \
        echo "r_plot_debug	0" ; \
        echo "sqllog	" ; \
        echo "sql_username $(grep ^user /etc/mysql/debian.cnf | head -n1 | awk -F ' = ' '{print $2}')" ; \
        echo "sql_password $(grep ^password /etc/mysql/debian.cnf | head -n1 | awk -F ' = ' '{print $2}')" ; \
        echo "sql_host	localhost" ; \
        echo "sql_port	3306" ; \
        echo "sql_type	TCP/IP" ; \
        echo "sql_socket	MySQL" ; \
        echo "multi_threads	0" ; \
        echo "color_universal_design	1" ; \
        echo "mail_if	" ; \
        echo "mail_smtp	" ; \
        echo "mail_from	" ; \
        echo "mail_to	" ; \
        echo "use_heap	1" ; \
        echo "show_bars_wordlist	1" ; \
        echo "all_in_one_pack	" ; \
        echo "font_main	kochi gothic,10" ; \
        echo "font_plot	IPAPGothic" ; \
        echo "font_plot_cn	Droid Sans Fallback" ; \
        echo "font_plot_kr	UnDotum" ; \
        echo "font_plot_ru	Droid Sans" ; \
        echo "font_pdf	Japan1GothicBBB" ; \
        echo "font_pdf_cn	GB1" ; \
        echo "font_pdf_kr	Korea1deb" ; \
        echo "corresp_max_values	200" ; \
        echo "newline_symbol	⏎" ; \
        echo "cell_symbol	◇" ; \
        echo "color_DocView_info	#008000,white,0" ; \
        echo "color_DocView_search	black,yellow,0" ; \
        echo "color_DocView_force	black,cyan,0" ; \
        echo "color_DocView_html	red,white,0" ; \
        echo "color_DocView_CodeW	blue,white,1" ; \
        echo "color_ListHL_fore	black" ; \
        echo "color_ListHL_back	#AFEEEE" ; \
        echo "color_palette	brewer.pal(8,\"YlGnBu\")[1:6]" ; \
        echo "plot_size_words	640" ; \
        echo "plot_size_codes	480" ; \
        echo "plot_font_size	100" ; \
        echo "DocView_WrapLength_on_Win9x	80" ; \
        echo "DocSrch_CutLength	85" ; \
        echo "app_html	firefox '%s' &" ; \
        echo "app_csv	soffice -calc %s &" ; \
        echo "app_pdf	acroread %s &" ; \
    } > config/coder.ini
RUN { \
        echo '#!/bin/sh' ; \
        echo 'set -eu' ; \
        echo '' ; \
        echo 'export HOME=/root' ; \
        echo 'mkdir -p /root/.vnc' ; \
        echo '' ; \
        echo 'if [ -n "${VNC_PASSWORD:-}" ]; then' ; \
        echo '  PW="$VNC_PASSWORD"' ; \
        echo 'else' ; \
        echo '  PW="$(python3 -c '"'"'import secrets; print(secrets.token_urlsafe(14))'"'"')"' ; \
        echo '  echo >&2 "============================================================"' ; \
        echo '  echo >&2 "VNC password (random). Set VNC_PASSWORD to use your own."' ; \
        echo '  echo >&2 "${PW}"' ; \
        echo '  echo >&2 "============================================================"' ; \
        echo 'fi' ; \
        echo '' ; \
        echo 'x11vnc -storepasswd "$PW" /root/.vnc/passwd' ; \
        echo '' ; \
        echo 'exec "$@"' ; \
    } > /usr/local/bin/docker-entrypoint.sh && \
    chmod 0755 /usr/local/bin/docker-entrypoint.sh
EXPOSE 5900
WORKDIR /root/Desktop/work
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/desktop.conf"]
