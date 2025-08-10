#!/bin/sh

#  ci_post_clone.sh
#  Hanbae
#
#  Created by Yunki on 8/9/25.
#  

ENV_FILE_PATH="${CI_PRIMARY_REPOSITORY_PATH}/env.xcconfig"

echo "enf.xcconfig 파일을 생성합니다."

echo "MIXPANEL_PROD_TOKEN = ${MIXPANEL_PROD_TOKEN}" > "${ENV_FILE_PATH}"
echo "MIXPANEL_DEV_TOKEN = ${MIXPANEL_DEV_TOKEN}" >> "${ENV_FILE_PATH}"

echo "enf.xcconfig 파일을 생성했습니다."
