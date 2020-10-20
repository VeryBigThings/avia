#!/bin/bash
script_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
args="$@"
echo "Running seeds"
$script_dir/nue eval "Snitch.Tasks.ReleaseTasks.seed()"
