# Stage for Flutter web build
FROM debian:bookworm AS flutter-web-build

# 필수 의존성 설치 - 단일 RUN 명령으로 레이어 수 최소화
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Flutter SDK 설정
ARG FLUTTER_VERSION=3.29.0
ARG FLUTTER_SDK_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
ARG FLUTTER_SDK_LOCATION=/usr/local

# Flutter SDK 다운로드 및 설치
RUN curl -o flutter.tar.xz ${FLUTTER_SDK_URL} \
    && tar -xf flutter.tar.xz -C ${FLUTTER_SDK_LOCATION}/ \
    && rm flutter.tar.xz \
    && git config --global --add safe.directory ${FLUTTER_SDK_LOCATION}/flutter

# Flutter 명령어를 PATH에 추가
ENV PATH="${FLUTTER_SDK_LOCATION}/flutter/bin:${PATH}"

# Flutter 설치 검증 (필요시 생략 가능)
RUN flutter doctor -v

# 작업 디렉토리 설정
WORKDIR /app

# 자주 변경되지 않는 pubspec 파일만 먼저 복사하여 소스 코드가 변경되어도 의존성 캐시 재사용
COPY ./pubspec.yaml ./pubspec.lock ./

# 의존성 설치 
RUN flutter clean \
    && flutter pub get

# 소스 코드 복사 및 빌드 - 이 단계는 소스 코드가 변경될 때마다 캐시 무효화
COPY . .

# 웹 빌드 수행 - 코드 생성기 먼저 실행 후 최종 빌드
RUN dart run build_runner build \
    && flutter build web --release

# Stage for Nginx
FROM nginx:1.25.2-alpine

# 빌드된 웹 애플리케이션 복빌
COPY --from=flutter-web-build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]