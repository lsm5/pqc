#!/usr/bin/env bash

set -exo pipefail

rpm -q crypto-policies-scripts liboqs openssl oqsprovider
update-crypto-policies --show | grep TEST-PQ
openssl list -providers | grep 'name: OpenSSL OQS Provider'
