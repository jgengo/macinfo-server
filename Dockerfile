FROM ruby:2.7.1-alpine

RUN apk update && apk add build-base nodejs postgresql-dev tzdata bash

ARG RAILS_ENV
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN mkdir /project
WORKDIR /project

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

COPY . .
    
RUN whenever -w

CMD ["./startup.sh"]