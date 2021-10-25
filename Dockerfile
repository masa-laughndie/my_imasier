FROM ruby:2.5.9

ARG BUNDLER_VERSION="2.2.29"

RUN gem install bundler -v ${BUNDLER_VERSION}

WORKDIR "/var/www/my_imasier"

COPY ./Gemfile ./Gemfile.lock ./
RUN bundle install

EXPOSE 8888
CMD rm -f tmp/pids/server.pid \
  && bundle exec rails server -b 0.0.0.0 -p 8888
