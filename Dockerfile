FROM ubuntu:18.04
MAINTAINER Terasology Community <terasology@gmail.com>

# Default settings, can override as needed - TODO: Consider a Docker image that'll download game zip at runtime (for PRs and such) to cut down on images needed
                                           # For instance tags could be latest-release, latest-dev-build, no-game-zip ?
ENV SERVER_ZIP="http://jenkins.terasology.org/job/DistroOmegaRelease/lastSuccessfulBuild/artifact/distros/omega/build/distributions/TerasologyOmega.zip" \
    SERVER_PORT=25777 \
    SERVER_NAME="NotUsedYet1" \
    MEMORY_LIMIT="4096m" \
    OVERRIDE_CFG_PATH="override.cfg" \
    SERVER_PASSWORD="NotUsedYet2" \
    ADMIN_PASSWORD="NotUsedYet2"

RUN apt-get update && apt-get install -y openjdk-11-jre wget unzip
RUN mkdir /terasology \
    && wget -P /terasology ${SERVER_ZIP} \
    && unzip /terasology/TerasologyOmega.zip -d /terasology \
    && rm -f /terasology/TerasologyOmega.zip
ENTRYPOINT cd /terasology && java -Xms256m -Xmx${MEMORY_LIMIT} -jar /terasology/libs/Terasology.jar -headless -homedir=/terasology/server -overrideDefaultConfig=${OVERRIDE_CFG_PATH}
VOLUME /terasology/server
EXPOSE ${SERVER_PORT}
