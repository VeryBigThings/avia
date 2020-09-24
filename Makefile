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
		reseed-db \

		kube-build \
		kube-deploy \
		kube-shell \
		kube-logs \
		kube-migration-logs \
		kube-psql \
		kube-new-shell \

		devstack \
		devstack-build \
		devstack-clean \
		devstack-shell \
		devstack-run

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
	mix cmd --app snitch_core mix elasticsearch.build products --cluster Snitch.Tools.ElasticsearchCluster && \
	mix cmd --app snitch_core mix ecto.load.demo

reseed-db: reset-db

# ------------
# --- KUBE ---
# ------------

## Builds the prod/release Docker image
kube-build: require-APP_NAME require-APP_TAG
	@docker build . --ssh default --target release --build-arg MIX_ENV=prod --build-arg APP_NAME --tag ${APP_TAG}

## Deploys the local image to the cluster
kube-deploy: require-RELEASE_LEVEL
	@kubectl apply -k config/k8s/overlays/${RELEASE_LEVEL}

## Connects to running app
kube-shell: require-RELEASE_LEVEL
	@kubectl exec --namespace ${RELEASE_LEVEL} --stdin --tty deployment/${DEPLOYMENT_NAME} -- bash

## Shows app logs
kube-logs: require-RELEASE_LEVEL
	@kubectl logs --namespace ${RELEASE_LEVEL} --follow deployment/${DEPLOYMENT_NAME}

kube-migration-logs: require-RELEASE_LEVEL
	@kubectl logs --namespace ${RELEASE_LEVEL} --follow deployment/${DEPLOYMENT_NAME} -c migration-runner

kube-psql: require-RELEASE_LEVEL
	@kubectl run --namespace ${RELEASE_LEVEL} psql-${APP_NAME} --generator=run-pod/v1 --rm --stdin --tty --image verybigthings/postgresql-client:11.7 -- sh || kubectl --namespace ${RELEASE_LEVEL} exec -it psql-${APP_NAME} sh

kube-new-shell: require-RELEASE_LEVEL
	@kubectl run --namespace ${RELEASE_LEVEL} aws-cli--${APP_NAME} --generator=run-pod/v1 --rm --stdin --tty --image verybigthings/kube-shell:5 --serviceaccount=${DEPLOYMENT_NAME}-app-role-- sh

# -----------------------
# --- DOCKER DEVSTACK ---
# -----------------------

## Builds the development Docker image
devstack-build:
	@docker build --ssh default .\
		--target build \
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