# syntax=docker/dockerfile:1.4
ARG PLATFORM
FROM --platform=$PLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023 as base

RUN <<EOT
  dnf groupinstall -y 'Development Tools'
  dnf install -y rpm-build
  dnf swap -y gnupg2-minimal gnupg2-full
  dnf install -y \
      aspell-devel \
      bzip2-devel \
      gmp-devel \
      httpd-devel \
      httpd-filesystem \
      krb5-devel \
      libacl-devel \
      libpq-devel \
      libtidy-devel \
      libtool-ltdl-devel \
      lmdb-devel \
      net-snmp-devel \
      nginx-filesystem \
      openldap-devel \
      openssl-devel \
      pam-devel \
      'pkgconfig(enchant-2)' \
      'pkgconfig(gdlib)' \
      'pkgconfig(icu-i18n)' \
      'pkgconfig(icu-io)' \
      'pkgconfig(icu-uc)' \
      'pkgconfig(libcurl)' \
      'pkgconfig(libedit)' \
      'pkgconfig(libexslt)' \
      'pkgconfig(libffi)' \
      'pkgconfig(libpcre2-8)' \
      'pkgconfig(libsasl2)' \
      'pkgconfig(libsodium)' \
      'pkgconfig(libsystemd)' \
      'pkgconfig(libxml-2.0)' \
      'pkgconfig(libxml-2.0)' \
      'pkgconfig(libxslt)' \
      'pkgconfig(libzip)' \
      'pkgconfig(oniguruma)' \
      'pkgconfig(sqlite3)' \
      smtpdaemon \
      systemtap-sdt-devel \
      tokyocabinet-devel \
      unixODBC-devel
EOT

FROM base

CMD rpmbuild -ba --clean /root/rpmbuild/SPECS/php.spec
