# デフォルトの振る舞い（初期設定）

# https://docs.docker.com/guides/ruby/containerize/
# Ruby 3.4.8が入った軽量Linuxイメージを使う
FROM ruby:3.4.8-slim

# 1. Debian系Linuxのパッケージ一覧を更新する
# 2. 必要なLinuxパッケージを入れる
# 3. キャッシュを消してイメージを軽くする
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    curl \
    libsqlite3-dev \
    libyaml-dev \
    sqlite3 \
    vim \
    tig \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

# これ以降の作業場所を/appで実行する
WORKDIR /app

# ホスト側にあるGemfileとGemfile.lockを、コンテナ内の現在地/appへコピー
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Gemfileに書かれたgemをインストール
RUN chmod +x entrypoint.sh

# このコンテナが使用するポートを指定
EXPOSE 3001

# コンテナ起動時に、まずentrypoint.shを実行
ENTRYPOINT ["./entrypoint.sh"]

# デバッガ(rdbg)のTCP接続を待ち受けた上で、Railsサーバーを起動する
# CMD bundle exec rdbg --open --nonstop --host 0.0.0.0 --port 12345 -c -- bundle exec rails server -b 0.0.0.0 -p 3001