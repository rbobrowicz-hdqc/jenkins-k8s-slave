
FROM gcr.io/cloud-solutions-images/jenkins-k8s-slave:latest
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
RUN gcloud components update
RUN apt-get update && apt-get install -y nuget mono-devel

