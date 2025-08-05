#!/bin/bash

sed -i 's/\r$//' "$0"
set -e

START_DATE="$1"
END_DATE="$2"

SCENARIOS_DIR="scenarios"
RESULTS_DIR="results"
REPORT_DIR="report"
CONFIG_DIR="config"
TEST_DATA_DIR="test_data"

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
         -JCONFIG_DIR="$CONFIG_DIR" \
         -JTEST_DATA_DIR="$TEST_DATA_DIR" \
         -JstartDate="$START_DATE" \
         -JendDate="$END_DATE"

  echo "Generating report for: $scenarioName"
  jmeter -g "$jtlFile" -o "$htmlReportDir"
done

echo "All reports saved to: $REPORT_DIR"