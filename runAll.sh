#!/bin/bash

set -e

SCENARIOS_DIR="scenarios"
RESULTS_DIR="results"
REPORT_DIR="report"

START_DATE="$START_DATE"
END_DATE="$END_DATE"

echo "Запуск тестов с параметрами:"
echo "START_DATE=$START_DATE"
echo "END_DATE=$END_DATE"

rm -rf "$RESULTS_DIR" "$REPORT_DIR"
mkdir -p "$RESULTS_DIR" "$REPORT_DIR"

for scenario in "$SCENARIOS_DIR"/*.jmx; do
    scenario_name=$(basename "$scenario" .jmx)
    jtl_file="$RESULTS_DIR/${scenario_name}.jtl"
    html_report_dir="$REPORT_DIR/${scenario_name}"

    echo "Запуск сценария: $scenario_name"

    jmeter -n -t "$scenario" \
           -l "$jtl_file" \
           -JstartDate="$START_DATE" \
           -JendDate="$END_DATE"

    echo "Генерация отчета для: $scenario_name"
    jmeter -g "$jtl_file" -o "$html_report_dir"
done

echo "Все сценарии завершены. Отчеты в папке: $REPORT_DIR"
