FROM qnib/alplain-openjre8

ENV GOCD_AGENT_AUTOENABLE_KEY=qnibFTW \
    GOCD_SERVER_CLEAN_WORKSPACE=false
ARG GOCD_URL=https://download.gocd.io/binaries
RUN apk --no-cache add curl git openssl \
 && curl -Ls https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux > /usr/local/bin/go-github \
 && chmod +x /usr/local/bin/go-github \
 && echo "# consul-content: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo service-scripts --regex ".*\.tar" --limit 1)" \
 && curl -Ls $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo service-scripts --regex ".*\.tar" --limit 1) |tar xf - -C /opt/ \
 && source /opt/service-scripts/gocd/common/version \
 && echo "https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-server-${GOCD_VER}-${GOCD_SUBVER}.zip" \
 && curl -Ls --url ${GOCD_URL}/${GOCD_VER}-${GOCD_SUBVER}/generic/go-server-${GOCD_VER}-${GOCD_SUBVER}.zip > /tmp/go-server.zip \
 && source /opt/service-scripts/gocd/common/version \
 && mkdir -p /opt/ \
 && unzip -q -d /opt/ /tmp/go-server.zip \
 && rm -f /tmp/go-server.zip \
 && mv /opt/go-server-${GOCD_VER} /opt/go-server \
 && chmod +x /opt/go-server/*server.sh
WORKDIR /opt/go-server/plugins/external/
# The layers are independently pushed, if they are combined one change will alter the content of the combined layer
ARG SCRIPT_EXEC=0.3
ARG SCRIPT_EXEC_PATCH=0
RUN curl -sL https://github.com/gocd-contrib/script-executor-task/releases/download/${SCRIPT_EXEC}/script-executor-${SCRIPT_EXEC}.${SCRIPT_EXEC_PATCH}.jar > script-executor-${SCRIPT_EXEC}.${SCRIPT_EXEC_PATCH}.jar
ARG DOCKER_TASK_VER=0.1.27
RUN curl -sL https://github.com/manojlds/gocd-docker/releases/download/${DOCKER_TASK_VER}/docker-task-assembly-${DOCKER_TASK_VER}.jar > docker-task-assembly-${DOCKER_TASK_VER}.jar
ARG SLACK_NOTIFY_VER=1.4.0-RC11
RUN curl -sL https://github.com/ashwanthkumar/gocd-slack-build-notifier/releases/download/v${SLACK_NOTIFY_VER}/gocd-slack-notifier-${SLACK_NOTIFY_VER}.jar > gocd-slack-notifier-${SLACK_NOTIFY_VER}.jar
ARG GITHUB_PR_STATUS_VER=1.2
RUN curl -sL https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/${GITHUB_PR_STATUS_VER}/github-pr-status-${GITHUB_PR_STATUS_VER}.jar > github-pr-status-${GITHUB_PR_STATUS_VER}.jar
ARG DEB_REPO_POLLER_VER=1.2
RUN curl -sL https://github.com/gocd-contrib/deb-repo-poller/releases/download/${DEB_REPO_POLLER_VER}/deb-repo-poller-${DEB_REPO_POLLER_VER}.jar > deb-repo-poller-${DEB_REPO_POLLER_VER}.jar
ARG GITHUB_PR_BUILD=1.3.3
RUN curl -sL https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v${GITHUB_PR_BUILD}/github-pr-poller-${GITHUB_PR_BUILD}.jar > github-pr-poller-${GITHUB_PR_BUILD}.jar
RUN curl -sL https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v${GITHUB_PR_BUILD}/git-fb-poller-${GITHUB_PR_BUILD}.jar > git-fb-poller-${GITHUB_PR_BUILD}.jar
ARG SLACK_TASK_VER=1.3.1
RUN curl -sL https://github.com/Vincit/gocd-slack-task/releases/download/v${SLACK_TASK_VER}/gocd-slack-task-${SLACK_TASK_VER}.jar > gocd-slack-task-${SLACK_TASK_VER}.jar
ARG GEN_ARTIFACT_POLLER=0.2.0
RUN curl -sL https://github.com/varchev/go-generic-artifactory-poller/releases/download/${GEN_ARTIFACT_POLLER}/go-generic-artifactory-poller.jar >go-generic-artifactory-poller.jar
ARG S3_ARTIFACTS_POLLER=2.0.2
RUN curl -sL https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3material-assembly-${S3_ARTIFACTS_POLLER}.jar > s3material-assembly-${S3_ARTIFACTS_POLLER}.jar
RUN curl -sL https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3fetch-assembly-${S3_ARTIFACTS_POLLER}.jar > s3fetch-assembly-${S3_ARTIFACTS_POLLER}.jar 
RUN curl -sL https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3publish-assembly-${S3_ARTIFACTS_POLLER}.jar > s3publish-assembly-${S3_ARTIFACTS_POLLER}.jar 
ARG HEALTH_CHECK=1.0.2
RUN curl -sL https://github.com/jmnarloch/gocd-health-check-plugin/releases/download/${HEALTH_CHECK}/gocd-health-check-plugin-${HEALTH_CHECK}.jar > gocd-health-check-plugin-${HEALTH_CHECK}.jar
ARG OAUTH_LOGIN=2.3
RUN curl -sL https://github.com/gocd-contrib/gocd-oauth-login/releases/download/v${OAUTH_LOGIN}/github-oauth-login-${OAUTH_LOGIN}.jar > github-oauth-login-${OAUTH_LOGIN}.jar
ARG GUEST_AUTH=0.2
RUN curl -sL https://github.com/gocd-contrib/gocd_auth_plugin_guest_user/releases/download/v${GUEST_AUTH}/gocd_auth_plugin_guest_user-1.0.jar > gocd_auth_plugin_guest_user-1.0.jar
ARG EA_SWARM=1.1.2
RUN curl -sL https://github.com/gocd-contrib/docker-swarm-elastic-agents/releases/download/v${EA_SWARM}/docker-swarm-elastic-agents-${EA_SWARM}.jar > docker-swarm-elastic-agents-${EA_SWARM}.jar
ARG YAML_CONFIG=0.4.0
RUN curl -sL https://github.com/tomzo/gocd-yaml-config-plugin/releases/download/${YAML_CONFIG}/yaml-config-plugin-${YAML_CONFIG}.jar > yaml-config-plugin.jar
ARG JSON_CONFIG=0.2.0
ARG JSON_CONFIG_PATCH=0
RUN curl -sL https://github.com/tomzo/gocd-json-config-plugin/releases/download/${JSON_CONFIG}.${JSON_CONFIG_PATCH}/json-config-plugin-${JSON_CONFIG}.jar > json-config-plugin.jar
ARG DOCKER_MATERIAL=0.0.1
RUN curl -sL https://github.com/qnib/gocd-docker-material-poller/releases/download/${DOCKER_MATERIAL}/go-plugin-api-current.jar > go-plugin-api-current.jar
ARG CT_VER=0.18.5
RUN apk --no-cache add unzip \
 && curl -Lso /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CT_VER}/consul-template_${CT_VER}_linux_amd64.zip \
 && cd /usr/local/bin \
 && unzip /tmp/consul-template.zip \
 && apk --no-cache del unzip \
 && rm -f /tmp/consul-template.zip
WORKDIR /root/
COPY opt/qnib/gocd/server/bin/start.sh \
    opt/qnib/gocd/server/bin/healthcheck.sh \
    /opt/qnib/gocd/server/bin/
ADD opt/qnib/entry/10-gocd-restore.sh \
    opt/qnib/entry/20-gocd-render-cruise-config.sh \
    /opt/qnib/entry/
ADD opt/qnib/gocd/server/etc/cruise-config.xml /opt/qnib/gocd/server/etc/
ENV ENTRYPOINTS_DIR=/opt/qnib/entry/
CMD ["/opt/qnib/gocd/server/bin/start.sh"]
