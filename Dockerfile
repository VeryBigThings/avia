# syntax=docker/dockerfile:experimental
#########################################################
## BUILD STAGE - Development image with necessary deps ##
#########################################################

FROM verybigthings/elixir:1.10.4 AS build

ARG APP_USER=user
ARG WORKDIR=/opt/app

ENV APP_USER=$APP_USER
ENV CACHE_DIR=/opt/cache
ENV BUILD_PATH=$CACHE_DIR/_build
ENV HEX_HOME=$CACHE_DIR/hex
ENV MIX_HOME=$CACHE_DIR/mix
ENV PHOENIX_VERSION 1.5.4
ENV REBAR_CACHE_DIR=$CACHE_DIR/rebar
ENV WORKDIR=$WORKDIR

RUN apt-get update && apt-get install -y \
  curl \
  gcc \
  git \
  libfontconfig1 \
  libxext6 \
  libxrender1 \
  locales \
  gnupg \
  make \
  postgresql-client \
  postgresql-contrib \
  vim \
  wget

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN tar vxf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN cp wkhtmltox/bin/wk* /usr/local/bin/

WORKDIR $WORKDIR

RUN mix local.hex --force && mix local.rebar --force
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

ENV APP_NAME=${APP_NAME}

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

ENV APP_NAME=${APP_NAME}
ENV APP_USER=$APP_USER
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV WORKDIR=$WORKDIR

RUN apt-get update && apt-get install -y \
  gcc \
  git \
  libfontconfig1 \
  libxext6 \
  libxrender1 \
  locales \
  gnupg \
  make \
  wget \
  xz-utils

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN tar vxf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN cp wkhtmltox/bin/wk* /usr/local/bin/

RUN useradd --create-home ${APP_USER}
WORKDIR $WORKDIR

COPY --from=pre-release /opt/cache/_build/prod/rel/${APP_NAME} .

RUN chmod +x ./bin/*

RUN chown -R ${APP_USER}: ${WORKDIR}
USER ${APP_USER}

CMD trap 'exit' INT; ${WORKDIR}/bin/${APP_NAME} start

############################################################################
###### RELEASE PHASE - run migrations before production application ########
############################################################################

FROM release AS release-phase

CMD trap 'exit' INT; /opt/app/bin/migrate_all.sh
