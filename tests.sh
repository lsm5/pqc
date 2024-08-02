#!/usr/bin/env bash

set -exo pipefail

rpm -q crypto-policies-scripts liboqs openssl oqsprovider
update-crypto-policies --show | grep TEST-PQ
openssl list -providers | grep 'name: OpenSSL OQS Provider'


#OpenSSL client and server tests

#run the server
openssl s_server -key root.key -cert root.crt &

# Default connection to X25519-KYBER768
openssl s_client -connect localhost:4433 -tls1_3 -trace | grep 'NamedGroup: X25519Kyber768Draft00 (25497)'

#Specify the group explicitly
openssl s_client  -groups p256_kyber768 -connect localhost:4433 -tls1_3 -trace | grep 'NamedGroup: SecP256r1Kyber768Draft00 (25498)'

#Tests with the external server

openssl s_client -connect test.openquantumsafe.org:6042 | grep 'CONNECTED(00000003)'

openssl s_client -connect test.openquantumsafe.org:6042 -trace | grep 'NamedGroup: SecP256r1Kyber768Draft00 (25498)'

openssl s_client -connect test.openquantumsafe.org:6044 | grep 'CONNECTED(00000003)'

openssl s_client -connect test.openquantumsafe.org:6044 -trace | grep 'NamedGroup: X25519Kyber768Draft00 (25497)'
