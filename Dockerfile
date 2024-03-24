FROM python:3.10-alpine as builder
ARG ENV=PROD
RUN apk add gcc musl-dev libffi-dev libpq-dev && \
    pip install poetry
COPY ./pyproject.toml /tmp/pyproject.toml
RUN cd /tmp && \
    poetry export --output /tmp/prod-requirements.txt && \
    pip install -r /tmp/prod-requirements.txt && \
    if [ ${ENV} = "DEV" ]; then \
        poetry export --only dev --output /tmp/dev-requirements.txt && \
        pip install -r /tmp/dev-requirements.txt; \
    fi && \
    rm -rf /tmp && \
    cd ..

COPY ./app ./app
WORKDIR /app
