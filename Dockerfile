FROM verybigthings/elixir:1.10.4

ENV APP_NAME nue
ENV APP_USER user
ENV MIX_ENV prod
ENV PHOENIX_VERSION 1.5.4
ENV WORKDIR /opt/app
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV CACHE_DIR=/opt/cache
ENV BUILD_PATH=$CACHE_DIR/_build
ENV HEX_HOME=$CACHE_DIR/hex
ENV MIX_HOME=$CACHE_DIR/mix
ENV REBAR_CACHE_DIR=$CACHE_DIR/rebar


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

RUN mix local.hex --force && mix local.rebar --force
RUN mix archive.install hex phx_new $PHOENIX_VERSION --force

WORKDIR $WORKDIR

COPY . .

RUN MIX_ENV=prod mix do deps.get, deps.compile, compile

RUN cd apps/admin_app/assets && \
  yarn install && \
  yarn deploy && \
  cd - && \
  mix phx.digest

RUN MIX_ENV=prod mix do release

RUN rm -r *
COPY ${BUILD_PATH}/prod/rel/${APP_NAME} .
RUN chmod +x ./bin/*

RUN chown -R ${APP_USER}: ${WORKDIR}
USER ${APP_USER}

CMD trap 'exit' INT; ${WORKDIR}/bin/${APP_NAME} start

