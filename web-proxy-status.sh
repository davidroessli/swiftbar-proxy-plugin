#!/bin/bash
# <bitbar.title>We-Proxy-status</bitbar.title>
# <bitbar.version>1.0</bitbar.version>
# <bitbar.author>David Roessli</bitbar.author>
# <bitbar.author.github>davidroessli</bitbar.author.github>
# <bitbar.desc>Gets the network interface proxy status and lets you toggle it on/off</bitbar.desc>
# <bitbar.version>1.0</bitbar.version>

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

# Inspired from https://dmorgan.info/posts/mac-network-proxy-terminal/

# Use `networksetup -listallnetworkservices` to find the name of your interface
# Customise these values with your own
interface="Ethernet"
proxyIP="123.456.78.90"
proxyPort="1234"

proxyState=$(scutil --proxy | awk '\
  /HTTPEnable/ { enabled = $3; } \
  /HTTPProxy/ { server = $3; } \
  /HTTPPort/ { port = $3; } \
  END { if (enabled == "1") { print "1"; }}')

case "$proxyState" in
"1")
  echo "✋"
  ;;
*)
  echo " "
  ;;
esac

echo "----"
if [[ $proxyState -eq "1" ]]
  then
    echo $(scutil --proxy | awk '\
    /HTTPEnable/ { enabled = $3; } \
    /HTTPProxy/ { server = $3; } \
    /HTTPPort/ { port = $3; } \
    END { print "Proxy http://" server ":" port; }');
    echo "Disable web proxy | bash='/usr/sbin/networksetup' param1=-setwebproxystate param2=$interface param3=off terminal=false refresh=true";
  else
    echo "Web proxy disabled";
    echo "Enable web proxy | bash='/usr/sbin/networksetup' param1=-setwebproxy param2=$interface param3=$proxyIP param4=$proxyPort param5=off terminal=false refresh=true";
fi
