#!/bin/bash

set -e

SCENARIOS_DIR="scenarios"
RESULTS_DIR="results"
REPORT_DIR="report"

START_DATE="$1"
END_DATE="$2"

echo "Запуск тестов с параметрами:"
echo "START_DATE=$START_DATE"
echo "END_DATE=$END_DATE"

rm -rf "$RESULTS_DIR" "$REPORT_DIR"
mkdir -p "$RESULTS_DIR" "$REPORT_DIR"

echo "Текущая директория:"
pwd
echo "Содержимое папки сценариев:"
ls -l "$SCENARIOS_DIR"

for scenario in "$SCENARIOS_DIR"/*.jmx; do
    scenario_name=$(basename "$scenario" .jmx)
    jtl_file="$RESULTS_DIR/${scenario_name}.jtl"
    html_report_dir="$REPORT_DIR/${scenario_name}"

    echo "Запуск сценария: $scenario_name"

    # Запуск теста с сохранением результатов
    jmeter -n -t "$scenario" \
           -l "$jtl_file" \
           -JstartDate="$START_DATE" \
           -JendDate="$END_DATE"

    # Проверяем, что файл с результатами создан и не пустой
    echo "Проверка файла результатов: $jtl_file"
    ls -lh "$jtl_file"
    head -n 10 "$jtl_file" || echo "Файл результатов пуст или недоступен"

    # Генерация html-отчёта из файла результатов
    echo "Генерация отчета для: $scenario_name"
    jmeter -g "$jtl_file" -o "$html_report_dir"
done

echo "Все сценарии завершены. Отчеты в папке: $REPORT_DIR"