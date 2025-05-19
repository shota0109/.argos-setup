# Raspberry Pi セットアップ手順書

## 基本セットアップツールのインストール
```bash
sudo apt update  
sudo apt install -y raspi-config openssh-server git

#VSCodeのインストール
#以下のURLからダウンロード
https://update.code.visualstudio.com/1.97.2/linux-deb-arm64/stable
#インストール
cd ~/Downloads
sudo dpkg -i code_1.97.2-1739406006_arm64.deb
#バージョンを固定
sudo apt-mark hold code
```

## SSHに権限を与える
```bash
sudo raspi-config
#interface→ssh→enableで有効
#長い

#再起動
sudo reboot
#長い
```

## ホストPCからSSH接続
```bash
#raspi5側での操作
ip a
#IPアドレスが表示される
#inetの部分

#再インストールされた物なら、ホストPCの設定のリセットを行う
ssh-keygen -R {IPアドレス}

#ホストPCでの操作
#コマンドで接続
ssh swarmXX@{IPアドレス}
#configファイル
Host swarmXX
  HostName {IPアドレス}
  User swarm00
  ForwardX11 yes
  ForwardX11Trusted yes
```

## Raspi5でのGitHubのSSH鍵設定
```bash
ssh-keygen -t ed25519 -C "{YOUR-EMAIL}"
cat ~/.ssh/id_ed25519.pub
#出力された公開鍵をGitHubに登録(ssh～から始まる文章)
#github→右上のアイコン→setting→SSH and GPG keys→New SSH keys
```

## Dockerのaptリポジトリのセットアップ
```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

#Dockerパッケージをインストール
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker -v
```

## Docker Groupへの追加
```bash
#グループがあるか確認
cat /etc/group | grep docker

#グループがない場合
sudo groupadd docker

#ユーザをDockerグループに追加
sudo usermod -aG docker {swarmXX}
sudo reboot

#再接続
```

## Dockerサービスの自動起動
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

## リポジトリクローン
```bash
#ワークスペースの作成＆移動
mkdir -p ~/argos_ws/src
cd ~/argos_ws/src

#セットアップリポジトリのクローン
git clone git@github.com:Fujisawa-lab-inside/.argos-setup.git
cd ~/argos_ws/src/.argos-setup
```

## .envfileの修正
```bash
#ホストPCのターミナルで実行
id

#例
uid=0(root) gid=0(root) groups=0(root),44(video),1000(docker)
```

## X11サーバーにアクセス許可
```bash
#raspi5側で実行
xhost +local:docker
```

## カメラの設定
```bash
sudo apt install -y v4l-utils
v4l2-ctl --list-devices
#compose.ymlの書き換え

#自分のPCのコマンドプロンプトで実行
ipconfig
#IPv4 AddressがIPアドレス

#SSH接続したVSCodeで実行
export DISPLAY={IPv4 Address}:0.0
echo $DISPLAY
```

## コンテナの作成
```bash
docker compose up -d
#VSCodeの拡張機能でRemote Explorer,Dev Containerをインストール
#コンテナを開く
```

## コンテナ内でのGitHubのSSH鍵設定
```bash
ssh-keygen -t ed25519 -C "{YOUR-EMAIL}"
cat ~/.ssh/id_ed25519.pub
#出力された公開鍵をGitHubに登録(ssh～から始まる文章)
#github→右上のアイコン→setting→SSH and GPG keys→New SSH keys
```

## セットアップスクリプト実行
```bash
#ファイルに権限を与える
cd ~/argos_ws/src/.argos-setup
chmod +x ./raspi5-setup.sh
chmod +x update.sh

#環境の自動セットアップ
./raspi5-setup.sh

#WiringPiのインストール
cd ~/argos_ws
git clone https://github.com/WiringPi/WiringPi.git
cd ~/argos_ws/WiringPi
./build
sudo chgrp gpio /dev/gpiomem*
sudo chmod 660  /dev/gpiomem*
```

## ワークスペースの更新
```bash
cd ~/argos_ws/src/.argos-setup
./update.sh
```

## カメラのGUI表示の設定
```bash
#Raspi5自体のターミナルで実行(SSH不可)
xhost +local:docker

X11サーバ－のインストール
https://sourceforge.net/projects/vcxsrv/
```
