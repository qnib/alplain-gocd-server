FROM qnib/alplain-jre8

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
ARG DOCKER_TASK_VER=0.1.27
ARG SCRIPT_EXEC_VER=0.3
ARG SLACK_NOTIFY_VER=1.4.0-RC11
ARG GITHUB_PR_STATUS_VER=1.2
ARG DEB_REPO_POLLER_VER=1.2
ARG SLACK_TASK_VER=1.3
ARG GEN_ARTIFACT_POLLER=0.2.0
ARG S3_POLLER=1.0.0
ARG S3_ARTIFACTS_POLLER=2.0.2
ARG GITHUB_PR_BUILD=1.3.0-RC2
WORKDIR /opt/go-server/plugins/external/
# The layers are independently pushed, if they are combined one change will alter the content of the combined layer
RUN curl -sL https://github.com/manojlds/gocd-docker/releases/download/${DOCKER_TASK_VER}/docker-task-assembly-${DOCKER_TASK_VER}.jar > docker-task-assembly-${DOCKER_TASK_VER}.jar
RUN curl -sL https://github.com/gocd-contrib/script-executor-task/releases/download/${SCRIPT_EXEC_VER}/script-executor-${SCRIPT_EXEC_VER}.jar > script-executor-${SCRIPT_EXEC_VER}.jar
RUN curl -sL https://github.com/ashwanthkumar/gocd-slack-build-notifier/releases/download/v${SLACK_NOTIFY_VER}/gocd-slack-notifier-${SLACK_NOTIFY_VER}.jar > gocd-slack-notifier-${SLACK_NOTIFY_VER}.jar
RUN curl -sL https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/${GITHUB_PR_STATUS_VER}/github-pr-status-${GITHUB_PR_STATUS_VER}.jar > github-pr-status-${GITHUB_PR_STATUS_VER}.jar
RUN curl -sL https://github.com/gocd-contrib/deb-repo-poller/releases/download/${DEB_REPO_POLLER_VER}/deb-repo-poller-${DEB_REPO_POLLER_VER}.jar > deb-repo-poller-${DEB_REPO_POLLER_VER}.jar
RUN curl -sL https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v${GITHUB_PR_BUILD}/github-pr-poller-${GITHUB_PR_BUILD}.jar > github-pr-poller-${GITHUB_PR_BUILD}.jar
RUN curl -sL https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v${GITHUB_PR_BUILD}/git-fb-poller-${GITHUB_PR_BUILD}.jar > git-fb-poller-${GITHUB_PR_BUILD}.jar
#RUN curl -sL https://github.com/Haufe-Lexware/gocd-plugins/releases/download/v1.0.0-beta/gocd-docker-pipeline-plugin-1.0.0.jar > gocd-docker-pipeline-plugin-1.0.0.jar
RUN curl -sL https://github.com/Vincit/gocd-slack-task/releases/download/v${SLACK_TASK_VER}/gocd-slack-task-${SLACK_TASK_VER}.jar > gocd-slack-task-${SLACK_TASK_VER}.jar
RUN curl -sL https://github.com/varchev/go-generic-artifactory-poller/releases/download/${GEN_ARTIFACT_POLLER}/go-generic-artifactory-poller.jar >go-generic-artifactory-poller.jar
RUN curl -sL https://github.com/schibsted/gocd-s3-poller/releases/download/${S3_POLLER}/gocd-s3-poller-${S3_POLLER}.jar > gocd-s3-poller-${S3_POLLER}.jar
#RUN curl -sL https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3material-assembly-${S3_ARTIFACTS_POLLER}.jar > s3material-assembly-${S3_ARTIFACTS_POLLER}.jar
#RUN curl -sL https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3fetch-assembly-${S3_ARTIFACTS_POLLER}.jar > s3fetch-assembly-${S3_ARTIFACTS_POLLER}.jar 
#RUN curl -sL https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3publish-assembly-${S3_ARTIFACTS_POLLER}.jar > s3publish-assembly-${S3_ARTIFACTS_POLLER}.jar 
WORKDIR /root/
COPY opt/qnib/gocd/server/bin/start.sh \
    opt/qnib/gocd/server/bin/healthcheck.sh \
    /opt/qnib/gocd/server/bin/
ADD opt/qnib/entry/10-gocd-restore.sh /opt/qnib/entry/
#ADD etc/consul-templates/gocd/server/cruise-config.xml.ctmpl \
#    /etc/consul-templates/gocd/server/
CMD ["/opt/qnib/gocd/server/bin/start.sh"]
