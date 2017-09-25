ARG COMPOSE_VERSION=1.16.1
FROM docker/compose:${COMPOSE_VERSION}
LABEL maintainer="Antonis Kalipetis <akalipeits@gmail.com>"

ARG DOCKER_VERSION=17.07.0-ce
ARG DOCKER_CHANNEL=edge
ENV DOCKER_CHANNEL=${DOCKER_CHANNEL} \
    DOCKER_VERSION=${DOCKER_VERSION}

ADD cj /usr/src/bin/cj

# Install Docker binary
RUN set -ex; \
	apk add --no-cache --virtual .fetch-deps \
		curl \
		tar \
	; \
	if ! curl -fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz"; then \
		echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for 'x86_64'"; \
		exit 1; \
	fi; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	apk del .fetch-deps; \
	\
	dockerd -v; \
	docker -v

ENTRYPOINT []
