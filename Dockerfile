ARG DOCKER_REG=docker.io
FROM ${DOCKER_REG}/qnib/alplain-openjre8

VOLUME ["/opt/go-server/artifacts/serverBackups/"]
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
 && mv /opt/go-server-${GOCD_VER}/* /opt/go-server/ \
 && rm -rf /opt/go-server-${GOCD_VER} \
 && chmod +x /opt/go-server/*server.sh
WORKDIR /opt/go-server/plugins/external/
# The layers are independently pushed, if they are combined one change will alter the content of the combined layer
RUN export GORG=gocd-contrib \
 && export GREPO=script-executor-task \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=manojlds \
 && export GREPO=gocd-docker \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=ashwanthkumar \
 && export GREPO=gocd-slack-build-notifier \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=gocd-contrib \
 && export GREPO=gocd-build-status-notifier \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*github-pr-status.*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*github-pr-status.*\.jar" --limit 1)
RUN export GORG=gocd-contrib \
 && export GREPO=deb-repo-poller \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=ashwanthkumar \
 && export GREPO=gocd-build-github-pull-requests \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*github-pr-poller.*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*github-pr-poller.*\.jar" |head -n1) \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*git-fb-poller.*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*git-fb-poller.*\.jar" |head -n1)
RUN export GORG=Vincit \
 && export GREPO=gocd-slack-task \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=varchev \
 && export GREPO=go-generic-artifactory-poller \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=ind9 \
 && export GREPO=gocd-s3-artifacts \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3material-assembly.*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3material-assembly.*\.jar" --limit 1) \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3fetch-assembly.*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3fetch-assembly.*\.jar" --limit 1) \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3publish-assembly.*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3publish-assembly.*\.jar" --limit 1)
RUN export GORG=jmnarloch \
 && export GREPO=gocd-health-check-plugin \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=gocd-contrib \
 && export GREPO=gocd-oauth-login \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=gocd-contrib \
 && export GREPO=gocd-oauth-login \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=gocd-contrib \
 && export GREPO=docker-swarm-elastic-agents \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)

RUN export GORG=tomzo \
 && export GREPO=gocd-yaml-config-plugin \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=tomzo \
 && export GREPO=gocd-json-config-plugin \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)
RUN export GORG=qnib \
 && export GREPO=gocd-docker-material-poller \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" --limit 1)

#RUN curl -sL https://github.com/tomzo/gocd-yaml-config-plugin/releases/download/${YAML_CONFIG}/yaml-config-plugin-${YAML_CONFIG}.jar > yaml-config-plugin.jar
#ARG JSON_CONFIG=0.2.0
#ARG JSON_CONFIG_PATCH=0
#RUN curl -sL https://github.com/tomzo/gocd-json-config-plugin/releases/download/${JSON_CONFIG}.${JSON_CONFIG_PATCH}/json-config-plugin-${JSON_CONFIG}.jar > json-config-plugin.jar
#ARG DOCKER_MATERIAL=0.0.1
#RUN curl -sL https://github.com/qnib/gocd-docker-material-poller/releases/download/${DOCKER_MATERIAL}/go-plugin-api-current.jar > go-plugin-api-current.jar
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
