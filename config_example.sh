# 配置文件：/config.sh
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# User-Agent 信息
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36"

# 获取本机内网 IP 地址 (适用于 ifconfig 工具)
# OpenWrt 路由WAN wan
# OpenWrt X86软路由WAN eth0/eth1
# Pavadan 老毛子WAN eth3
WAN_PORT="eth1"

# 路由器WAN口IP地址
WAN_IP_ADDRESS=$(ifconfig $WAN_PORT | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }')

# Dr.COM服务器地址
DRCOM_SERVER_IP="192.168.2.34"
# CAS统一身份认证地址
HSCAS_URL="https://hscas.hstc.edu.cn"

# 上网认证URL
VERIFY_URL="http://$DRCOM_SERVER_IP/"
# CAS统一身份认证登录URL
HSCAS_LOGIN_URL="$HSCAS_URL/cas/login"

# 网页授权链接参数
EPORTAL_API="http://$DRCOM_SERVER_IP:801/eportal/portal"
AUTHORIZATION_API="http://192.168.2.34:801/eportal/portal/cas/create"   # page.portal_api + 'cas/create'
output_status "$LOG_FILE" "Authorization api: $AUTHORIZATION_API"

LOGIN_METHOD="1"                                # page.login_method
TERM_IP="$WAN_IP_ADDRESS"                        # term.ip
TERM_IPV6=""                                         # term.ipv6
TERM_MAC="AA:BB:CC:DD:EE:FF"                          # term.mac
WLAN_AC_IP="10.10.10.10"                         # term.wlanacip
WLAN_AC_NAME="AC001"                             # term.wlanacname
AUTHEX_ENABLE="1"                                # term.authex_enable
JS_VERSION="4.X"                                # jsVersion

# 以什么身份上网   1:PC  2:移动设备
# 计算 mac_type
MAC_TYPE="2"

# 用户名/密码 请求头
USERNAME="202400000000"
PASSWORD=""

# 登录信息 请求头 LOGIN_POSTBODY
EXECUTION=""
LOGIN_POSTBODY="username=$USERNAME&password=$PASSWORD&currentMenu=1&failN=0&execution=$EXECUTION&_eventId=submit&geolocation=&submit=%E7%99%BB%E5%BD%95"

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
output_status "$LOG_FILE" "Current User-Agent: $USER_AGENT"
output_status "$LOG_FILE" "Current WAN PORT: $WAN_PORT"
output_status "$LOG_FILE" "Current WAN IP address: $WAN_IP_ADDRESS"
output_status "$LOG_FILE" "Current Username: $USERNAME"