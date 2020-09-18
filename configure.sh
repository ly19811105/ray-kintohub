#!/bin/sh

# V2Ray new configuration
mkdir /etc/v2ray
touch /etc/v2ray/config.json
cat <<-EOF > /etc/v2ray/config.json
{
  "inbounds": [
  {
    "port": ${PORT},
    "protocol": "vless",
    "settings": {
      "decryption": "none",
      "clients": [
        {
          "id": "${UUID}",
          "alterId": "${ALTER_ID}"
        }
      ]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "${V2_PATH}"
      }
    }
  }
  ],
  "outbounds": [
  {
    "protocol": "freedom",
    "settings": {}
  }
  ]
}
EOF
