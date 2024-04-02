set -eo pipefail

json=$(echo $1 | base64 --decode | jq -r)
cert=$(echo $json | jq -r '.cert')
password=$(echo $json | jq -r '.password')
identity=$(echo $json | jq -r '.id')

echo $cert | base64 --decode -o dev_id.p12

security create-keychain -p temp temp.keychain
security unlock -p temp temp.keychain
security import dev_id.p12 -k temp.keychain -P $password -T /usr/bin/codesign
security set-key-partition-list -S apple-tool:,apple: -s -k temp temp.keychain
security list-keychains -d user -s temp.keychain

codesign --timestamp -s "$identity" $2

security delete-keychain temp.keychain
rm dev_id.p12
