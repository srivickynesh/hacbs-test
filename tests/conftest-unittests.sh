#!/usr/bin/env bats

# create temporary file
tmpfile=$(mktemp)

if [ -z "$1" ]
then
  IMAGE=("quay.io/cvpops/test-index:v4.10")
else
  IMAGE=$1
fi

run "podman run --rm quay.io/skopeo/stable inspect docker://${IMAGE} > ${tmpfile}"

@test "policies/image/deprecated-images" {
  cmd="conftest test --policy policies/image/policy/deprecated-image.rego ${tmpfile} --output=json"
  run ${cmd}
  [ "$status" -eq 0 ]
}
