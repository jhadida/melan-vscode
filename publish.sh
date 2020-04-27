#!/usr/bin/env bash

[ $# -lt 3 ] && { echo "Usage: $0 <Version> -m <Message>" }

Version=$1
shift

PAT=$(openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 10000 -salt -d -in ".token.enc")

git tag v$Version "$@"
vsce publish -p "$PAT" "$@" $Version
