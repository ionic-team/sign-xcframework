set -eo pipefail

echo $DEV_ID_BASE64 | base64 --decode -o dev_id.p12

security create-keychain -p temp temp.keychain
security unlock -p temp temp.keychain
security import dev_id.p12 -k temp.keychain -P $DEV_ID_PASSWORD -T /usr/bin/codesign
security set-key-partition-list -S apple-tool:,apple: -s -k temp temp.keychain
security list-keychains -d user -s temp.keychain

codesign --timestamp -s "$DEV_ID_IDENTITY" $1

security delete-keychain temp.keychain
rm dev_id.p12
