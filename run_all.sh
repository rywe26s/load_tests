#!/bin/bash

set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Использование: $0 START_DATE END_DATE"
  exit 1
fi

START_DATE="$1"
END_DATE="$2"

SCENARIOS_DIR="."
RESULTS_DIR="results"
REPORT_DIR="report"

echo "Запуск тестов с параметрами:"
echo "START_DATE=$START_DATE"
echo "END_DATE=$END_DATE"

rm -rf "$RESULTS_DIR" "$REPORT_DIR"
mkdir -p "$RESULTS_DIR" "$REPORT_DIR"

for scenario in "$SCENARIOS_DIR"/*.jmx; do
  scenarioName=$(basename "$scenario" .jmx)
  jtlFile="$RESULTS_DIR/$scenarioName.jtl"
  htmlReportDir="$REPORT_DIR/$scenarioName"

  echo "Запуск сценария: $scenarioName"

  jmeter -n -t "$scenario" \
         -l "$jtlFile" \
         -JstartDate="$START_DATE" \
         -JendDate="$END_DATE" \
         -JCONFIG_DIR="config"

  echo "Генерация отчета для: $scenarioName"
  jmeter -g "$jtlFile" -o "$htmlReportDir"
done

echo "Все сценарии завершены. Отчеты в папке: $REPORT_DIR"