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

crash -s stop
# 发起 POST 请求，发送用户名，并记录 Cookie，同时输出和保存响应内容
output_status "$LOG_FILE" "Executing POST request to $LOGIN_URL"
POST_RESPONSE=$(curl -c $COOKIE_FILE -d "$LOGIN_POSTBODY" -X POST -s -o $POST_RESPONSE_CONTENT -w "%{http_code}" $LOGIN_URL)

# 检查智慧韩园是否登录成功
POST_SUCCESS=false
if grep -q "successRedirectUrl" "$POST_RESPONSE_CONTENT" || grep -q "登录成功" "$POST_RESPONSE_CONTENT" || grep -q "Log In Successful" "$POST_RESPONSE_CONTENT"; then
    POST_SUCCESS=true
fi

# 如果智慧韩园登录成功
if [ "$POST_SUCCESS" = true ] && [ "$POST_RESPONSE" -eq 200 ]; then
    output_status "$STATUS_LOG_FILE" "Log In hstc Successful."
    output_status "$STATUS_LOG_FILE" "Executing GET request to $GET_TICKER_URL to get ticker."

    GET_RESPONSE=$(curl -b $COOKIE_FILE -H "User-Agent: $USER_AGENT" -s -w "%{http_code}" -D $HEADERS_FILE $GET_TICKER_URL | tee $GET_RESPONSE_CONTENT)

    # 检查 GET 请求的响应码
    if [ "$GET_RESPONSE" -eq 302 ]; then
        # 获取门票URL
        LOCATION=$(grep -i "Location" $HEADERS_FILE | awk '{print $2}' | tr -d '\r')
        output_status "$STATUS_LOG_FILE" "Get the ticker successful:$LOCATION"
        # 发起第三次 GET 请求，验证门票信息，并保存响应内容
        output_status "$STATUS_LOG_FILE" "Executing the ticker url GET request to verify ticker..."
        THIRD_GET_RESPONSE=$(curl -b $COOKIE_FILE -H "User-Agent: $USER_AGENT" -s -o $THIRD_GET_RESPONSE_CONTENT -w "%{http_code}" $LOCATION)
        if [ "$THIRD_GET_RESPONSE" -eq 302 ]; then
            crash -s start
            output_status "$STATUS_LOG_FILE" "Verify ticker Successful."
            exit 0
        else
            output_status "$STATUS_LOG_FILE" "Verify ticker failed."
            exit 3
        fi
    else
        output_status "$STATUS_LOG_FILE" "Get the ticker failed. "
        exit 2
    fi
else
    output_status "$STATUS_LOG_FILE" "Log In hstc failed."
    exit 1
fi
