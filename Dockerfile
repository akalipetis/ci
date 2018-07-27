ARG COMPOSE_VERSION=1.21.2
FROM docker/compose:${COMPOSE_VERSION}
LABEL maintainer="Antonis Kalipetis <akalipeits@gmail.com>"

ARG DOCKER_VERSION=18.03.1-ce
ARG DOCKER_CHANNEL=stable
ARG KUBECTL_VERSION=v1.10.3
ARG CJ_VERSION=v0.1.0
ENV DOCKER_CHANNEL=${DOCKER_CHANNEL} \
    DOCKER_VERSION=${DOCKER_VERSION}

# Install Docker binary, cj and kubectl
RUN set -ex; \
	apk add --no-cache \
		curl \
		tar \
		gettext \
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
	dockerd -v; \
	docker -v; \
	curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl; \
	chmod +x ./kubectl; \
	mv ./kubectl /usr/local/bin; \
	curl -LO https://github.com/2hog/cj/releases/download/$CJ_VERSION/cj-linux; \
	chmod +x ./cj-linux; \
	mv ./cj-linux /usr/local/bin/cj

ENTRYPOINT []
