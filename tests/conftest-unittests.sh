#!/usr/bin/env bats

# create temporary file
if [ -z "$1" ]
then
  IMAGE=("quay.io/cvpops/test-index:v4.10")
else
  IMAGE=$1
fi
if [ -z "$2" ]
then
  jsonfile="image_metadata.json"
else
  jsonfile=$2
  echo "Filename: $jsonfile"
fi


# run "podman run --rm quay.io/skopeo/stable inspect docker://${IMAGE}" >> ${tmpfile}
# run "docker inspect ${IMAGE}" >> ${tmpfile}



cat "$jsonfile"

if [[ -s $jsonfile ]] ; then
echo "$FILE has json image data."
else
echo "$FILE is empty."
fi ;

@test "policies/image/deprecated-images" {
  run "conftest test --policy policies/image/policy/deprecated-image.rego ${jsonfile} --output=json"
  [ "$status" -eq 0 ]
}
