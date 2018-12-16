## Script to upgrade JADX core for ShowJava, an Android decompiler for android

## Problem

`show-java` is a great app to decompile other Android apps on the fly. However, its built based on the JaDX core. JaDX is the desktop version and its actively maintained.

## Solution

I have written a script to update the core so that `show-java` can be built with the latest core and function properly when decompiling apps.


## jadx-sparse-core-checkout.sh

	#!/bin/sh

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


## Script Copyright

	Copyright (C) 2018 dazzleworth
	
	Email: opr_nexus@yahoo.com
	Twitter: twitter.com/dazzleworth
	Github: github.com/dazzleworth
	

## Open Source License

Unless explicitly stated otherwise all files in this repository are licensed under the [GNU Affero General Public License v3.0](https://www.gnu.org/licenses/agpl-3.0.txt). All projects **must** properly attribute [The Original Source](https://github.com/niranjan94/show-java). 
    
    Show Java - A java/apk decompiler for android
    Copyright (C) 2017 Niranjan Rajendran

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

An unmodified copy of the above license text must be included in all forks.

To obtain the software under a different license, please contact [Niranjan Rajendran](https://niranjan.io) at `me <at> niranjan.io`.

## External Credits

1. A Big-Huge Thanks to Lee Benfield ([lee@benf.org](mailto:lee@benf.org)) for his awesome CFR - Class File Reader
2. Panxiaobo ([pxb1988@gmail.com](mailto:pxb1988@gmail.com)) for dex2jar.
3. [Liu Dong](https://github.com/xiaxiaocao) for apk-parser.
4. [Ben Gruver](https://github.com/JesusFreke/) for dexlib2.
5. [skylot](https://github.com/skylot) for JaDX.
6. [JetBrains](https://github.com/JetBrains) for FernFlower analytical decompiler.

> Android, Google Play and the Google Play logo are trademarks of Google Inc.
