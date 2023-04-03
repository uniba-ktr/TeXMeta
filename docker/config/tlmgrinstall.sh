#!/bin/sh
set -eo pipefail

tlmgrinstall() {
  if [ -f "${PWD}/packages.txt" ]; then
    local packages="$(cat ${PWD}/packages.txt)"
    tlmgr install ${packages}
  fi
}

tlmgr update --self
tlmgrinstall

exec "$@"
