# Allow arbitrary loads only for `Debug Local` configuration

/usr/libexec/PlistBuddy -c "Delete :NSAppTransportSecurity" "${INFOPLIST_FILE}"
if [ "${CONFIGURATION}" = "Debug Localhost" ]; then
  /usr/libexec/PlistBuddy -c "Add:NSAppTransportSecurity:NSAllowsArbitraryLoads bool YES" "${INFOPLIST_FILE}"
else
  /usr/libexec/PlistBuddy -c "Add:NSAppTransportSecurity:NSAllowsArbitraryLoads bool NO" "${INFOPLIST_FILE}"
fi
