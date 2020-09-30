#!/bin/bash
BASEDIR=$(dirname $0)
export LD_LIBRARY_PATH=${BASEDIR}
cd ${BASEDIR}
rm -rf node_modules/
cp -f /altv-persistend/node_modules/ node_modules/
./altv-server --config "config/server.cfg" --logfile "logs/server.log"
