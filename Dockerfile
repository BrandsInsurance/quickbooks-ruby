FROM ruby:2.5.3

ENV APP_PATH="quickbooks-ruby"
WORKDIR /$APP_PATH

COPY . /$APP_PATH

ENV LOCK_PATH="Locks"
RUN mkdir -p /$LOCK_PATH

ENV BUNDLER_VERSION=1.17.3
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle install
RUN mv Gemfile.lock /$LOCK_PATH/

RUN cp /$APP_PATH/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD /bin/bash
