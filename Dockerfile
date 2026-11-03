# (A) 웹 서버 베이스 이미지 활용: nginx:alpine + 정적 콘텐츠/설정 교체
FROM nginx:alpine

# 이미지 메타데이터 (docker inspect 로 확인 가능)
LABEL org.opencontainers.image.title="e11-web" \
      org.opencontainers.image.description="Codyssey E1-1 custom nginx image"

# 설정과 코드의 분리: 실행 시 -e 로 덮어쓸 수 있는 기본값
ENV APP_ENV=dev \
    NGINX_PORT=80

# 설정 템플릿 교체 (listen 포트/응답 헤더를 환경 변수로 제어)
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template

# 정적 콘텐츠 교체
COPY app/ /usr/share/nginx/html/

# 컨테이너 상태를 docker ps 에서 healthy/unhealthy 로 확인
HEALTHCHECK --interval=10s --timeout=3s --start-period=3s --retries=3 \
  CMD wget -qO- "http://127.0.0.1:${NGINX_PORT}/health" || exit 1

EXPOSE 80
