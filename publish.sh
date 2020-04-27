#!/usr/bin/env bash

PAT=$(openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 10000 -salt -d -in ".token.enc")

vsce publish -p "$PAT" "$@"
