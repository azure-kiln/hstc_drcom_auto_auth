#!/bin/sh
#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 读取配置文件
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "The config.sh is not found"
    exit 1
fi

# ========== 可自行修改的参数 ==========
PORTAL_API="http://192.168.2.34:801/eportal/portal/cas/create"   # 对应 page.portal_api + 'cas/create'
echo "authorization api: $PORTAL_API"

LOGIN_METHOD="1"                                # page.login_method
IP="$WAN_IP_ADDRESS"                        # term.ip
IPV6=""                                         # term.ipv6
MAC="AA:BB:CC:DD:EE:FF"                          # term.mac
WLAN_AC_IP="10.10.10.10"                         # term.wlanacip
WLAN_AC_NAME="AC001"                             # term.wlanacname
AUTHEX_ENABLE="1"                                # term.authex_enable
TYPE="1"                                        # term.type
JS_VERSION="4.X"                                # jsVersion
# =====================================

# 计算 mac_type
if [ "$TYPE" = "1" ]; then
  MAC_TYPE=0
else
  MAC_TYPE=1
fi

echo "[+] Sending identity_login request..."

RESPONSE=$(curl -s -G "$PORTAL_API" \
  --data-urlencode "login_method=$LOGIN_METHOD" \
  --data-urlencode "wlan_user_ip=$IP" \
  --data-urlencode "wlan_user_ipv6=$IPV6" \
  --data-urlencode "wlan_user_mac=$MAC" \
  --data-urlencode "wlan_ac_ip=$WLAN_AC_IP" \
  --data-urlencode "wlan_ac_name=$WLAN_AC_NAME" \
  --data-urlencode "authex_enable=$AUTHEX_ENABLE" \
  --data-urlencode "mac_type=$MAC_TYPE" \
  --data-urlencode "jsVersion=$JS_VERSION")

echo "[response] $RESPONSE"

# 去掉 JSONP 外壳
JSON=$(echo "$RESPONSE" | sed -e 's/^jsonpReturn(//' -e 's/);$//')
echo "[JSON] $JSON"

# 解析 result 字段
# 提取 result，无论是 "1" 还是 1 都能解析
RESULT=$(echo "$JSON" | grep -o '"result"[ ]*:[ ]*[^,}]*' | cut -d ':' -f 2 | tr -d ' "')
echo "[RESULT] $RESULT"

if [ "$RESULT" = "1" ] || [ "$RESULT" = "ok" ]; then
   AUTHORIZE_URI=$(echo "$JSON" | sed -n 's/.*"authorize_uri"[ ]*:[ ]*"\([^"]*\)".*/\1/p')
AUTHORIZE_URI=$(echo "$AUTHORIZE_URI" | sed 's#\\/#/#g')
 echo "Login success, opening authorization link:"
    echo "AUTHORIZE_URI: $AUTHORIZE_URI"
else
    MSG=$(echo "$RESPONSE" | grep -o '"msg"[ ]*:[ ]*"[^"]*"' | cut -d '"' -f 4)
    echo "Login failed: $MSG"
fi
