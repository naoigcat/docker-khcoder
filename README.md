# Docker KH Coder

[![Docker Builds](https://github.com/naoigcat/docker-khcoder/actions/workflows/push.yml/badge.svg)](https://github.com/naoigcat/docker-khcoder/actions/workflows/push.yml)

[![GitHub Stars](https://img.shields.io/github/stars/naoigcat/docker-khcoder.svg)](https://github.com/naoigcat/docker-khcoder/stargazers)
[![Docker Pulls](https://img.shields.io/docker/pulls/naoigcat/khcoder)](https://hub.docker.com/r/naoigcat/khcoder)

**Docker Image for [KH Coder](https://github.com/ko-ichi-h/khcoder).**

## Dependencies

-   KH Coder 3.Beta.07h
-   Ubuntu 18.04
-   Perl 5.26.1
-   R 3.4.4
-   MeCab 0.996
-   MeCab IPADic 2.7.0-20070801

## Installation

```sh
docker pull naoigcat/khcoder
```

## Usage

```sh
docker run --rm --detach --publish 127.0.0.1:5900:5900 --volume "${PWD}:/root/Desktop/work" naoigcat/khcoder
open vnc://localhost:5900
```

Set `VNC_PASSWORD` or read the generated password from container logs; see **VNC** below.

### VNC

The container runs [x11vnc](https://github.com/LibVNC/x11vnc) on port **5900**. The VNC password is **not** baked into the image.

-   **`VNC_PASSWORD`**: If you set this environment variable, that string is used as the VNC password when the container starts.
-   **If `VNC_PASSWORD` is unset**: A random password is generated at startup. It is printed once to **standard error**, so read it with `docker logs` (or your orchestrator’s log view) before connecting.

Example with your own password:

```sh
docker run --rm --detach \
  --publish 127.0.0.1:5900:5900 \
  --env VNC_PASSWORD='choose-a-strong-password' \
  --volume "${PWD}:/root/Desktop/work" \
  naoigcat/khcoder
```

Example using a random password (check logs):

```sh
CID=$(docker run --rm --detach --publish 127.0.0.1:5900:5900 --volume "${PWD}:/root/Desktop/work" naoigcat/khcoder)
docker logs "$CID" 2>&1
```

Security notes:

-   Prefer **`127.0.0.1:5900:5900`** (as above) so VNC is only reachable from the host, unless you intentionally need remote access and protect it (VPN, SSH tunnel, firewall, etc.).
-   Do not expose port 5900 on untrusted networks without additional controls.

## [Tutorial](https://khcoder.net/tutorial.html)

1.  Click 'Menu' > 'Project' > 'New'
1.  Click 'Browse'
1.  Open `/root/Desktop/tutorial_jp/kokoro.xls`
1.  Confirm that `テキスト` is selected for the column to be analyzed
1.  Confirm that `日本語`, `MeCab` is selected for the language
1.  Click 'OK'
1.  Click 'Menu' > 'PRe-Processing' > 'Select Words to Analyze'
1.  Enter `一人` and `二人` to 'Pick up following strings as words:'
    -   Since Japanese cannot be entered directly on the KH Coder screen, enter it in Leafpad and then copy and paste.
    -   It is possible to force the extraction of words that are not extracted as a single word even though they are important words.
    -   It is also effective when the division is too fine, such that `一人` is divided into `一` and `人`.
    -   It is useful for identifying too fine divisions executing 'Menu' > 'PRe-Processing' > 'Word Clusters'.
1.  Click 'OK'
1.  Click 'Menu' > 'PRe-Processing' > 'Run Pre-Processing'
1.  Click 'OK'

## Note

-   Since DBD::CSV was not installed the first time, `install DBD::CSV` is executed twice.
-   Since the old version of the R packages could not be installed from official repository, it is installed using the `remote` package.
-   Since the name of the Desktop directory changes depending on the language, it is fixed to English by executing `LANG=C xdg-user-dirs-update --force`.
-   Since Japanese could not be entered directly into KH Coder, it is assumed to be input to Leafpad and copy and paste to KH Coder.
