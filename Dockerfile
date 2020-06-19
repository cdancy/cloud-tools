FROM dtzar/helm-kubectl:3.2.3 as helmKubectl
FROM alpinelinux/docker-cli:latest-x86_64 as dockerCli

FROM frolvlad/alpine-python3:latest as release

COPY --from=dockerCli /usr/bin/docker /usr/bin/docker
COPY --from=helmKubectl /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helmKubectl /usr/local/bin/helm /usr/local/bin/helm

RUN pip install awscli awssamlpy3 \
  && mkdir -p /etc/docker \
  && echo {\"hosts\": [\"unix:///var/run/docker.sock\"]} > /etc/docker/daemon.json \
  && rm -rf /var/cache/apk/* /tmp/*

FROM release
