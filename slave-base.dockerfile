
FROM debian:stretch

RUN apt-get update && apt-get install -y default-jdk libapparmor1 libseccomp2 # for jenkins
RUN apt-get update && apt-get install -y python git gettext curl dos2unix unzip jq wget # utils

# set environment variables
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH

# install google cloud sdk
RUN curl https://sdk.cloud.google.com | bash && mv /root/google-cloud-sdk /opt
RUN gcloud components install kubectl

# vault
RUN wget https://releases.hashicorp.com/vault/0.7.3/vault_0.7.3_linux_amd64.zip
RUN unzip vault_0.7.3_linux_amd64.zip
RUN mkdir -p /opt/vault
RUN mv vault /opt/vault
RUN ln -s /opt/vault/vault /usr/local/bin
RUN rm vault_0.7.3_linux_amd64.zip

# Jenkins slave setup

ARG VERSION=3.10

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar

RUN chmod 755 /usr/share/jenkins
RUN chmod 644 /usr/share/jenkins/slave.jar

RUN mkdir /root/.jenkins
VOLUME /root/.jenkins
WORKDIR /root

COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
