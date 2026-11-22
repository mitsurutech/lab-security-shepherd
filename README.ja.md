# Docker Composeで動かすOWASP Security Shepherdラボ：Webセキュリティの課題を1レッスンずつ練習する

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml)

[MitsuruTechラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)の、授業ですぐ使える**Webセキュリティのトレーニングラボ**です。このプラットフォームでは、学校が生徒一人ひとりに自分のデータベース、コンテナ、ターミナルをブラウザで用意できます。生徒はそれぞれ、レッスンと課題を備えたセキュリティトレーニングゲーム**OWASP Security Shepherd**の自分のコピーを受け取ります。**MariaDBとMongoDBのデータベースはもう作ってある**ので、**SQLインジェクション、クロスサイトスクリプティング、認証の不備、安全でない直接オブジェクト参照**などを練習し、解いた課題ごとに結果キーを獲得できます。生徒は欠陥を説明して証拠を提出します。何もインストールせず、ほかの人のマシンを危険にさらすこともありません。

`docker-compose`ファイル1つ、`compose.yaml`だけでできていて、自分のマシンでもプラットフォームでも同じように動きます。プラットフォームでは、生徒一人ひとりが、インターネットに出られない自分専用のコピーを使います。

## ただ1つのルール

**攻撃するのは自分のコピーだけにしてください。** このラボのものはすべて自分専用のコピーの中で動き、そのコピーにはインターネットへの経路も、ほかの生徒への経路もありません。届くのは、ラボが自分のために起動したアプリケーションだけです。ラボでもそれ以外の場所でも、自分のものでないWebサイト、ネットワーク、マシンにツールを向けてはいけません。英国では[Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents)に基づく犯罪で、ほとんどの国に同じような法律があります。弱点の仕組みを学ぶことは、弱点のないソフトウェアを作る道です。授業の最初の話題には、このルールがなぜあるのか、責任ある開示とはどういうものかがちょうどよいでしょう。

## 中身

