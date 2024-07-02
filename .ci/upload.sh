#!/bin/bash
#
#this script is derived, simplified and adapted for Appveyor from https://github.com/probonopd/uploadtool
#only the file to upload is specified on the command line
#there are no other command line or environment options to this script, all information comes from Appveyor
#

set +x # Do not leak information

# Exit immediately if there are no files or one of the files given as arguments is not there
if [ $# -eq 0 ]; then
    echo "No artifacts to use for release, giving up."
    exit 0
fi


# Upload each file
for FILE in "$@" ; do
    FULLNAME="${FILE}"
    BASENAME="$(basename "${FILE}")"
    curl -H "Content-Type: application/octet-stream" \
         --data-binary "@$FULLNAME" \
         "https://uguu.jur.as/upload.php"
    echo ""
done

$shatool "$@"

if [ "$APPVEYOR_REPO_COMMIT" != "$tag_sha" ] ; then
    echo "Publish the release..."

    release_infos=$(curl -H "Authorization: token ${GITHUB_TOKEN}" \
        --data '{"draft": false}' "$release_url")

    echo "$release_infos"
fi
