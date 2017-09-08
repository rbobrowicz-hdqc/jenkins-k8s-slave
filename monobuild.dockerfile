
FROM rbobrowiczhdqc/jenkins-k8s-slave-base:0.1.0

ENV MONO_VERSION 5.0.0.100

RUN rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list

RUN apt-get update -y
RUN apt-get install -y binutils mono-devel ca-certificates-mono nuget referenceassemblies-pcl
