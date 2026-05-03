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

Classic VNC authentication uses exactly 8 characters. The container rejects shorter or longer custom passwords so the effective password strength is clear.

Example with your own password:

```sh
docker run --rm --detach \
  --publish 127.0.0.1:5900:5900 \
  --env VNC_PASSWORD='aB3dE5gH' \
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

### Japanese Input

The VNC desktop starts IBus Anthy, so Japanese can be entered directly in KH Coder from macOS VNC clients.
If the input method is still English, select Anthy from the IBus indicator in the desktop panel.

## [Tutorial](https://khcoder.net/tutorial.html)

1.  Click `プロジェクト` > `新規` of menu
1.  Click `分析対象ファイル` > `参照`
1.  Open `/root/Desktop/tutorial_jp/kokoro.xls`
1.  Confirm that `テキスト` is selected for `分析対象とする列`
1.  Confirm that `日本語`, `MeCab` is selected for `言語`
1.  Click `OK`
1.  Click `前処理` > `語の取捨選択` of menu
1.  Enter `一人` and `二人` to `強制選択する語の指定`
    -   It is possible to force the extraction of words that are not extracted as a single word even though they are important words.
    -   It is also effective when the division is too fine, such that `一人` is divided into `一` and `人`.
    -   It is useful for identifying too fine divisions executing `前処理` > `複合語の検出` > `名詞を連結` of menu.
1.  Click `OK`
1.  Click `前処理` > `前処理の実行` of menu
1.  Click `OK`

## Note

-   Since DBD::CSV was not installed the first time, `install DBD::CSV` is executed twice.
-   Since the old version of the R packages could not be installed from official repository, it is installed using the `remote` package.
-   Since the name of the Desktop directory changes depending on the language, it is fixed to English by executing `LANG=C xdg-user-dirs-update --force`.
