FROM ruby:2.5.0

#Cache bundle install
WORKDIR /tmp
ADD . /totoro
ADD ./test/totoro_test/Gemfile Gemfile
ADD ./test/totoro_test/Gemfile.lock Gemfile.lock
RUN bundle install

RUN mkdir /app
WORKDIR /app
ADD ./test/totoro_test /app

CMD ["rails", "c"]