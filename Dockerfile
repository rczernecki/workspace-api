FROM ruby:2.7.4

RUN apt-get update -yqq \
    && apt-get install -yqq \
    postgresql-client \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists \

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD bin/rails s -b '0.0.0.0'