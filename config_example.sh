# 配置文件：/config.sh
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# User-Agent 信息
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36"

# 以什么身份上网   1:PC  2:移动设备
MAC_TYPE="1"

# 获取本机内网 IP 地址 (适用于 ifconfig 工具)
# OpenWrt X86软路由WAN eth0
# Pavadan 老毛子WAN eth3
WAN_PORT="eth1"

WAN_IP_ADDRESS=$(ifconfig $WAN_PORT | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }')

# URL
VERIFY_IP="192.168.2.34"
VERIFY_URL="http://$VERIFY_IP/"
LOGIN_URL="https://hscas.hstc.edu.cn/cas/login"
GET_TICKER_URL="$LOGIN_URL?service=http%3A%2F%2F$VERIFY_IP%3A801%2Feportal%2F%3Fc%3DCustom%26a%3Dlogin%26login_method%3D1%26wlan_user_ip%3D$WAN_IP_ADDRESS%26wlan_user_ipv6%3D%26wlan_user_mac%3D111111111111%26wlan_ac_ip%3D%26wlan_ac_name%3D%26mac_type%3D$MAC_TYPE%26type%3D1"

# LOGIN_POSTBODY
USERNAME="2024xxxxxxxx"
PASSWORD=""
EXECUTION=""
LOGIN_POSTBODY="username=$USERNAME&password=$PASSWORD&captcha=&currentMenu=1&failN=0&mfaState=&execution=$EXECUTION&_eventId=submit&geolocation=&submit=%E7%99%BB%E5%BD%95"

# 日志文件路径
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/drcom_log.txt"
PING_LOG_FILE="$LOG_DIR/drcom_ping_log.txt"
STATUS_LOG_FILE="$LOG_DIR/drcom_status_log.txt"

# 身份文件路径
COOKIE_DIR="$SCRIPT_DIR/info"
COOKIE_FILE="$COOKIE_DIR/cookie.txt"
HEADERS_FILE="$COOKIE_DIR/headers.txt"

# 响应文件路径
RESPONSE_DIR="$SCRIPT_DIR/responses"
POST_RESPONSE_CONTENT="$RESPONSE_DIR/post_response.html"
GET_RESPONSE_CONTENT="$RESPONSE_DIR/get_response.html"
THIRD_GET_RESPONSE_CONTENT="$RESPONSE_DIR/third_get_response.html"
CHECK_LOGIN_CONTENT="$RESPONSE_DIR/check_hotspot_content.html"

# 输出状态信息到控制台并追加到日志文件中
output_status() {
    local LOG_FILE="$1" # 接收日志文件路径作为第一个参数
    local message="$2"  # 接收消息内容作为第二个参数
    # 输出到日志文件并显示在控制台
    echo "$(date): $message" | tee -a "$LOG_FILE"
    # 使用 logger 发送日志到系统日志
    logger "hstc: $(date): $message"
}

output_status "$LOG_FILE" "Current directory: $SCRIPT_DIR"
output_status "$LOG_FILE" "Current WAN IP address: $WAN_IP_ADDRESS"