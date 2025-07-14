# ベースとなるUbuntuのLTS版
FROM ubuntu:22.04

# 対話を抑制（Dockerfileでの自動構築用）
ENV DEBIAN_FRONTEND=noninteractive

# 基本パッケージとSSH・UFWをインストール
RUN apt update && apt install -y \
    sudo \
    curl \
    git \
    vim \
    openssh-server \
    ufw \
    python3 \
    python3-pip

# ユーザーの作成とsudo付与（開発者ユーザー）
RUN useradd -m devuser && echo "devuser:password" | chpasswd && adduser devuser sudo

# SSHサービス用のディレクトリ作成
RUN mkdir /var/run/sshd

# SSH鍵認証を許可するための公開鍵設置（ここでは空のまま）
RUN mkdir -p /home/devuser/.ssh && chown devuser:devuser /home/devuser/.ssh

# 起動時にSSHを有効にするスクリプトを配置
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# SSH用ポートを公開
EXPOSE 22

# コンテナ起動時に実行されるコマンド
CMD ["/entrypoint.sh"]
