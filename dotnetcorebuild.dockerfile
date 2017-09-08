
FROM rbobrowiczhdqc/jenkins-k8s-slave-base:0.2.0

ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

RUN apt-get update && apt-get install -y nuget
RUN apt-get update && apt-get install -y libunwind8 libicu-dev liblttng-ust-dev # for dotnet core

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 2.0.0
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz
ENV DOTNET_SDK_DOWNLOAD_SHA E457F3A5685382F7F24851A2E76EDBE75B575948C8A7F43220F159BA29C329A5008BBE7220C18DFB31EAF0398FC72177B1948B65E19B34ED0D907EFB459CF4B0

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && echo "$DOTNET_SDK_DOWNLOAD_SHA dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /opt/dotnet \
    && tar -zxf dotnet.tar.gz -C /opt/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /opt/dotnet/dotnet /usr/local/bin/dotnet

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    && cd .. \
    && rm -rf warmup \
&& rm -rf /tmp/NuGetScratch
