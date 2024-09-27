ARG PGVECTORS_TAG=pg16-v0.3.0-amd64
ARG BITNAMI_TAG=16.4.0
FROM scratch as nothing
FROM tensorchord/pgvecto-rs-binary:${PGVECTORS_TAG} as binary

FROM docker.io/bitnami/postgresql-repmgr:${BITNAMI_TAG}
ADD "https://github.com/tensorchord/pgvecto.rs/releases/download/v0.2.1/vectors-pg16_0.2.1_amd64.deb" /tmp/vectors.deb
USER root
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && \
     mv /usr/lib/postgresql/*/lib/vectors.so /opt/bitnami/postgresql/lib/ && \
     mv usr/share/postgresql/*/extension/vectors* opt/bitnami/postgresql/share/extension/
USER 1001
ENV POSTGRESQL_EXTRA_FLAGS="-c shared_preload_libraries=vectors.so"
