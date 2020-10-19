#!/bin/sh
echo "Running migrations"
script_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
args="$@"
/opt/app/bin/nue eval "Snitch.Tasks.ReleaseTasks.migrate()"
