VENV=.venv
PYTHON=$(VENV)/bin/python
PIP=$(VENV)/bin/pip
FLASK=$(VENV)/bin/flask

.PHONY: help venv install run migrate upgrade makemigrations shell

help:
	@echo "Comandos disponibles:"
	@echo "  make venv           - Crear entorno virtual"
	@echo "  make install        - Instalar dependencias"
	@echo "  make run            - Ejecutar servidor Flask en desarrollo"
	@echo "  make makemigrations -m \"mensaje\" - Generar migraciones (flask db migrate)"
	@echo "  make migrate        - Aplicar migraciones (flask db upgrade)"
	@echo "  make shell          - Abrir shell Flask"

venv:
	python3 -m venv $(VENV)

install: venv
	$(PIP) install -r requirements.txt

run:
	FLASK_APP=app.py FLASK_ENV=development $(FLASK) run

makemigrations:
	FLASK_APP=app.py $(FLASK) db migrate -m "$(m)"

migrate:
	FLASK_APP=app.py $(FLASK) db upgrade

shell:
	FLASK_APP=app.py $(FLASK) shell