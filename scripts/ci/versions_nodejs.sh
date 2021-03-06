#!/usr/bin/env bash
# for details about how it works see https://github.com/elastic/apm-integration-testing#continuous-integration

set -ex

if [ $# -lt 2 ]; then
  echo "Argument missing, node js agent version spec and stack version must be provided"
  exit 2
fi

version_type=${1%;*}
version=${1#*;}
stack_args=${2//;/ }

# use latest release by default
node_js_pkg="elastic-apm-node@${version}"
if [ "${version_type}" == github ]; then
    node_js_pkg="elastic/apm-agent-nodejs#${version}"
fi

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.
. ${srcdir}/common.sh

DEFAULT_COMPOSE_ARGS="${stack_args} --no-apm-server-dashboards --no-apm-server-self-instrument --no-kibana --with-agent-nodejs-express --nodejs-agent-package='${node_js_pkg}' --force-build --build-parallel"
export COMPOSE_ARGS=${COMPOSE_ARGS:-${DEFAULT_COMPOSE_ARGS}}
runTests env-agent-nodejs docker-test-agent-nodejs-version
