FROM ruby:alpine

RUN apk update && apk add build-base nodejs postgresql-dev tzdata

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN mkdir /project
WORKDIR /project

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

COPY . .

CMD ["rails", "server", "-b=0.0.0.0"]
