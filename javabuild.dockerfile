
FROM rbobrowiczhdqc/jenkins-k8s-slave-base:0.2.0

RUN apt-get update && apt-get install -y gradle default-jdk-headless
