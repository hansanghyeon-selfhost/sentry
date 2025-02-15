#!/bin/bash

# 1. 프로젝트의 PK를 입력받기
read -p "프로젝트를 지칭하는 키를 입력하세요: " PK


# 2. PK를 환경변수로 저장
export PK


# 3. 특정 저장소 클론하기 (URL은 예시입니다. 실제 저장소 URL로 변경하세요)
REPO_URL="https://github.com/getsentry/self-hosted.git"
git clone "$REPO_URL" sentry-self-hosted-$PK

# 프로젝트 파일이름 설정
PROJECT_FOLDER="./sentry-self-hosted-$PK"

# 4. .env 파일 업데이트
ENV_FILE="$PROJECT_FOLDER/.env"
if [ -f "$ENV_FILE" ]; then
    # COMPOSE_PROJECT_NAME과 UNIQUE_KEY 업데이트
    sed -i "s/^COMPOSE_PROJECT_NAME=sentry-self-hosted$/COMPOSE_PROJECT_NAME=sentry-self-hosted-${PK}/" "$ENV_FILE"
  $
    echo "UNIQUE_KEY=$PK" >> "$ENV_FILE"
else
    echo "$ENV_FILE 파일을 찾을 수 없습니다."
fi


# 5.====================================== docker volume PK사용한 이름으로 변경

# 5-2. PK로 변경한 볼륨체크하는 로직 모두 변경
# create-docker-volumes.sh
# upgrade-*.sh
# - docker-postgres
# - docker-kafka
# - docker-clickhouse
# upgrade는 모두다 내용이 많아서 따로 스크립트 파일을 가져오고 원본 스크립트파일은 `.bak` 확장자를 추가해서 남겨둔다.
INSTALL_FOLDER="$PROJECT_FOLDER/install"

# create-docker-volumes.sh
mv "$INSTALL_FOLDER/create-docker-volumes.sh" "$INSTALL_FOLDER/create-docker-volumes.sh.bak"
curl -o "$INSTALL_FOLDER/create-docker-volumes.sh" https://raw.githubusercontent.com/hansanghyeon-selfhost/sentry/refs/heads/main/create-docker-volumes.sh

# clickhouse
# 기존파일 백업
mv "$INSTALL_FOLDER/upgrade-clickhouse.sh" "$INSTALL_FOLDER/upgrade-clickhouse.sh.bak"
curl -o "$INSTALL_FOLDER/upgrade-clickhouse.sh" https://raw.githubusercontent.com/hansanghyeon-selfhost/sentry/refs/heads/main/upgrade-clickhouse.sh

# postgres
# 기존파일 백업
mv "$INSTALL_FOLDER/upgrade-postgres.sh" "$INSTALL_FOLDER/upgrade-postgres.sh.bak"
curl -o "$INSTALL_FOLDER/upgrade-postgres.sh" https://raw.githubusercontent.com/hansanghyeon-selfhost/sentry/refs/heads/main/upgrade-postgres.sh

# 5-2. docker-compose.yml 파일의 특정 텍스트 수정
DOCKER_COMPOSE_FILE="$PROJECT_FOLDER/docker-compose.yml"
if [ -f "$DOCKER_COMPOSE_FILE" ]; then
    sed -i "s/  sentry-data:/  sentry-data:\n    name: sentry-\${UNIQUE_KEY}-data/" "$DOCKER_COMPOSE_FILE"
    sed -i "s/  sentry-postgres:/  sentry-postgres:\n    name: sentry-\${UNIQUE_KEY}-postgres/" "$DOCKER_COMPOSE_FILE"
    sed -i "s/  sentry-redis:/  sentry-redis:\n    name: sentry-\${UNIQUE_KEY}-redis/" "$DOCKER_COMPOSE_FILE"
    sed -i "s/  sentry-kafka:/  sentry-kafka:\n    name: sentry-\${UNIQUE_KEY}-kafka/" "$DOCKER_COMPOSE_FILE"
    sed -i "s/  sentry-clickhouse:/  sentry-clickhouse:\n    name: sentry-\${UNIQUE_KEY}-clickhouse/" "$DOCKER_COMPOSE_FILE"
    sed -i "s/  sentry-symbolicator:/  sentry-symbolicator:\n    name: sentry-\${UNIQUE_KEY}-symbolicator/" "$DOCKER_COMPOSE_FILE"
else
    echo "$DOCKER_COMPOSE_FILE 파일을 찾을 수 없습니다."
fi

echo "스크립트 실행이 완료되었습니다."
