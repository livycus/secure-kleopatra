#!/bin/bash

echo -e "\033[1;35m[TITLE] Secure Kleopatra"
echo -e "[VERSION] 1.0"
echo -e "[AUTHOR] livycus"
echo -e "[URL] https://github.com/livycus/secure-kleopatra"
echo -e "[SHORT] Run Kleopatra in RAM"
echo -e "[DESCRIPTION] Running script in the same directory as a private key from e.g. hidden VeraCrypt volume loads keys and Kleopatra into RAM bypassing OS to leave minimal trace on the system\033[0m"

echo -e "\033[1;32m[+] Building directory...\033[0m"
export GNUPGHOME=/dev/shm/gpg-secure
echo "$GNUPGHOME"
rm -rf "$GNUPGHOME"
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

echo -e "\033[1;32m[+] Starting secure GPG session in RAM at $GNUPGHOME..."
echo -e "[-] Initializing GPG agent socket...\033[0m"
eval $(gpg-agent --homedir "$GNUPGHOME" --daemon)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" # Script assumes it's running from directory where key resides, if untrue modifications are needed for script to work.

echo -e "\033[1;32m[+] Importing keys...\033[0m"
find "$SCRIPT_DIR" -maxdepth 1 -type f \( -iname "*.asc" -o -iname "*.gpg" -o -iname "*.key" -o -iname "*.cer" -o -iname "*.crt" -o -iname "*.pem" -o -iname "*.p12" -o -iname "*.pfx" \) | while read -r keyfile; do
	echo "Importing: $keyfile"
	gpg --homedir "$GNUPGHOME" --import "$keyfile"
done

echo -e "\033[1;32m[+] Launching Kleopatra...\033[0m"
env | grep GNUPG
env GNUPGHOME="$GNUPGHOME" kleopatra &

sleep 1

kleo_pid=""
for i in {1..10}; do
	kleo_pid=$(pgrep -n -u "$USER" kleopatra)
	if [ -n "$kleo_pid" ]; then
		echo -e "\033[1;32m[+] Kleopatra PID detected: $kleo_pid.\033[0m"
		break
	fi
	sleep 1
done

if [ -z "$kleo_pid" ]; then
	echo -e "\033[1;31m[ERROR] Could not find Kleopatra PID. Exiting...\033[0m"
	exit 1
fi

echo -e "\033[1;33m[INFO] Kleopatra by default minimizes to tray and PID stays active, to end the session navigate to file -> quit\033[0m"
echo -e "\033[1;36m[+] Waiting for Kleopatra to close (PID $kleo_pid)...\033[0m"
while kill -0 "$kleo_pid" 2>/dev/null; do
	sleep 1
done

echo -e "\033[1;32m[+] Kleopatra closed. Proceeding with cleanup...\033[0m"

gpgconf --homedir "$GNUPGHOME" --kill gpg-agent
rm -rf "$GNUPGHOME"

echo -e "\033[1;32m[+] Cleaned up. Secure session ended.\033[0m"
echo -e "\033[1;33m[INFO] After exiting it is recommended to reboot the system (sudo reboot).\033[0m"
read -rp "[DONE] Press ENTER to exit..."
