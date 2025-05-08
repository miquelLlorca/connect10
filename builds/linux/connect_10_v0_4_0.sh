#!/bin/sh
echo -ne '\033c\033]0;connect10\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/connect_10_v0_4_0.x86_64" "$@"
