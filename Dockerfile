FROM ubuntu:22.04

ARG RUNNER_VERSION="2.311.0"

RUN apt-get update -y && apt-get upgrade -y && useradd -m runner

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN cd /home/runner && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh

COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

RUN apt install -y software-properties-common && apt update
RUN add-apt-repository ppa:git-core/ppa -y && apt update
RUN apt install -y git openjdk-11-jre curl unzip && rm -r /tmp/*

RUN apt install -y libyaml-0-2 && mkdir -p /opt/hostedtoolcache && chown -R runner /opt/hostedtoolcache

USER runner

WORKDIR /

ENTRYPOINT ["./entrypoint.sh"]
