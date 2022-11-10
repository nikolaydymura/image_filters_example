APPLICATION_ID=nd.imagevideo.filters
DEVELOPMENT_TEAM_ID=8MJN994E42
DEVELOPMENT_TEAM_NAME='Mykola Dymura'
PROVISIONING_PROFILE_SPECIFIER=imagevideo-filters

{
  printf '<?xml version="1.0" encoding="UTF-8"?>'
  printf '\n<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'
  printf '\n<plist version="1.0">'
  printf '\n<dict>'
  printf '\n\t<key>method</key>'
  printf '\n\t<string>ad-hoc</string>'
  printf '\n\t<key>teamID</key>'
  printf '\n\t<string>%s</string>' "${DEVELOPMENT_TEAM_ID}"
  printf '\n\t<key>compileBitcode</key>'
  printf '\n\t<false/>'
  printf '\n\t<key>uploadBitcode</key>'
  printf '\n\t<false/>'
  printf '\n\t<key>uploadSymbols</key>'
  printf '\n\t<true/>'
  printf '\n\t<key>signingStyle</key>'
  printf '\n\t<string>manual</string>'
  printf '\n\t<key>signingCertificate</key>'
  printf '\n\t<string>Apple Distribution: %s (%s)</string>' "${DEVELOPMENT_TEAM_NAME}" "${DEVELOPMENT_TEAM_ID}"
  printf '\n\t<key>provisioningProfiles</key>'
  printf '\n\t<dict>'
  printf '\n\t\t<key>%s</key>' "${APPLICATION_ID}"
  printf '\n\t\t<string>%s</string>' "${PROVISIONING_PROFILE_SPECIFIER}"
  printf '\n\t</dict>'
  printf '\n</dict>'
  printf '\n</plist>'
} >>ios/app-ios-export.plist