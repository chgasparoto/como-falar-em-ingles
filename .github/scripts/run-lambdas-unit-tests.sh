#!/bin/sh
set -e

cd "${GITHUB_WORKSPACE}/backend/lambdas"

for dir in $(find $(pwd) -type d -mindepth 1 -maxdepth 1)
do
    cd ${dir}
    npm ci
    npm run lint
    npm run test
done
