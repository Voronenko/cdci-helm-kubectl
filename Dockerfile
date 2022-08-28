FROM alpine:3

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="cdci-helm-kubectl" \
      org.label-schema.url="https://hub.docker.com/r/voronenko/cdci-helm-kubectl/" \
      org.label-schema.vcs-url="https://github.com/voronenko/cdci-helm-kubectl" \
      org.label-schema.build-date=$BUILD_DATE

# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_LATEST_VERSION="v1.24.4"
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.4.0"

ENV PATH="/usr/local/bin:${PATH}"

RUN apk add --no-cache ca-certificates bash git openssh curl gcc musl-dev \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config    

ADD https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux /usr/local/bin/ep
RUN chmod +x /usr/local/bin/ep

ADD update_chart_yaml.py /usr/local/bin/update_chart_yaml
RUN chmod +x /usr/local/bin/update_chart_yaml

RUN apk add --no-cache \
        python3 \
        python3-dev \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
        ruamel.yaml \
    && rm -rf /var/cache/apk/*

RUN aws --version

ADD https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.8/2020-09-18/bin/linux/amd64/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
RUN chmod +x /usr/local/bin/aws-iam-authenticator

ADD https://github.com/mikefarah/yq/releases/download/v4.4.1/yq_linux_amd64 /usr/local/bin/yq
RUN chmod +x /usr/local/bin/yq

COPY slacktee /usr/local/bin
RUN chmod +x /usr/local/bin

RUN helm plugin install https://github.com/hypnoglow/helm-s3.git --version 0.10.0

WORKDIR /config

CMD bash
