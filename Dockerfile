FROM openjdk:8
RUN apt-get update
RUN apt-get install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g cordova

### Android SDKs
ENV ANDROID_SDK_URL https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
ENV ANDROID_BUILD_TOOLS_VERSION 23.0.3
ENV ANDROID_APIS android-23
ENV ANT_HOME /usr/share/ant
ENV MAVEN_HOME /usr/share/maven
ENV GRADLE_HOME /usr/share/gradle
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin
RUN dpkg --add-architecture i386 && \
 apt-get -qq update && \
 apt-get -qq install -y curl libstdc++6:i386 zlib1g:i386 --no-install-recommends && \
# Installs Android SDK
 curl -sL ${ANDROID_SDK_URL} | tar xz -C /opt && \
 echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION} && \
 chmod a+x -R $ANDROID_HOME && \
 chown -R root:root $ANDROID_HOME && \
# clean up
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
 apt-get purge -y --auto-remove curl && \
 apt-get autoremove -y && \
 apt-get clean

RUN (while sleep 3; do echo "y"; done) | android update sdk --no-ui --filter build-tools-24.0.0,android-24,extra-android-m2repository
