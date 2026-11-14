#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

"$script_dir/kill.sh"
exec /usr/bin/qs -p "$script_dir"
