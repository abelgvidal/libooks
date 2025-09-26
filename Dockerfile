FROM python:3.11-slim-bullseye

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .
RUN chmod +x entrypoint.sh

# This is the command that will be executed by the entrypoint
ENTRYPOINT ["./entrypoint.sh"]
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]

