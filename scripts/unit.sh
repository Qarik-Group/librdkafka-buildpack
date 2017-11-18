#!/usr/bin/env bash
set -euo pipefail

buildpack=librdkafka

export ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd $ROOT
source .envrc

if [ ! -f $ROOT/.bin/ginkgo ]; then
  (cd $ROOT/src/$buildpack/vendor/github.com/onsi/ginkgo/ginkgo/ && go install)
fi

cd $ROOT/src/$buildpack/
ginkgo -r -skipPackage=integration
