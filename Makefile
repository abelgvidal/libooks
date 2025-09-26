VENV=.venv
PYTHON=$(VENV)/bin/python
PIP=$(VENV)/bin/pip
FLASK=$(VENV)/bin/flask
GITHUB_USER=abelgvidal
IMAGE_NAME=libooks


.PHONY: help venv install run migrate upgrade makemigrations shell

help:
	@echo "Comandos disponibles:"
	@echo "  make venv           - Crear entorno virtual"
	@echo "  make install        - Instalar dependencias"
	@echo "  make run            - Ejecutar servidor Flask en desarrollo"
	@echo "  make makemigrations -m \"mensaje\" - Generar migraciones (flask db migrate)"
	@echo "  make migrate        - Aplicar migraciones (flask db upgrade)"
	@echo "  make shell          - Abrir shell Flask"
	@echo "  make create_tables  - Crear tablas en la base de datos"
	@echo "  make docker-build   - Crear la imagen docker"
	@echo "  make docker-run     - Ejecutar la imagen docker"
venv:
	python3 -m venv $(VENV)

install: venv
	$(PIP) install -r requirements.txt

run:
	FLASK_APP=app.py FLASK_ENV=development $(FLASK) run

makemigrations:
	FLASK_APP=app.py $(FLASK) db migrate

migrate:
	FLASK_APP=app.py $(FLASK) db upgrade

shell:
	FLASK_APP=app.py $(FLASK) shell

create_tables:
	FLASK_APP=app.py $(FLASK) create_tables

docker-build:
	docker build . -t ghcr.io/$(GITHUB_USER)/$(IMAGE_NAME)

docker-run:
	docker run -p 5000:5000 -v ./instance:/app/instance $(IMAGE_NAME)

docker-push:
	@echo "$(GITHUB_TOKEN_REGISTRY)" | docker login ghcr.io -u $(GITHUB_USER) --password-stdin
	docker push ghcr.io/$(GITHUB_USER)/$(IMAGE_NAME)























