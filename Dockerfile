FROM dtzar/helm-kubectl:3.2.3 as helmKubectl
FROM alpinelinux/docker-cli:latest as dockerCli
FROM istio/istioctl:1.6.5 as istioCtl
FROM hashicorp/terraform:0.12.29 as terraform
FROM frolvlad/alpine-python3:latest as release

RUN pip install awscli awssamlpy3 okta-awscli \
  && mkdir -p /etc/docker \
  && echo {\"hosts\": [\"unix:///var/run/docker.sock\"]} > /etc/docker/daemon.json \
  && rm -rf /var/cache/apk/* /tmp/* \
  && mkdir -p /cloud-tools

COPY --from=dockerCli /usr/bin/docker /cloud-tools/docker
COPY --from=helmKubectl /usr/local/bin/kubectl /cloud-tools/kubectl
COPY --from=helmKubectl /usr/local/bin/helm /cloud-tools/helm
COPY --from=istioCtl /usr/local/bin/istioctl /cloud-tools/istioctl
COPY --from=terraform /bin/terraform /cloud-tools/terraform

ENV PATH="/cloud-tools:${PATH}"

VOLUME /cloud-tools

FROM release
