#!/bin/sh -l

export PATH=$PATH:/go/bin

if [ "${GITHUB_EVENT_NAME}" != "pull_request" ] ;
then
  echo "Event ${GITHUB_EVENT_NAME} is not supported"
  exit 128
fi

HEAD_SRC=$(jq '.pull_request.head.repo.full_name' < ${GITHUB_EVENT_PATH})
HEAD_REF=$(jq '.pull_request.head.ref' < ${GITHUB_EVENT_PATH})
HEAD_SHA=$(jq '.pull_request.head.sha' < ${GITHUB_EVENT_PATH})

BASE_SRC=$(jq '.pull_request.head.repo.full_name' < ${GITHUB_EVENT_PATH})
BASE_REF=$(jq '.pull_request.head.ref' < ${GITHUB_EVENT_PATH})
BASE_SHA=$(jq '.pull_request.head.sha' < ${GITHUB_EVENT_PATH})

NUMBER=$(jq '.number' < ${GITHUB_EVENT_PATH})
TITLE=$(jq '.pull_request.title' < ${GITHUB_EVENT_PATH})

assay \
  -api latest.assay.it \
  -secret $1 \
  -head ${HEAD_SRC}/${HEAD_REF}/${HEAD_SHA} \
  -base ${BASE_SRC}/${BASE_REF}/${BASE_SHA} \
  -number ${NUMBER} \
  -title ${TITLE}
