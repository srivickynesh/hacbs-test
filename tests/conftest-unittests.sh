#!/usr/bin/env bats

load bats-support-clone
load test_helper/bats-support/load
load test_helper/redhatcop-bats-library/load

# create temporary file
tmpfile=$(mktemp)

if [ -z "$1" ]
then
  IMAGE=$("quay.io/cvpops/test-index:v4.10")
else
  IMAGE=$1
fi

echo "Using image : "$IMAGE 

skopeo inspect docker://${IMAGE} > ${tmpfile}

@test "policies/image/deprecated-images" {
  cmd="conftest test --policy policies/image/policy/deprecated-image.rego ${tmpfile} --output=json"
  run ${cmd}
}
