# syntax=docker/dockerfile:experimental
#########################################################
## BUILD STAGE - Development image with necessary deps ##
#########################################################

FROM verybigthings/elixir:1.10.4 AS build

ARG WORKDIR=/opt/app
ARG APP_USER=user

ENV WORKDIR=$WORKDIR
ENV APP_USER=$APP_USER
ENV CACHE_DIR=/opt/cache
ENV MIX_HOME=$CACHE_DIR/mix
ENV HEX_HOME=$CACHE_DIR/hex
ENV BUILD_PATH=$CACHE_DIR/_build
ENV REBAR_CACHE_DIR=$CACHE_DIR/rebar

RUN apt-get update && apt-get install -y \
  bash \
  git \
  inotify-tools \
  less \
  make \
  xfonts-base \
  xfonts-75dpi \
  vim

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
  dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb

WORKDIR $WORKDIR

ENV PHOENIX_VERSION 1.5.5

RUN mix local.hex --force && \
  mix local.rebar --force
RUN mix archive.install hex phx_new $PHOENIX_VERSION --force

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com > ~/.ssh/known_hosts

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash", "-c", "while true; do sleep 10; done;"]

######################################################################################
## PRE-RELEASE STAGE - compiles code and bundles the application to Erlang release  ##
######################################################################################

FROM build AS pre-release

ARG APP_NAME
ARG RELEASE_LEVEL

ENV APP_NAME=${APP_NAME}
ENV RELEASE_LEVEL=${RELEASE_LEVEL}

COPY . .

RUN --mount=type=ssh MIX_ENV=prod mix do deps.get, deps.compile, compile

RUN cd apps/admin_app/assets && \
  yarn install && \
  yarn deploy && \
  cd - && \
  mix phx.digest

RUN MIX_ENV=prod mix do release

############################################
## RELEASE STAGE - production application ##
############################################

FROM debian:10-slim AS release

ARG APP_NAME
ARG APP_USER=user
ARG WORKDIR=/opt/app

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV WORKDIR=$WORKDIR
ENV APP_USER=$APP_USER

RUN apt-get update && apt-get install -y \
  bash \
  git \
  fontconfig \
  libpq-dev \
  libjson-c-dev \
  libjpeg62-turbo \
  libxrender1 \
  xfonts-base \
  xfonts-75dpi \
  curl \
  wget

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
  dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb

ENV APP_NAME=${APP_NAME}
# Copy over the build artifact from the previous step and create a non root user
RUN useradd --create-home ${APP_USER}
WORKDIR $WORKDIR

COPY --from=pre-release /opt/cache/_build/prod/rel/${APP_NAME} .

RUN chown -R ${APP_USER}: ${WORKDIR}
USER ${APP_USER}

CMD trap 'exit' INT; ${WORKDIR}/bin/${APP_NAME} start


############################################################################
## RELEASE PHASE - run migrations on Heroku before production application ##
############################################################################
FROM release AS release-phase

CMD trap 'exit' INT; \
  /opt/app/bin/migrate_all.sh
