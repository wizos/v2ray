#!/bin/sh

# config caddy
cat << EOF > /etc/caddy/Caddyfile
:3000
root * /usr/share/caddy
file_server

@websockets_kinto {
header Connection *Upgrade*
header Upgrade    websocket
path $WSPATH
}
reverse_proxy @websockets_kinto 127.0.0.1:10086
EOF

# start tor v2ray
nohup tor &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
/usr/bin/v2ray/v2ray -config $CONFIG
