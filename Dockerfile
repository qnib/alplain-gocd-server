ARG FROM_IMG_REGISTRY=docker.io
ARG FROM_IMG_TAG="2020-03-19.1"
ARG FROM_IMG_HASH=

FROM ${FROM_IMG_REGISTRY}/qnib/alplain-openjre8:${FROM_IMG_TAG}${FROM_IMG_HASH}

VOLUME ["/opt/go-server/artifacts/serverBackups/"]
ENV GOCD_AGENT_AUTOENABLE_KEY=qnibFTW \
    GOCD_SERVER_CLEAN_WORKSPACE=false
ARG GOCD_URL=https://download.gocd.io/binaries
ARG GOCD_VER=20.2.0
ARG GOCD_SUBVER=11344
ARG CT_VER=0.20.0
LABEL gocd.version=${GOCD_VER}-${GOCD_SUBVER}
RUN apk --no-cache add curl git openssl xmlstarlet libarchive-tools
RUN export SRC_URL=$(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo service-scripts --regex ".*\.tar" |head -n1) \
 && echo "# service-scripts: ${SRC_URL}" \
 && curl -Ls ${SRC_URL} |tar xf - -C /opt/
RUN mkdir -p /opt/go-server \
 && echo "go-server: https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-server-${GOCD_VER}-${GOCD_SUBVER}.zip" \
 && curl -Ls --url ${GOCD_URL}/${GOCD_VER}-${GOCD_SUBVER}/generic/go-server-${GOCD_VER}-${GOCD_SUBVER}.zip |bsdtar xfz - -C /opt/go-server --strip-components=1
WORKDIR /opt/go-server/plugins/external/
# The layers are independently pushed, if they are combined one change will alter the content of the combined layer
RUN export GORG=gocd-contrib \
 && export GREPO=script-executor-task \
 && export SRC_URL=$(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex '.*\.jar' |head -n1) \
 && echo "# ${GORG}/${GREPO}: ${SRC_URL}" \
 && wget -q ${SRC_URL}
RUN export GORG=manojlds \
 && export GREPO=gocd-docker \
 && export SRC_URL=$(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1) \
 && echo "# ${GORG}/${GREPO}: ${SRC_URL}" \
 && wget -q ${SRC_URL}
RUN export GORG=ashwanthkumar \
 && export GREPO=gocd-slack-build-notifier \
 && export SRC_URL=$(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1) \
 && echo "# ${GORG}/${GREPO}: ${SRC_URL}" \
 && wget -q ${SRC_URL}
RUN export GORG=gocd-contrib \
 && export GREPO=gocd-build-status-notifier \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*github-pr-status.*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*github-pr-status.*\.jar" |head -n1)
RUN export GORG=gocd-contrib \
 && export GREPO=deb-repo-poller \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=ashwanthkumar \
 && export GREPO=gocd-build-github-pull-requests \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*github-pr-poller.*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*github-pr-poller.*\.jar" |head -n1) \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*git-fb-poller.*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*git-fb-poller.*\.jar" |head -n1)
RUN export GORG=Vincit \
 && export GREPO=gocd-slack-task \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=varchev \
 && export GREPO=go-generic-artifactory-poller \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=ind9 \
 && export GREPO=gocd-s3-artifacts \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3material-assembly.*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3material-assembly.*\.jar" |head -n1) \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3fetch-assembly.*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3fetch-assembly.*\.jar" |head -n1) \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3publish-assembly.*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*s3publish-assembly.*\.jar" |head -n1)
RUN export GORG=jmnarloch \
 && export GREPO=gocd-health-check-plugin \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=gocd-contrib \
 && export GREPO=gocd-oauth-login \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=gocd-contrib \
 && export GREPO=docker-swarm-elastic-agents \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=tomzo \
 && export GREPO=gocd-yaml-config-plugin \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=tomzo \
 && export GREPO=gocd-json-config-plugin \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=gocd \
 && export GREPO=docker-registry-artifact-plugin \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN export GORG=cma-arnold \
 && export GREPO=gocd-docker-exec-plugin \
 && echo "# ${GORG}/${GREPO}: $(/usr/local/bin/go-github rLatestUrl --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)" \
 && wget -q $(/usr/local/bin/go-github rLatestUrl --ghorg gocd-contrib --ghorg ${GORG} --ghrepo ${GREPO} --regex ".*\.jar" |head -n1)
RUN apk --no-cache add unzip \
 && curl -Lso /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CT_VER}/consul-template_${CT_VER}_linux_amd64.zip \
 && cd /usr/local/bin \
 && unzip /tmp/consul-template.zip \
 && apk --no-cache del unzip \
 && rm -f /tmp/consul-template.zip
WORKDIR /root/
ADD opt/qnib/entry/10-gocd-restore.sh \
    opt/qnib/entry/20-gocd-render-cruise-config.sh \
    /opt/qnib/entry/
ADD opt/qnib/gocd/server/etc/cruise-config.xml /opt/qnib/gocd/server/etc/
ENV ENTRYPOINTS_DIR=/opt/qnib/entry/ \
    GOCD_BACKUP_RESTORE_ENABLED=false
RUN apk add moreutils --update-cache --repository http://dl-3.alpinelinux.org/alpine/v3.11.3/community/
CMD ["/opt/go-server/server.sh"]
