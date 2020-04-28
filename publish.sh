#!/usr/bin/env bash

[ $# -lt 3 ] && { echo "Usage: $0 <Version> -m <Message>"; exit 1; }

Version=$1
shift

PAT=$(openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 10000 -salt -d -in ".token.enc")

echo "$Version" >| version.txt
git commit -a "$@"

vsce publish --baseImagesUrl "https://github.com/jhadida/melan-vscode/raw/master" --pat "$PAT" "$@" $Version || { echo "Failed to publish"; exit 1; }
git push --tags
