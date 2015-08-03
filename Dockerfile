FROM ruby:2.2.2
MAINTAINER James Dabbs <jamesdabbs@gmail.com>

RUN apt-get update -qq && apt-get install -qqy build-essential libpq-dev node

WORKDIR /tmp
ADD ./Gemfile /tmp/Gemfile
ADD ./Gemfile.lock /tmp/Gemfile.lock
RUN bundle install --quiet

EXPOSE 3000

ENV APP_HOME /strife
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
