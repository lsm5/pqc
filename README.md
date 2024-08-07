1. rpms.in.yaml mentions the packages for which we need to check updates in Fedora.
2. Renovate creates PRs to update rpms.lock.yaml whenever there are package updates in the listed dnf repos.
3. After the PR is merged, quay trigger will build a new image at quay.io/lsm5/pqc .
