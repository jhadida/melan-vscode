#!/usr/bin/env bash

[ $# -lt 3 ] && { echo "Usage: $0 <Version> -m <Message>"; exit 1; }

Version=$1
shift

PAT=$(openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 10000 -salt -d -in ".token.enc")

vsce publish -p "$PAT" "$@" $Version
git tag v$Version "$@"
git push --tags

