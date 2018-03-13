FROM ruby:alpine

WORKDIR /dashboard/project

COPY smashing /

ENV GEM_HOME /dashboard/.bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN apk update && apk add make gcc g++ nodejs less

RUN cd /dashboard \
    && gem install bundler \
    && gem install smashing \
    && smashing new project \
    && echo bundle > /dashboard/project/.run-once

ONBUILD RUN bundle

EXPOSE 8080

VOLUME ["/dashboard/project"]

ENTRYPOINT ["/smashing"]
CMD ["start", "-p", "8080"]
