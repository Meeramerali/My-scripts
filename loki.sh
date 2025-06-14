cd /usr/local/bin
curl -O -L "https://github.com/grafana/loki/releases/download/v3.2.0/loki-linux-amd64.zip"
apt install unzip
unzip loki-linux-amd64.zip
chmod a+x loki-linux-amd64
wget https://raw.githubusercontent.com/grafana/loki/v3.2.0/cmd/loki/loki-local-config.yaml
useradd --system loki
cat <<EOF | sudo tee /etc/systemd/system/loki.service
[Unit]
Description=Loki service
After=network.target

[Service]
Type=simple
User=loki
ExecStart=/usr/local/bin/loki-linux-amd64 -config.file /usr/local/bin/loki-local-config.yaml

[Install]
WantedBy=multi-user.target
EOF
service loki start
service loki status
systemctl enable loki.service


