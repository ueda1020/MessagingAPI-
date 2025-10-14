#!/bin/bash

# JSTの日付と曜日を計算
TODAY_JST=$(date -u -d '+9 hours' '+%Y-%m-%d')
DOW_JST=$(date -u -d '+9 hours' '+%u')  # 1=Mon ... 7=Sun

# 日本の祝日かどうかを判定
HOLIDAY_NAME=$(curl -s https://holidays-jp.github.io/api/v1/date.json | jq -r --arg d "$TODAY_JST" '."$d"')
IS_HOLIDAY=false
if [ "$HOLIDAY_NAME" != "null" ]; then
  IS_HOLIDAY=true
fi

# 土日かどうかを判定
IS_WEEKEND=false
if [ "$DOW_JST" -eq 6 ] || [ "$DOW_JST" -eq 7 ]; then
  IS_WEEKEND=true
fi

# 平日かどうかを判定
IS_WEEKDAY=false
if [ "$IS_HOLIDAY" = false ] && [ "$IS_WEEKEND" = false ]; then
  IS_WEEKDAY=true
fi

# 結果を出力
echo "today_jst=$TODAY_JST"
echo "dow_jst=$DOW_JST"
echo "is_holiday=$IS_HOLIDAY"
echo "is_weekend=$IS_WEEKEND"
echo "is_weekday=$IS_WEEKDAY"
