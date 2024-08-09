#!/usr/bin/env bash

set -exo pipefail

rpm -q crypto-policies-scripts liboqs openssl oqsprovider
update-crypto-policies --show | grep TEST-PQ
openssl list -providers | grep 'name: OpenSSL OQS Provider'


#OpenSSL client and server tests

#run the server
openssl s_server -key root.key -cert root.crt &

# Function to run openssl s_client and grep for a pattern, then terminate the process
function run_s_client_and_grep {
    local host=$1
    local port=$2
    local pattern=$3
    # Run openssl s_client in the background, redirecting output to a temporary file
    tmpfile=$(mktemp)
    openssl s_client -connect ${host}:${port} -trace > "$tmpfile" 2>&1 &
    local CLIENT_PID=$!
    echo "Running s_client on ${host}:${port}, searching for pattern: '${pattern}'"
    # Monitor the output file for the pattern
    tail -f "$tmpfile" | while read -r line; do
        echo "$line" | grep "$pattern" &>/dev/null
        if [ $? -eq 0 ]; then
            echo "Pattern '${pattern}' found, terminating openssl s_client."
            kill $CLIENT_PID
            break
        fi
    done
    # Cleanup
    rm -f "$tmpfile"
}

# Default connection to X25519-KYBER768
openssl s_client -connect localhost:4433 -tls1_3 -trace | grep 'NamedGroup: X25519Kyber768Draft00 (25497)'

#Specify the group explicitly
openssl s_client  -groups p256_kyber768 -connect localhost:4433 -tls1_3 -trace | grep 'NamedGroup: SecP256r1Kyber768Draft00 (25498)'

#Tests with the external server
run_s_client_and_grep "test.openquantumsafe.org" "6042" "CONNECTED(00000003)"
run_s_client_and_grep "test.openquantumsafe.org" "6042" "NamedGroup: SecP256r1Kyber768Draft00 (25498)"
run_s_client_and_grep "test.openquantumsafe.org" "6044" "CONNECTED(00000003)"
run_s_client_and_grep "test.openquantumsafe.org" "6044" "NamedGroup: X25519Kyber768Draft00 (25497)"
