# hadolint ignore=DL3007
FROM myoung34/github-runner-base:latest
LABEL maintainer="myoung34@my.apsu.edu"

ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
RUN mkdir -p /opt/hostedtoolcache

ARG GH_RUNNER_VERSION="2.278.0"
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN mkdir -p /actions-runner && chgrp -R 0 /actions-runner && chmod -R g=u /actions-runner
RUN mkdir -p /actions-runne2 && chgrp -R 0 /actions-runne2 && chmod -R g=u /actions-runne2
WORKDIR /actions-runner

COPY install_actions.sh /actions-runner

RUN chmod +x /actions-runner/install_actions.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
  && rm /actions-runner/install_actions.sh

COPY token.sh entrypoint.sh /
RUN chmod +x /token.sh /entrypoint.sh
RUN chgrp -R 0 /actions-runner && chmod -R g=u /actions-runner

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/actions-runner/bin/runsvc.sh"]
