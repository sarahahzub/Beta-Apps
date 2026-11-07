#!/bin/sh
# install-manager.sh [IPK URL]: install the webOS ATL manager on a rooted TV from SSH or telnet and, if the TV
# refuses the package, print the reason from the TV's own log (Homebrew Channel only shows "-5: ipk verified failed").
#   curl -fsSL https://raw.githubusercontent.com/sarahahzub/Beta-Apps/main/tools/install-manager.sh | sh
URL=${1:-https://github.com/sarahahzub/Beta-Apps/releases/download/webosatl32-beta-v0.2.8/org.webosatl.manager_0.2.8_all.ipk}
T=/tmp/webosatl-manager.ipk
echo "== TV: $(cat /etc/prefs/properties/machineName 2>/dev/null) $(grep -o 'webos_release[^,]*' /var/run/nyx/os_info.json 2>/dev/null) $(uname -m)"
echo "== free: RAM $(awk '/MemAvailable/{print int($2/1024)}' /proc/meminfo) MB, apps $(df -m /media/developer 2>/dev/null | awk 'NR==2{print $4}') MB"
if [ -f "$URL" ]; then
	T=$URL
else
	rm -f "$T"
	if ! { curl -fsSL -o "$T" "$URL" 2>/dev/null || wget -q -O "$T" "$URL"; }; then
		echo "!! download failed: $URL"
		echo "   (old TVs: GitHub's certificate may be unknown to the TV; copy the IPK to /tmp with scp and run: sh install-manager.sh /tmp/<file>.ipk)"
		exit 1
	fi
fi
echo "== package: $(wc -c < "$T") bytes, sha256 $(sha256sum "$T" | cut -c1-16)..."
head -c 8 "$T" | grep -q '!<arch>' || { echo "!! not an IPK (got HTML or an error page?)"; exit 1; }
M=/var/log/messages
L0=$(wc -l < $M 2>/dev/null || echo 0)
R=$(luna-send -w 180000 -i luna://com.webos.appInstallService/dev/install \
	"{\"id\":\"org.webosatl.manager\",\"ipkUrl\":\"$T\",\"subscribe\":true}" </dev/null 2>&1 | \
	while read -r l; do echo "$l" >&2; case "$l" in *'"installed"'*) echo OK; break;; *'"failed"'*|*errorCode*|*'"returnValue":false'*) echo FAIL; break;; esac; done)
if [ "$R" = OK ]; then echo "== installed. Open 'webOS ATL' from the home screen."; exit 0; fi
echo "!! the TV refused the package. Its log says:"
tail -n +$((L0 + 1)) $M 2>/dev/null | grep -i -e pkgverif -e appinstall -e opkg -e ipk | tail -15
echo "   Please send this whole output with your report (TV model and webOS version are at the top)."
exit 1
