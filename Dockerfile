# Dockerfile

# Builder Image
FROM ruby:2.7.2-alpine AS builder

ENV RAILS_ENV=production \
    NODE_ENV=production \
    APP_HOME=/opt/app \
    SECRET_KEY_BASE=1234567890

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
    BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    yarn \
    git

COPY Gemfile* $APP_HOME/
RUN bundle config set without development:test:assets && \
    bundle install

COPY package.json yarn.lock $APP_HOME/
RUN yarn install --production=true

COPY . $APP_HOME

RUN bundle exec rails assets:precompile

RUN rm -rf $APP_HOME/node_modules && \
    rm -rf $APP_HOME/app/javascript/packs && \
    rm -rf $APP_HOME/log/* && \
    rm -rf $APP_HOME/spec && \
    rm -rf $APP_HOME/storage/* && \
    rm -rf $APP_HOME/tmp/* && \
    rm -rf $APP_HOME/vendor/bundle/ruby/2.7.0/cache/ && \
    find $APP_HOME/vendor/bundle/ruby/2.7.0/gems/ -name "*.c" -delete && \
    find $APP_HOME/vendor/bundle/ruby/2.7.0/gems/ -name "*.o" -delete


# Main Image
FROM ruby:2.7.2-alpine

ENV RAILS_ENV=production \
    NODE_ENV=production \
    APP_HOME=/opt/app

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle \
    BUNDLE_APP_CONFIG=$APP_HOME/vendor/bundle

RUN apk add --no-cache \
    imagemagick \
    postgresql-client \
    tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN addgroup -S docker && \
    adduser -S -G docker docker

USER docker

COPY --chown=docker:docker --from=builder $APP_HOME $APP_HOME

EXPOSE 5000
CMD ["./scripts/container-startup.sh"]