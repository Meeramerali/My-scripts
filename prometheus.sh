wget https://github.com/prometheus/prometheus/releases/download/v3.4.0/prometheus-3.4.0.linux-amd64.tar.gz
tar -xvf prometheus-3.4.0.linux-amd64.tar.gz
mkdir /var/lib/prometheus
mv prometheus-3.4.0.linux-amd64/prometheus /usr/local/bin
mv prometheus-3.4.0.linux-amd64/promtool /usr/local/bin
mkdir -p /etc/prometheus/rules
mkdir -p /etc/prometheus/rules.s
mkdir -p /etc/prometheus/files_sd
mv prometheus-3.4.0.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
groupadd --system prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus

cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.external-url=

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
EOF

chown -R prometheus:prometheus /etc/prometheus/
chown -R prometheus:prometheus /etc/prometheus/*
chown -R prometheus:prometheus /var/lib/prometheus/
chown -R prometheus:prometheus /var/lib/prometheus/*
chmod -R 775 /etc/prometheus/
chmod -R 775 /etc/prometheus/*
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
systemctl status prometheus


