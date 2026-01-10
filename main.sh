#!/bin/sh

# Global inputs:
# 
# $INPUT_VERSION
# $INPUT_PATH
# $INPUT_MANIFEST_URL
# $INPUT_IF_VERSION_IS_INVALID

manifest_response=$(curl -fsSL "$INPUT_MANIFEST_URL") || {
  echo "::error::Fetch Failed: Could not fetch manifest"
  exit 1
}

latest_release_version=$(echo "$manifest_response" | jq -r '.latest.release')
latest_snapshot_version=$(echo "$manifest_response" | jq -r '.latest.snapshot')
versions=$(echo "$manifest_response" | jq -c '[.versions[].id] | reverse')
release_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.type=="release") | .id] | reverse')
snapshot_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.type=="snapshot") | .id] | reverse')
april_fools_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.releaseTime | test("-04-01T")) | .id] | reverse')

selected_version=$INPUT_VERSION

if [ "$INPUT_VERSION" = "latest-release" ] || [ -z "$INPUT_VERSION" ]; then
  echo "Using latest release version: $latest_release_version"
  selected_version="$latest_release_version"
elif [ "$INPUT_VERSION" = "latest-snapshot" ]; then
  echo "Using latest snapshot version: $latest_snapshot_version"
  selected_version="$latest_snapshot_version"
else
  echo "Using specified version: $INPUT_VERSION"
fi

selected_version_object=$(echo "$manifest_response" | jq -c ".versions[] | select(.id==\"$selected_version\")")

if [ -z "$selected_version_object" ]; then
  case "$INPUT_IF_VERSION_IS_INVALID" in
    warn)
      echo "::warning::Invalid Version: Falling back to latest release ($latest_release_version)" >&2
      selected_version="$latest_release_version"
      selected_version_object=$(echo "$manifest_response" | jq -c ".versions[] | select(.id==\"$selected_version\")")
      ;;
    ignore)
      selected_version="$latest_release_version"
      selected_version_object=$(echo "$manifest_response" | jq -c ".versions[] | select(.id==\"$selected_version\")")
      ;;
    error)
      echo "::error::Invalid Version: Failing" >&2
      exit 1
      ;;
    *)
      echo "::error::Invalid Parameter: Invalid value for parameter 'if-version-is-invalid': $INPUT_IF_VERSION_IS_INVALID" >&2
      exit 1
      ;;
  esac
fi


package_url=$(echo "$selected_version_object" | jq -r '.url')

package_url_response=$(curl -fsSL "$package_url") || {
  echo "::error::Fetch Failed: Could not fetch package JSON"
  exit 1
}

server_download_url=$(echo "$package_url_response" | jq -r '.downloads.server.url')
server_jar_sha1=$(echo "$package_url_response" | jq -r '.downloads.server.sha1')
java_version=$(echo "$package_url_response" | jq -r '.javaVersion.majorVersion')

echo "Make temp download directory."
TEMP_DOWNLOAD_DIR=$(mktemp -d)

echo "Downloading server.jar from \"$server_download_url\"."
curl -fsSL -o $TEMP_DOWNLOAD_DIR/server.jar $server_download_url

echo "Verifying SHA1 hash of server.jar."
downloaded_sha1=$(sha1sum "$TEMP_DOWNLOAD_DIR/server.jar" | awk '{print $1}')

if [ "$downloaded_sha1" != "$server_jar_sha1" ]; then
  echo "::error::SHA1 hash does not match. Expected $server_jar_sha1, but got $downloaded_sha1."
  exit 1
else
  echo "SHA1 hash verification passed for server.jar."
fi

echo "Saved \"server.jar\" to \"$TEMP_DOWNLOAD_DIR/server.jar\"."

cd $TEMP_DOWNLOAD_DIR
echo "::group:: Generate reports from server.jar"
java -DbundlerMainClass=net.minecraft.data.Main -jar server.jar --reports
echo "::endgroup::"
cd -

cp -r "$TEMP_DOWNLOAD_DIR/generated/reports/." $INPUT_PATH

exit 0
