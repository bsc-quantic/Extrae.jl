#!/bin/bash

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export EXTRAE_ON=1
export EXTRAE_SKIP_AUTO_LIBRARY_INITIALIZE=1
export EXTRAE_CONFIG_FILE=$SRCDIR/extrae.xml

$*