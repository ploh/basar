FROM ruby:2.3.1

##### Initialize
RUN ln -sf bash /bin/sh

##### Install system libraries
RUN apt-get -qy update
ARG BUILD_DEB_PKGS='gcc g++ libc6-dev make libsqlite3-dev'
ARG RUNTIME_DEB_PKGS='git sqlite3'
RUN apt-get -qy install --no-install-recommends $BUILD_DEB_PKGS $RUNTIME_DEB_PKGS

##### Installl python packages
WORKDIR /tmp
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

##### Cleanup
RUN apt-get purge -y --auto-remove $BUILD_DEB_PKGS
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

##### Install our application
WORKDIR /src
COPY . .
