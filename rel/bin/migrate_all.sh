#!/bin/sh


set +e

# while true; do
#   nodetool ping
#   EXIT_CODE=$?

#   if [ $EXIT_CODE -eq 0 ]; then
#     echo "Application is up!"
#     break
#   fi
# done

set =e

echo "Running migrations"
script_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
args="$@"
$script_dir/nue eval "Snitch.Tasks.ReleaseTasks.migrate()"
echo "Migrations run successfully"
