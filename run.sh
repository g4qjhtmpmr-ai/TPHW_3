#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_DATA_DIR="$PROJECT_DIR/data"
LOCAL_OUTPUT_DIR="$PROJECT_DIR/local_data"
GENERATOR_IMAGE_NAME="tp-generator"
REPORTER_IMAGE_NAME="tp-reporter"

ensure_shared_data_dir() {
  mkdir -p "$SHARED_DATA_DIR"
}

ensure_local_output_dir() {
  mkdir -p "$LOCAL_OUTPUT_DIR"
}

require_docker_cli() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "docker is required for this command"
    exit 1
  fi
}

require_python3() {
  if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 is required for this command"
    exit 1
  fi
}

print_usage() {
  cat <<'EOF'
Usage: ./run.sh <command>

Commands:
  build_generator
  run_generator
  create_local_data
  build_reporter
  run_reporter
  structure
  clear_data
  inside_generator
  inside_reporter
EOF
}

build_generator_image() {
  require_docker_cli
  docker build -t "$GENERATOR_IMAGE_NAME" "$PROJECT_DIR/generator"
}

run_generator_container() {
  require_docker_cli
  ensure_shared_data_dir
  docker run --rm -v "$SHARED_DATA_DIR:/data" "$GENERATOR_IMAGE_NAME"
}

create_local_csv() {
  require_python3
  ensure_local_output_dir
  python3 "$PROJECT_DIR/generator/generate.py" "$LOCAL_OUTPUT_DIR"
}

build_reporter_image() {
  require_docker_cli
  docker build -t "$REPORTER_IMAGE_NAME" "$PROJECT_DIR/reporter"
}

run_reporter_container() {
  require_docker_cli
  ensure_shared_data_dir
  docker run --rm -v "$SHARED_DATA_DIR:/data" "$REPORTER_IMAGE_NAME"
}

print_structure() {
  find "$PROJECT_DIR" -path "$PROJECT_DIR/.git" -prune -o -print | sed "s|$PROJECT_DIR|.|" | sort
}

clear_generated_files() {
  ensure_shared_data_dir
  find "$SHARED_DATA_DIR" -maxdepth 1 -type f \( -name "*.csv" -o -name "*.html" \) -delete
}

show_generator_data() {
  require_docker_cli
  ensure_shared_data_dir
  docker run --rm -v "$SHARED_DATA_DIR:/data" --entrypoint sh "$GENERATOR_IMAGE_NAME" -lc \
    'echo "/data inside generator:" && ls -la /data && if [ -f /data/data.csv ]; then echo && head -n 5 /data/data.csv; fi'
}

show_reporter_data() {
  require_docker_cli
  ensure_shared_data_dir
  docker run --rm -v "$SHARED_DATA_DIR:/data" --entrypoint sh "$REPORTER_IMAGE_NAME" -lc \
    'echo "/data inside reporter:" && ls -la /data && if [ -f /data/report.html ]; then echo && head -n 20 /data/report.html; fi'
}

if [ $# -ne 1 ]; then
  print_usage
  exit 1
fi

case "$1" in
  build_generator) build_generator_image ;;
  run_generator) run_generator_container ;;
  create_local_data) create_local_csv ;;
  build_reporter) build_reporter_image ;;
  run_reporter) run_reporter_container ;;
  structure) print_structure ;;
  clear_data) clear_generated_files ;;
  inside_generator) show_generator_data ;;
  inside_reporter) show_reporter_data ;;
  *)
    print_usage
    exit 1
    ;;
esac
