#!/bin/bash

# Проверяем, передан ли аргумент (город)
if [ -z "$1" ]; then
    echo "Ошибка: Укажите город."
    echo "Использование: $0 <город>"
    exit 1
fi

CITY="$1"
OUTPUT_FILE="/var/www/html/index.nginx-debian.html"

CALL_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Выполняем запрос и извлекаем данные
# .temp_C — температура, .humidity — влажность
DATA=$(curl -s "wttr.in/${CITY}?format=j1" | jq -r '.["current_condition"][0] | "\(.temp_C) \(.humidity)"')

# Проверяем, удалось ли получить данные
if [ -z "$DATA" ]; then
    echo "Ошибка: Не удалось получить данные о погоде для города $CITY."
    exit 1
fi

# Разделяем полученную строку на две переменные
TEMP=$(echo "$DATA" | awk '{print $1}')
HUMIDITY=$(echo "$DATA" | awk '{print $2}')

# Формируем текст для вывода
RESULT="Время вызова: $CALL_TIME | Город: $CITY | Температура: ${TEMP}°C | Влажность: ${HUMIDITY}%"

# Выводим в консоль
echo "$RESULT"

# Записываем в файл
echo "$RESULT" > "$OUTPUT_FILE"

echo "Данные записаны в $OUTPUT_FILE"
