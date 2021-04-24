# Docker KH Coder

**Docker Image for [KH Coder](https://github.com/ko-ichi-h/khcoder).**

## Dependencies

-   KH Coder 2.00f
-   Ubuntu 18.04
-   Perl 5.26.1
-   R 3.4.4
-   MeCab 0.996
-   MeCab IPADic 2.7.0-20070801

## Installation

```sh
docker pull naoigcat/kh-coder
```

## Usage

```sh
docker run --rm --detach --publish 5900:5900 --volume .:/root/Desktop/work naoigcat/kh-coder
open vnc://localhost:5900
```

-   Password for VNC: `secret`

## [Tutorial](http://khcoder.net/tutorial.html)

1.  メニュー>プロジェクト>新規をクリック
2.  参照をクリックして `/root/Desktop/work/tutorial_jp/kokoro.xls` を開く
3.  分析対象とする列に`テキスト`と言語に`日本語`、`MeCab`が選択されていることを確認
4.  OKをクリック
5.  メニュー>前処理>語の取捨選択をクリック
6.  強制抽出する語の指定に`一人`、`二人`を入力
    -   KH Coderの画面に直接日本語が入力できないためLeafpadに入力してからコピーして貼り付ける
    -   重要な言葉なのに、一語として抽出されない時は強制抽出
    -   `一人`が`一`と`人`に分かれてしまうような、分割が細かすぎる場合にも有効
    -   細かすぎる分割を洗い出すにはメニュー>前処理>複合語の抽出コマンドが便利
7.  OKをクリック
8.  メニュー>前処理>前処理の実行をクリック
9.  OKをクリック

## Note

-   `install DBD::CSV`は一度だけ実行してもインストールされなかったため二回インストールを行っている
-   Rのパッケージは公式リポジトリから古いバージョンがインストールできなかったため`remote`パッケージを利用して古いバージョンのパッケージをインストールしている
-   `LANG=C xdg-user-dirs-update --force`でDesktopディレクトリの名称を英語に固定化している
-   KH Coderに直接日本語を入力できなかったため起動時にLeafpadも起動させてこちらに入力後コピーアンドペーストする想定になっている
