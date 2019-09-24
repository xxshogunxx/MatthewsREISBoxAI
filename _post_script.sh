#!/bin/bash
cd "$WORKSPACE"
if [ -d "$ARCHIVE_DIR" ]; then
skip_artifact_upload=false
artifact_files_size=$(du -sm "$ARCHIVE_DIR" | tr -s [:space:] ' ' | cut -d ' ' -f 1)
artifact_files=$(find "$ARCHIVE_DIR" | wc -l)
if [ "$PIPELINE_DEBUG_SCRIPT" == "true" ]; then
echo _DEBUG:ARTIFACT_FILES_SIZE:$artifact_files_size
echo _DEBUG:ARTIFACT_FILES:$artifact_files
fi
if [ "$skip_artifact_upload" == "false" ]; then
if [ "$PIPELINE_DEBUG_SCRIPT" == "true" ]; then
current_time=$(echo $(($(date +%s%N)/1000000)))
fi
export_variable="-x _pipeline_script.sh -x _customer_script.sh -x _cust_script.sh -x _codestation_script.sh"
export_variable="$export_variable -x _toolchain.json -x _env"
if test -f '.csignore'; then
while read -r line;
do
if test -n "$line"; then
if echo "$line" | grep -q '^[^\\]*$'; then
if echo "$line" | grep -q '^[0-9A-Za-z\/\.\-\_\*]*$'; then
export_variable="$export_variable -x $line"
fi
fi
fi
done < .csignore
else
export_variable="$export_variable -x /.git*"
export_variable="$export_variable -x node_modules/*"
fi
export ZIP_EXCLUDES="$export_variable"
CURL_VERBOSITY="--silent"
if [ "$PIPELINE_DEBUG_SCRIPT" == "true" ]; then CURL_VERBOSITY="-vvvv"; fi
echo "Preparing the build artifacts..."
curl $CURL_VERBOSITY --fail --retry 3 --retry-delay 5 --connect-timeout 10 --output _codestation_script.sh https://pipeline-artifact-repository-service.us-south.devops.cloud.ibm.com:443/v3/up.sh
if [ $? == 0 ]; then
export PIPELINE_CODESTATION_URL='https://pipeline-artifact-repository-service.us-south.devops.cloud.ibm.com:443'
export PIPELINE_ARCHIVE_ID=''
export PIPELINE_ARCHIVE_TOKEN='8f0d0de305fc8bb5e4a93247fb9bfdd7.c000820dcea314dcdd741e3ffc13d3f253beec61862bcb321f4ab3398f05c989.a021bbb27ed54794b43bd7fd46af0da2a63e9064'
   sh _codestation_script.sh
else
   echo "An error occurred while attempting to download https://pipeline-artifact-repository-service.us-south.devops.cloud.ibm.com:443/v3/up.sh"
   exit 1
fi
if [ "$PIPELINE_DEBUG_SCRIPT" == "true" ]; then
end_time=$(echo $(($(date +%s%N)/1000000)))
let "total_time=$end_time - $current_time"
echo "_DEBUG:UPLOAD_ARTIFACTS:$total_time"
current_time=
end_time=
total_time=
fi
fi
else
echo "Archive directory $ARCHIVE_DIR does not exist. Please check the name."
exit 1
fi
cd /
rm -rf $TMPDIR/*

