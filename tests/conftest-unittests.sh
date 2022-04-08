#!/usr/bin/env bats

# create temporary file
tmpfile=$(mktemp)

if [ -z "$1" ]
then
  IMAGE=("quay.io/cvpops/test-index:v4.10")
else
  IMAGE=$1
fi

# run "podman run --rm quay.io/skopeo/stable inspect docker://${IMAGE}" >> ${tmpfile}
run "docker inspect ${IMAGE}" >> ${tmpfile}

cat "$tmpfile"

if [[ -s $tmpfile ]] ; then
echo "$FILE has json image data."
else
echo "$FILE is empty."
fi ;

@test "policies/image/deprecated-images" {
  run "conftest test --policy policies/image/policy/deprecated-image.rego ${tmpfile} --output=json"
  [ "$status" -eq 0 ]
}
rm "$tmpfile"
