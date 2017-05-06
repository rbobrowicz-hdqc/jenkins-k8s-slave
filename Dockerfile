
FROM ubuntu:xenial

RUN apt-get update -y
RUN apt-get install -y default-jdk
RUN apt-get install -y jq
RUN apt-get install -y mono-devel ca-certificates-mono
RUN apt-get install -y curl
RUN apt-get install -y python
RUN apt-get install -y git

ENV HOME /home/jenkins
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH

RUN curl --create-dirs https://dist.nuget.org/win-x86-commandline/v3.5.0/nuget.exe -o /opt/nuget/nuget.exe
RUN chmod -R 755 /opt/nuget

RUN curl https://sdk.cloud.google.com | bash && mv /home/jenkins/google-cloud-sdk /opt
RUN gcloud components install kubectl

RUN groupadd -g 10000 jenkins
RUN useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins

ARG VERSION=3.7

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar

RUN chmod 755 /usr/share/jenkins
RUN chmod 644 /usr/share/jenkins/slave.jar
RUN chown -R jenkins:jenkins /home/jenkins

RUN curl -L -o /tmp/certdata.txt https://hg.mozilla.org/mozilla-central/raw-file/tip/security/nss/lib/ckfw/builtins/certdata.txt
RUN mozroots --machine --import --sync --quiet --file /tmp/certdata.txt

USER jenkins
RUN mkdir /home/jenkins/.jenkins
VOLUME /home/jenkins/.jenkins
WORKDIR /home/jenkins

COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]

