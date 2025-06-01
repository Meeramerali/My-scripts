apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_12.0.1_amd64.deb
dpkg -i grafana-enterprise_12.0.1_amd64.deb
systemctl daemon-reload
systemctl enable grafana-server
service grafana-server start
