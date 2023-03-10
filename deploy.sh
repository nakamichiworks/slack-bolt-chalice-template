#!/bin/bash
set -e
SCRIPT_DIR="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"
cd "${SCRIPT_DIR}/app"

stage="${1:-dev}"  # dev or prod

poetry export -f requirements.txt --output requirements.txt --only main
jinja2 .chalice/config.template.json \
    -D SLACK_BOT_TOKEN="${SLACK_BOT_TOKEN}" \
    -D SLACK_SIGNING_SECRET="${SLACK_SIGNING_SECRET}" \
    -D SLACK_BOT_TOKEN_DEV="${SLACK_BOT_TOKEN_DEV}" \
    -D SLACK_SIGNING_SECRET_DEV="${SLACK_SIGNING_SECRET_DEV}" \
    > .chalice/config.json

chalice deploy --stage ${stage}
