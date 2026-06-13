# Homework 3

В проекте есть два контейнера:

- `generator` создает `data.csv`
- `reporter` читает `data.csv` и создает `report.html`

Оба контейнера работают с папкой `data/` на хосте.

## Основные команды

```bash
./run.sh build_generator
./run.sh run_generator
./run.sh create_local_data

./run.sh build_reporter
./run.sh run_reporter

./run.sh structure
./run.sh clear_data
./run.sh inside_generator
./run.sh inside_reporter
```

## Как запустить

```bash
./run.sh build_generator
./run.sh run_generator
./run.sh build_reporter
./run.sh run_reporter
```

После этого:

- `data/data.csv` будет создан генератором
- `data/report.html` будет создан аналитиком
