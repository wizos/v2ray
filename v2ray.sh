#!/bin/sh

# config caddy
cat << EOF > /etc/caddy/Caddyfile
:$PORT
root * /usr/share/caddy
file_server

@websockets_heroku {
header Connection *Upgrade*
header Upgrade    websocket
path $WSPATH
}
reverse_proxy @websockets_heroku 127.0.0.1:10086
EOF

# config v2ray
cat << EOF > /usr/bin/v2ray/config.json
{
    "inbounds": [
        {
            "port": 10086,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ]
            },
            "streamSettings": {"network": "ws","wsSettings": {"path": "$WSPATH"}}
        }
    ],

    "outbounds": [
        {
            "protocol": "freedom"
        },
        {
            "protocol": "blackhole",
            "tag": "blocked"
        },
        {
            "protocol": "socks",
            "tag": "sockstor",
            "settings": {
                "servers": [
                    {
                        "address": "127.0.0.1",
                        "port": 9050
                    }
                ]
            }
        }
    ],

    "routing": {
        "rules": [
            {
                "type": "field",
                "outboundTag": "sockstor",
                "domain": [
                    "geosite:tor"
                ]
            },
            {
                "type": "field",
                "outboundTag": "blocked",
                "domain": [
                    "geosite:category-ads-all"
                ]
            }
        ]
    }
}		
EOF

# start tor v2ray
nohup tor &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
/usr/bin/v2ray/v2ray -config /usr/bin/v2ray/config.json
