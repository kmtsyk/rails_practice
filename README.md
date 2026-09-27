# myapp

Rails 8.1 の練習用アプリケーション。Dockerで起動。

## 構成

| 項目 | 内容 |
| --- | --- |
| Ruby | 3.4.8 |
| Rails | 8.1.3 |
| DB | SQLite3 (`storage/development.sqlite3`) |
| Web サーバ | Puma |
| ポート | ホスト `3001` → コンテナ `3001` |
| サービス名 | `web` (コンテナ名 `rails_web`) |

## 前提

Docker Desktop（または Docker Engine + Compose v2）がインストール済みであること。

```bash
docker --version
docker compose version
```

## 起動方法

### 1. イメージのビルド

初回、または `Gemfile` / `Dockerfile` を変更したときに実行する。

```bash
docker compose build
```

### 2. データベースの準備

初回のみ実行する。

```bash
docker compose run --rm web bin/rails db:prepare
```

`db:prepare` は DB が無ければ作成してマイグレーションを実行し、既にあればマイグレーションのみ実行する。

### 3. サーバの起動

```bash
docker compose up
```

ブラウザで http://localhost:3001 を開く。

バックグラウンドで起動する場合は `-d` を付ける。

```bash
docker compose up -d
docker compose logs -f web   # ログを追う
```

### 4. 停止

```bash
docker compose down          # コンテナを停止・削除（gem のボリュームは残る）
docker compose down -v       # ボリュームも削除（gem を入れ直したいとき）
```

### 5. 再作成

#### 古いコンテナを完全破棄して再構築
```bash
docker compose down
docker compose build --no-cache
# 古いコンテナの残骸を無視し、新しい設定ファイルに基づいてコンテナを強制的に新規作成
docker compose up --force-recreate
```

#### イメージから
```bash
docker compose build --no-cache
docker compose up -d
```

#### 完全に更地にする：ボリュームごと破棄
```bash
docker compose down -v
docker compose up -d --build
docker compose run --rm web bin/rails db:reset
```


`docker compose up` をフォアグラウンドで実行している場合は `Ctrl + C` でも停止できる。

## よく使うコマンド

コンテナ内でコマンドを実行する。`exec` は起動中のコンテナに対して、`run --rm` は使い捨てのコンテナで実行する。

```bash
# シェルに入る
docker compose exec web bash

# マイグレーション
docker compose exec web bin/rails db:migrate

# コンソール
docker compose exec web bin/rails console

# ルーティング一覧
docker compose exec web bin/rails routes

# generate（コンテナが起動していないときは run --rm を使う）
docker compose run --rm web bin/rails generate model Post title:string

# テスト
docker compose exec web bin/rails test

# RuboCop
docker compose exec web bin/rubocop
```

`generate` などでファイルを作ると、`.:/app` のマウント経由でホスト側にもそのまま反映される。

## gem を追加したとき

`Gemfile` を編集したら、イメージを再ビルドしてから起動し直す。

```bash
docker compose build
docker compose up
```

## 補足

- `docker-compose.yml` の `volumes` でソースコード（`.:/app`）と gem（`bundle_data:/usr/local/bundle`）をマウントしているため、コードの変更は再ビルド不要で反映され、gem はコンテナを作り直しても保持される。
- `entrypoint.sh` が起動時に `tmp/pids/server.pid` を削除するため、コンテナが異常終了した後でも「server is already running」で起動に失敗しない。
- PostgreSQL を使う場合は `docker-compose.yml` の `db` サービスと `postgres_data` ボリュームのコメントアウトを外し、`config/database.yml` の adapter を `postgresql` に変更する。

## トラブルシューティング

| 症状 | 対処 |
| --- | --- |
| `port is already allocated` | ホストの 3001 番を使っているプロセスを止めるか、`docker-compose.yml` の `ports` を `"3002:3001"` などに変更する |
| gem が見つからない / bundle エラー | `docker compose down -v` でボリュームを消してから `docker compose build` |
| DB 関連のエラー | `docker compose run --rm web bin/rails db:prepare` を実行する |
| 変更がブラウザに反映されない | `docker compose restart web` |

---

# aaaa