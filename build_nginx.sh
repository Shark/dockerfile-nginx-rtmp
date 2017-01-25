#!/usr/bin/env bash
set -euo pipefail

main() {
  local runtime_pkg build_pkg nginx_version rtmp_version src_dir
  build_pkg='build-base wget ca-certificates openssl-dev pcre-dev zlib-dev bash'
  runtime_pkg='openssl zlib pcre'
  apk add $runtime_pkg $build_pkg

  nginx_version='1.11.9'
  rtmp_version='1.1.10'

  src_dir="$(mktemp -d)"
  # shellcheck disable=SC2064
  trap "rm -r '$src_dir'" EXIT

  wget -O- https://github.com/arut/nginx-rtmp-module/archive/v$rtmp_version.tar.gz | tar xzf - -C "$src_dir"

  wget -O- https://nginx.org/download/nginx-$nginx_version.tar.gz | tar xzf - -C "$src_dir"
  cd "$src_dir/nginx-$nginx_version"
  ./configure --add-module="$src_dir/nginx-rtmp-module-$rtmp_version"
  make
  make install

  mkdir /usr/local/nginx/conf.d
  cp "$src_dir/nginx-rtmp-module-$rtmp_version/stat.xsl" /usr/local/nginx/conf/

  apk del $build_pkg
  rm -rf /var/cache/apk/*
}

main "$@"
