ARG helm_version=3.2.4
ARG kubectl_version=1.18.6
ARG docker_version=19.03.12
ARG istioctl_version=1.6.5
ARG terraform_version=0.12.29
ARG k9s_version=0.21.4

FROM alpine/helm:${helm_version} as helm
FROM bitnami/kubectl:${kubectl_version} as kubectl
FROM docker:${docker_version} as docker
FROM istio/istioctl:${istioctl_version} as istioctl
FROM hashicorp/terraform:${terraform_version} as terraform
FROM quay.io/derailed/k9s:v${k9s_version} as k9s
FROM frolvlad/alpine-python3:latest as release

COPY --from=docker /usr/local/bin/docker /usr/bin/docker
COPY --from=helm /usr/bin/helm /usr/bin/helm
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/bin/kubectl
COPY --from=istioctl /usr/local/bin/istioctl /usr/bin/istioctl
COPY --from=terraform /bin/terraform /usr/bin/terraform
COPY --from=k9s /bin/k9s /usr/bin/k9s

ARG kubectx_version=0.9.1
ARG kubens_version=0.9.1
ARG gloo_version=1.4.6
RUN pip install awscli awssamlpy3 okta-awscli \
  && apk add nano \
  && mkdir -p /etc/docker \
  && echo {\"hosts\": [\"unix:///var/run/docker.sock\"]} > /etc/docker/daemon.json \
  && rm -rf /var/cache/apk/* /tmp/* \
  && wget -O kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/v${kubectx_version}/kubectx_v${kubectx_version}_linux_x86_64.tar.gz \
  && tar -C /usr/bin -zxvf kubectx.tar.gz \
  && rm -rf kubectx.tar.gz \
  && chmod +x /usr/bin/kubectx \
  && wget -O kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/v${kubens_version}/kubens_v${kubens_version}_linux_x86_64.tar.gz \
  && tar -C /usr/bin -zxvf kubens.tar.gz \
  && rm -rf kubens.tar.gz \
  && chmod +x /usr/bin/kubens \
  && wget -O /usr/bin/glooctl https://github.com/solo-io/gloo/releases/download/v${gloo_version}/glooctl-linux-amd64 \
  && chmod +x /usr/bin/glooctl

VOLUME ["/usr/bin", "/usr/lib"]

FROM release
