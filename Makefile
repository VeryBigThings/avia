.PHONY: \
		dev \
		test \
		compile \
		check-compile \
		check-release \
		check-migrations \
		check-ci \
		reset-db \
		seed-db \
		demo-db \

		devstack \
		devstack-build \
		devstack-clean \
		devstack-shell \
		devstack-run \

DEFAULT_GOAL: help

export LOCAL_USER_ID ?= $(shell id -u $$USER)
export DOCKER_BUILDKIT=1

# -------------------
# --- DEFINITIONS ---
# -------------------

require-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "ERROR: Environment variable not set: \"$*\""; \
		exit 1; \
	fi

# -----------------
# --- MIX TASKS ---
# -----------------

dev:
	mix cmd --app snitch_core mix ecto.setup && iex -S mix phx.server

test:
	mix test

compile:
	@mix do deps.get, compile --warnings-as-errors

check-compile: compile
	@MIX_ENV=test mix compile --warnings-as-errors
	@mix format --check-formatted
	@mix credo list

check-migrations:
	@MIX_ENV=test mix ecto.reset
	@MIX_ENV=test mix ecto.rollback.all
	@MIX_ENV=test mix ecto.migrate

check-release:
	@MIX_ENV=test mix release --overwrite
	@DATABASE_URL="postgres://postgres:postgres:@db/snitch_dev" _build/test/rel/nue/bin/migrate_all.sh

check-ci: check-compile test check-migrations check-release

reset-db:
	mix cmd --app snitch_core mix ecto.reset

demo-db: reset-db
	mix cmd --app snitch_core mix ecto.seed && \
		mix cmd --app snitch_core mix elasticsearch.build products --cluster Snitch.Tools.ElasticsearchCluster && \
		mix cmd --app snitch_core mix ecto.load.demo

# -----------------------
# --- DOCKER DEVSTACK ---
# -----------------------

## Builds the development Docker image
devstack-build:
	@docker build \
		--target build \
		--ssh default .\
		--build-arg MIX_ENV=dev \
		--build-arg APP_NAME=nue \
		--tag nue:latest

## Stops all development containers
devstack-clean:
	@docker-compose down -v

## Starts all development containers in the foreground
devstack: devstack-build
	@docker-compose up

## Spawns an interactive Bash shell in development web container
devstack-shell:
	@docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -u ${LOCAL_USER_ID} -it $$(docker-compose ps -q web) /bin/bash -c "reset -w && /bin/bash"

## Starts the development server inside docker
devstack-run: devstack-build
	@docker-compose up -d &&\
		docker-compose exec web mix deps.get && \
		docker-compose exec web mix ecto.setup && \
		docker-compose exec web iex -S mix phx.server

prodstack-build:
	@docker build \
		--target release \
		--ssh default .\
		--build-arg MIX_ENV=prod \
		--build-arg APP_NAME=nue \
		--tag nue:release

# ------------
# --- HELP ---
# ------------

## Shows the help menu
help:
	@echo "Please use \`make <target>' where <target> is one of\n\n"
	@awk '/^[a-zA-Z\-\_\/0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
