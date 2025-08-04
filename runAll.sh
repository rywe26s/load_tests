#!/bin/bash

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

for scenario in "$SCENARIOS_DIR"/*.jmx; do
    scenario_name=$(basename "$scenario" .jmx)
    jtl_file="$RESULTS_DIR/${scenario_name}.jtl"
    html_report_dir="$REPORT_DIR/${scenario_name}"
    log_file="$RESULTS_DIR/${scenario_name}.log"

    echo "Запуск сценария: $scenario_name"

    jmeter -n -t "$scenario" \
           -l "$jtl_file" \
           -JstartDate="$START_DATE" \
           -JendDate="$END_DATE" \
           -j "$log_file"

    if [ ! -s "$jtl_file" ]; then
      echo "Файл результатов $jtl_file пуст или не создан!"
      echo "Содержимое лога $log_file:"
      tail -40 "$log_file"
      exit 1
    fi

    echo "Генерация отчета для: $scenario_name"
    jmeter -g "$jtl_file" -o "$html_report_dir"
done

echo "Все сценарии завершены. Отчеты в папке: $REPORT_DIR"