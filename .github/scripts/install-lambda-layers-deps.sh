#!/bin/sh
set -e # exit on error

cd "${GITHUB_WORKSPACE}/lambda-layers"

for dir in $(find $(pwd) -name 'nodejs')
do
    cd ${dir}
    echo "Installing dependencies for ${dir} layer"
    npm install --production
done
