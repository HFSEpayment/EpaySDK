#!/bin/bash

# if we get an error bail
set -euxo pipefail

if [ -z "$1" ]; then
    echo Usage ${0}: version
    echo       for example:
    echo
    echo       ${0} 2.0.0000-beta0
    echo
    exit
fi

rm -rf build

if [ -z "$(git status --porcelain)" ]; then
    echo 'git status is clean'
else
    echo 'uncommitted changes, run `git status` for more information'
    exit
fi

if [ "$(git symbolic-ref --short HEAD)" != "master" ]; then
    echo 'will only deploy from master branch, bailing'
    exit
fi

if [ -z "$(git tag | grep ${1})" ]; then
    echo "git tag is clean"
else
    echo "the tag ${1} already exists, bailing"
    exit
fi

./scripts/update_version.sh ${1}
# ./scripts/build_xcframework.sh

# echo "pushing to cocoapods"
# python scripts/generate_podspec.py ${1} < EpaySDK.podspec.template > EpaySDK.podspec

# cp -r build/EpaySDK.xcframework .
git add .
git commit -m "Bump version to ${1}"
git push origin master
git tag ${1}
git push origin master --tags

# pod trunk push

echo "xcarchive deployed successfully"
