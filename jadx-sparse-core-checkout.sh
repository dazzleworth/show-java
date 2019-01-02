#!/bin/sh
# Copyright (c) 2018 Brendan Chong Email: opr_nexus@yahoo.com
# Script to update CFR decompiler
# Tested to work with Git Shell in Windows: 
# https://github-windows.s3.amazonaws.com/GitHubSetup.exe 
# No permission required in normal Windows environment


jadx_core_rep=https://github.com/skylot/jadx.git
tmp_path=tmp
src_path=($tmp_path "jadx-core" "src" "main" "java" "jadx")
dest_path=("app" "src" "main" "java")

mkdir $tmp_path
cd "$tmp_path$ds"
git init
git remote add -f origin $jadx_core_rep
git pull origin master

src_path=$(printf '%s/' "${src_path[@]%/}" )
dest_path=$(printf '%s/' "${dest_path[@]%/}" )

cd ..

rm -r "${dest_path}jadx"

mv -v $src_path $dest_path

rm -rf "$tmp_path"