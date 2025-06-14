cd /usr/local/bin
curl -O -L "https://github.com/grafana/loki/releases/download/v3.2.0/promtail-linux-amd64.zip"
unzip "promtail-linux-amd64.zip"
chmod a+x "promtail-linux-amd64"
wget https://raw.githubusercontent.com/grafana/loki/v3.2.0/clients/cmd/promtail/promtail-local-config.yaml
useradd --system promtail
cat <<EOF | sudo tee /etc/systemd/system/promtail.service
[Unit]
Description=Promtail service
After=network.target

[Service]
Type=simple
User=promtail
ExecStart=/usr/local/bin/promtail-linux-amd64 -config.file /usr/local/bin/promtail-local-config.yaml

[Install]
WantedBy=multi-user.target
EOF
service promtail start
service promtail status
systemctl enable promtail.service
usermod -a -G adm promtail
id promtail
service promtail restart
service promtail status
