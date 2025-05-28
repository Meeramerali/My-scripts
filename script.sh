wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.9.1.linux-amd64.tar.gz
mkdir /var/lib/node/
mv node_exporter-1.9.1.linux-amd64/node_exporter /var/lib/node/
groupadd --system prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus

cat <<EOF | sudo tee /etc/systemd/system/node.service
[Unit]
Description=Prometheus Node Exporter
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/var/lib/node/node_exporter

SyslogIdentifier=prometheus_node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF


chown -R prometheus:prometheus /var/lib/node/
chown -R prometheus:prometheus /var/lib/node/*
chmod -R 775 /var/lib/node/
chmod -R 775 /var/lib/node/*
systemctl daemon-reload
systemctl enable node
systemctl start node 
systemctl status node
                                                                     