| サービス | イメージ | メモリ | 内容 |
| --- | --- | --- | --- |
| `web` | ダイジェストで固定した[`owasp/security-shepherd`](https://hub.docker.com/r/owasp/security-shepherd) | 768 MB | Security Shepherdを動かすTomcat。ポート8080 |
| `db` | [`mariadb:10.6.22`](https://hub.docker.com/_/mariadb) | 384 MB | Shepherdがプレイヤーと結果、SQLの課題を保存するデータベース |
| `mongo` | [`mongo:4.4.29`](https://hub.docker.com/_/mongo) | 384 MB | NoSQLの課題のためのデータベース |
| `prepare` | もう一度Shepherdのイメージ | 128 MB | 起動時に一度だけ実行して終わるジョブ（下を参照） |

コピー全体で1,664 MBです。すべて固定しています。Shepherdは動き続ける`dev`タグしか公開していないので、イメージのダイジェスト`sha256:bf264289...c640ef`で固定しています（完全な値は`compose.yaml`にあります）。イメージをダウンロード済みのノートパソコンで測ると、3つのサービスは15秒ほどで正常になり、最初のページを返したあとで、Webサーバーが約590 MB、データベースが75 MBと65 MBを使います。

**データベースは何もビルドせずに作ってあります。** プロジェクト自身の手順では、2つのデータベースのイメージをMavenでソースコードからビルドします。このラボではそうしません。スキーマはアプリケーション自身のアーカイブの中にあるので、`prepare`がそれを一度開き、プロジェクトのビルドスクリプトが行う3つの小さな変更を加え（`DELIMITER`の行を戻し、課題用のアカウントが別のコンテナから接続できるようにします）、`student`というプレイヤーを追加して、ファイルをそれぞれのデータベースに渡します。データベースは初回の起動時にそれを読み込みます。Webサーバーの2つの接続ファイルはイメージの中では空で、起動時に書き込まれます。また、ここでは何も公開していない安全なポートへ、Webサーバーがすべてのリクエストをリダイレクトしないようにしています。プラットフォームが前に自分のアドレスを置くからです。

イメージは第三者のプログラムで、プロジェクト自身の公開イメージから変更せずに動かし、バージョンかダイジェストに固定しています（`latest`は使いません）。そのため、レッスンとレッスンのあいだにクラスの足元でラボが変わることはありません。ここでは何もビルドせず、このリポジトリのものはイメージに何も含めて配布していません。

## プラットフォームでの使い方

[MitsuruTechラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)は、すべての生徒にラボの専用コピーをブラウザで提供し、横にターミナルを用意します。

**試すには：**[コンテナのページ](https://mitsurutech.co.uk/ja/container)を開き、**Sample labs**でこのラボを探してStartを押します。試すだけならアカウントは必要ありません。

**クラスの課題にするには：**

1. モジュールで種類が**Lab**のタスクを作り、**In a GitHub repository**を選びます。
2. `https://github.com/mitsurutech/lab-security-shepherd`とブランチ`main`を指定します。composeファイルは既定の`compose.yaml`です。ファイルを変更したい場合は、先にリポジトリをフォークしてください。
3. 公開します。生徒のコピーは公開したコミットから始まるので、あとでここが変わっても、すでに出したラボは変わりません。
4. 何を提出するかをタスクに書き（[教員の方へ](#教員の方へ)を参照）、ほかのタスクと同じように割り当てます。

ヘルプマニュアルの[このラボのページ](https://mitsurutech.co.uk/help/lab-security-shepherd)、[セキュリティラボのガイド](https://mitsurutech.co.uk/ja/help/security-labs)、[コンテナラボのガイド](https://mitsurutech.co.uk/ja/help/labs)に、ほかのことが書いてあります。composeファイルに何を書けるか、コピーにどれだけのメモリが割り当てられるか、教員が生徒のコピーをどう開き、見守り、採点するかです。

まだ学校のアカウントがありませんか。生徒50人までなら[最初の1年は無料](https://mitsurutech.co.uk/ja/pricing)で、[登録](https://mitsurutech.co.uk/ja/signup)に必要なのはメールアドレスだけです。

## 自分のマシンで動かす

Composeプラグインつきのdockerと、2 GBほどの空きメモリが必要です。初回の起動でイメージをダウンロードします。

```bash
docker compose -f compose.yaml -f local.yaml up
```

<http://localhost:8080>を開き、`student`、パスワード`password`でサインインします。管理者は`admin`で、パスワードは同じです。プレイヤーとScore Boardを見るのに使います。Shepherdのイメージは`amd64`向けにビルドされているので、Armのマシンではdockerがエミュレーションで動かし、起動に時間がかかります。

`local.yaml`はポートを`127.0.0.1`にだけ公開するので、ラボには自分のコンピューターからしか届きません。`Ctrl-C`で止め、`docker compose -f compose.yaml -f local.yaml down -v`で削除します。アプリケーションはわざと安全でなく作ってあるので、攻撃の起点にしてかまわないマシンで動かしてください。

## 進め方

1. `student`、パスワード`password`で**サインインします**。データベースはもうできているので、準備することはありません。
2. **Get Next Challengeを押します。** 最初に出てくるのはレッスン*What are Insecure Direct Object References?*で、ゲームはそこから課題へと進みます。
3. **キーを見つけます。** どの課題にも結果キーが隠れています。課題を解いたら、ページ上部の入力欄にキーを入力して得点にします。
4. **Score Boardを見ます。** 見つけたキーの数が表示されます。管理者の`admin`は、すべてのプレイヤーとその進み具合も見られます。
5. **いつでもやり直せます。** 何も保存されないので、ラボを止めて起動し直すと、何も解いていない新しいShepherdになります。

## 教員の方へ

このラボでは、私たちは何も採点しません。ゲームは生徒が提出したキーごとに得点をつけ、管理者はScore Boardを見られますが、採点するのは、ほかのラボと同じく、生徒が提出する証拠です。

**証拠は2つに分けて求めてください。** 1つめは作業の証拠です。解いた課題ごとのスクリーンショットで、ラボ自身のアドレスがブラウザに見えていて、本人のコピーだとはっきりわかるものです。2つめは理解です。課題ごとに、ページが信じるべきでなかったのに信じたものは何か、使った入力そのものとそれが通った理由、それを防げたはずのただ1つの変更を、自分の言葉で書いた段落です。2つめを見れば、理解しているのか、解説から写したのかがわかります。

**授業のどこに置くか。** 課題は、インジェクション、認証の不備、セッション管理、クロスサイトスクリプティング、安全でない直接オブジェクト参照、クロスサイトリクエストフォージェリ、セキュリティの設定ミスを扱うので、このラボはWebセキュリティとセキュアコーディングの単元、そしてその法律と倫理の面、つまり許可と範囲、Computer Misuse Act 1990、責任ある開示に向いています。正確な文言は、ご自身の資格認定機関の単元で確認してください。ここでは引用していません。

**誰が何を見られるか。** これらのラボは、16歳と17歳の生徒によく使われます。コピーは、それを起動した生徒だけのものです。そのモジュールを教える職員はコピーを開いて生徒の作業を見られますが、生徒の作業を開いたことはアクセスログに記録され、生徒もそのログを読めます。

## ラボでできないこと

ラボはインターネットにまったく出られないので、課題の中でコピーの外のWebサイトが必要なものは読み込まれません。モバイルの課題にはスマートフォンのアプリが必要で、ラボにはそれがないので、ここでは完了できません。Webサーバーには768 MB、データベースにはそれぞれ384 MBを割り当てています。間違ったパスワードを3回入力するとアカウントがしばらくロックされます。これはゲーム自身のルールなので、待つよりコピーを起動し直すほうが早いでしょう。

## トラブルシューティング

- **Startのあとすぐにはサインインページが出ない。** 数秒待ってからもう一度Openを押してください。ラボは、2つのデータベースの読み込みが終わり、Webサーバーが応答するようになってから準備完了を報告します。
- **ゲームにパスワードが違うと言われる。** プレイヤーは`student`、パスワードは小文字の`password`です。
- **自分のマシンでポート8080がすでに使われている。** `local.yaml`の左側の数字を、たとえば`127.0.0.1:8081:8080`のように変えて、そのポートを開いてください。

## ラボの確認

`test/check.sh`は、プラットフォームのランナーがすべてのサービスを起動するのと同じやり方（ケーパビリティをすべて外し、`no-new-privileges`、プロセス数の上限、メモリの上限、インターネットへの経路なし）でラボを起動し、そのネットワークの中から、このページが約束していること、つまり生徒がサインインでき、最初の課題が出されることを確かめます。Dockerが必要で、pushのたびに実行されます。それが上のバッジです。

```bash
test/check.sh
```

## バージョンとライセンス

[OWASP Security Shepherd](https://github.com/OWASP/SecurityShepherd)はGPL-3.0、[MariaDB](https://mariadb.org)はGPL-2.0、[MongoDB](https://www.mongodb.com/legal/licensing/server-side-public-license) Community ServerはServer Side Public Licenseでライセンスされています。イメージはダイジェストで固定した`owasp/security-shepherd`、`mariadb:10.6.22`、`mongo:4.4.29`で、公開されたまま動かしており、このリポジトリが再配布するものではありません。Security ShepherdはOWASPのプロジェクトで、このリポジトリはその一部ではなく、OWASPの承認を受けたものでもありません。

composeファイル、テスト、このドキュメントはMITライセンスです。[LICENSE](LICENSE)を参照してください。コピーも変更も、授業での利用も自由です。中のアプリケーションは、上でリンクしたそれぞれのプロジェクトのライセンスに従います。

## このラボについて

[Mitsuru Technologies](https://mitsurutech.co.uk/ja)が[MitsuruTechラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)のために作りました。学校向けに、Python、Java、Go、Node、SQL、Linuxをブラウザで使え、コンテナラボ、GitHubからデプロイするWebアプリ、自動採点のクイズがあります。アカウントなしでも[プレイグラウンド](https://mitsurutech.co.uk/ja/playground)でコードを試せます。このラボにはヘルプマニュアルに専用のページ[Security Shepherd lab](https://mitsurutech.co.uk/help/lab-security-shepherd)があり、ほかのラボは[ラボとサンプル](https://mitsurutech.co.uk/ja/help/labs)に載っています。

同じところのほかのラボ：[lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop)、[lab-dvwa](https://github.com/mitsurutech/lab-dvwa)、[lab-webgoat](https://github.com/mitsurutech/lab-webgoat)、[lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin)、[lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea)、[lab-sample](https://github.com/mitsurutech/lab-sample)。

## このリポジトリのパスワードについて

`compose.yaml`にあるデータベースのパスワード（`CowSaysMoo`）は、OWASP Security Shepherd自身が公開している既定値です。自分のコンピューターかプラットフォームの中でしか動かないラボのためのフィクスチャで、本物の認証情報ではありません。わざとここに書いています。
