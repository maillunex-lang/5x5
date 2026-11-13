# ETERNAL LEGENDS ONLINE v0.7: три этапа

## Этап 1: код и устойчивость
- Ограничение шага боевой симуляции вынесено в константу.
- Вызов метода динамического скрипта арены переведён на `call`, чтобы избежать проверки несуществующего метода у статического типа `Control`.
- Уточнены тип данных сохранения и защитная проверка метки журнала боя.
- Сохранён исходный офлайн-цикл игры, без вмешательства в другие проекты.

## Этап 2: проверка настоящим Godot
- Добавлен `tools/godot_smoke.gd`, который загружает сцену, проверяет отряд и запускает 5×5 бой.
- Добавлен `.github/workflows/godot-check.yml` для запуска Godot 4.3 в GitHub Actions после публикации проекта в репозиторий. Workflow не запускался и в GitHub ничего не отправлялось.

## Этап 3: подготовка Android
- Добавлен `export_presets.cfg` с портретной ориентацией и ARM64.
- Добавлен `tools/build_android.sh`, который запускает импорт, smoke-тест, debug-экспорт и проверяет ненулевой размер APK.
- Нужны Godot 4.3, export templates, Android SDK, Java, настроенные пути и debug signing. Пресет и скрипт ещё не проверены реальным Godot.

## Фактические результаты
- Python unittest: **51/51 PASS** (проверки структуры и контрактов, не GDScript runtime).
- `bash -n tools/build_android.sh`: PASS.
- YAML parsing: PASS.
- Godot runtime: NOT RUN (binary unavailable).
- APK: NOT BUILT.
- VPS/GitHub: UNCHANGED.

## Следующий шаг
Запустить Godot CI на отдельном runner, устранить ошибки парсера и runtime, затем собрать Android debug APK. Установка на телефон и проверка safe area обязательны до объявления беты.