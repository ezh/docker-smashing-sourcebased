FROM ruby:alpine
WORKDIR /dashboard/project
ENV GEM_HOME /dashboard/.bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN apk update && apk add make gcc g++ less
RUN cd /dashboard \
    && gem install bundler \
    && gem install smashing \
    && gem install twitter \
    && gem install pry \
    && gem install pry-stack_explorer \
    && gem install pry-theme \
    && gem install pry-state \
    && gem install pry-byebug \
    && gem install awesome_print \
    && gem install tzinfo-data


FROM ruby:alpine
ENV GEM_HOME /dashboard/.bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
COPY --from=0 /dashboard /dashboard
WORKDIR /dashboard/project
RUN apk update && apk add libstdc++ nodejs tzdata
RUN cd /dashboard \
    && smashing new project \
    && echo bundle > /dashboard/project/.run-once

COPY smashing /

EXPOSE 8080

VOLUME ["/dashboard/project"]

ENTRYPOINT ["/smashing"]
CMD ["smashing", "start", "-p", "8080"]
