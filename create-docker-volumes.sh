echo "${_group}Creating volumes for persistent storage ..."

# .env 파일에서 환경변수 불러오기
ENV_FILE_PATH=".env"
if [ -f "$ENV_FILE_PATH" ]; then
    export $(grep -v '^#' "$ENV_FILE_PATH" | xargs)
else
    echo "$ENV_FILE_PATH 파일을 찾을 수 없습니다."
    exit 1
fi

echo "Created $(docker volume create --name=sentry-$UNIQUE_KEY-clickhouse)."
echo "Created $(docker volume create --name=sentry-$UNIQUE_KEY-data)."
echo "Created $(docker volume create --name=sentry-$UNIQUE_KEY-kafka)."
echo "Created $(docker volume create --name=sentry-$UNIQUE_KEY-postgres)."
echo "Created $(docker volume create --name=sentry-$UNIQUE_KEY-redis)."
echo "Created $(docker volume create --name=sentry-$UNIQUE_KEY-symbolicator)."

echo "${_endgroup}"
