#!/usr/bin/env bash
set -e
if "${VERBOSE}"; then
  set -x
fi

if [ -z "$TARGET_BITRISE_FILE_SLUG" ]; then
  TARGET_BITRISE_FILE_SLUG=$(
  curl -s -X GET \
      -H "Authorization: ${BITRISE_API_TOKEN}" \
      -H "accept: application/json" \
      "https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/generic-project-files" \
  | jq -r ".data[] | select(.user_env_key == \"${TARGET_BITRISE_FILE_KEY}\") | .slug"
  )
fi

target_bitrise_file_url=$(
  curl -s -X GET \
    -H "Authorization: ${BITRISE_API_TOKEN}" \
    -H "accept: application/json" \
    "https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/generic-project-files/${TARGET_BITRISE_FILE_SLUG}" \
  | jq -r ".data.download_url"
)

curl -s -o "${OUTPUT_FILE_NAME}" "${target_bitrise_file_url}"

envman add --key "OUTPUT_FILE_NAME" --value "${OUTPUT_FILE_NAME}"
echo "This output was OUTPUT_FILE_NAME: $OUTPUT_FILE_NAME - `file -b $OUTPUT_FILE_NAME`"
