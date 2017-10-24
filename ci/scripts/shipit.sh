#!/bin/bash

#
# ci/scripts/shipit.sh
#
# Script for generating updating VERSION, preparing packaged buildpacks,
# and managing release notes for a software pipeline
#

: ${RELEASE_NAME:?required}
: ${REPO_ROOT:?required}
: ${VERSION_FROM:?required}
: ${RELEASE_OUT:?required}
: ${REPO_OUT:?required}
: ${NOTIFICATION_OUT:?required}
: ${REPO_BRANCH:?required}
: ${REPO_URL:?required}
: ${GIT_EMAIL:?required}
: ${GIT_NAME:?required}

if [[ ! -f ${VERSION_FROM} ]]; then
  echo >&2 "Version file (${VERSION_FROM}) not found.  Did you misconfigure Concourse?"
  exit 2
fi
VERSION=$(cat ${VERSION_FROM})
if [[ -z ${VERSION} ]]; then
  echo >&2 "Version file (${VERSION_FROM}) was empty.  Did you misconfigure Concourse?"
  exit 2
fi

if [[ ! -f ${REPO_ROOT}/ci/release_notes.md ]]; then
  echo >&2 "ci/release_notes.md not found.  Did you forget to write them?"
  exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

###############################################################

git clone $REPO_ROOT $REPO_OUT

go get github.com/cloudfoundry/libbuildpack/packager/buildpack-packager

cd $REPO_OUT
source .envrc

rm -f *.zip
buildpack-packager -summary
buildpack-packager -version ${VERSION}
buildpack-packager -version ${VERSION} -cached
cd -

mkdir -p ${RELEASE_OUT}/artifacts
echo "v${VERSION}"                    > ${RELEASE_OUT}/tag
echo "${RELEASE_NAME} v${VERSION}"    > ${RELEASE_OUT}/name
mv ${REPO_OUT}/ci/release_notes.md      ${RELEASE_OUT}/notes.md
mv ${REPO_OUT}/*.zip                    ${RELEASE_OUT}/artifacts

cat > ${NOTIFICATION_OUT}/message <<EOF
New ${RELEASE_NAME} v${VERSION} released. <${REPO_URL}/releases/tag/v${VERSION}|Release notes>.
EOF

# GIT!
if [[ -z $(git config --global user.email) ]]; then
  git config --global user.email "${GIT_EMAIL}"
fi
if [[ -z $(git config --global user.name) ]]; then
  git config --global user.name "${GIT_NAME}"
fi

(cd ${REPO_OUT}
 echo "${VERSION}" > VERSION
 git merge --no-edit ${REPO_BRANCH}
 git add -A
 git status
 git commit -m "release v${VERSION}")
