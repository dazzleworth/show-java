#!/bin/sh
# Copyright (c) 2018 Brendan Chong Email: opr_nexus@yahoo.com
# Script to update CFR decompiler
# Tested to work with Git Shell in Windows: 
# https://github-windows.s3.amazonaws.com/GitHubSetup.exe 
# No permission required in normal Windows environment

name=cfr
name_sep='.-_'
name_sep_rev='-._'
ver_codes='0-9'
cfr_filematch="$name*[$name_sep][$ver_codes][$name_sep][$ver_codes].jar"
cfr_download="http://www.benf.org/other/cfr/"
lib_path=("app" "libs")
lib_path=$(printf '%s/' "${lib_path[@]%/}" )

echo 'Checking for update...'

# Reference : https://unix.stackexchange.com/q/83926
download() {
  read proto server path <<< "${1//"/"/ }"
  DOC=/${path// //}
  HOST=${server//:*}
  PORT=${server//*:}
  [[ x"${HOST}" == x"${PORT}" ]] && PORT=80

  exec 3<>/dev/tcp/${HOST}/$PORT

  # send request
  echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3

  # read the header, it ends in a empty line (just CRLF)
  while IFS= read -r line ; do 
      [[ "$line" == $'\r' ]] && break
  done <&3

  # read the data
  nul='\0'
  while IFS= read -d '' -r x || { nul=""; [ -n "$x" ]; }; do 
      printf "%s$nul" "$x"
  done <&3
  exec 3>&-
}



latest_result=$(download $(printf '%s/index.html' $cfr_download) | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"')

res=$(echo $latest_result | grep -Eo "$name[$name_sep_rev][$ver_codes]+\.[$ver_codes]{1,3}+.jar" | head -1)

#echo $res #| sed 's/[^0-9]*//g'

IFS=$name_sep read -r -a arr <<< $res

maj_rem="${arr[1]}"
min_rem="${arr[2]}"


cd $lib_path 

lib_cfr=$(ls | grep $cfr_filematch)

#echo $lib_cfr

IFS=$name_sep read -r -a arr <<< $lib_cfr

maj_local="${arr[1]}"
min_local="${arr[2]}"

maj_local=$(($maj_local+0))
maj_remote=$(($maj_remote+0))

if [ "$maj_remote" -le "$maj_local" ]
then
	min_local=$(($min_local+0))
	min_rem=$(($min_rem+0))
	
	if [ "$min_rem" -gt "$min_local" ]
	then
		echo 'Update found. Updating....'
		download $(printf '%s/%s' $cfr_download $res) > $res
		rm $lib_cfr
		cd -
		git add $(printf '%s%s' $lib_path $res)
		git commit -m $(printf 'Updated CFR to v%s.%s' $maj_remote $min_rem)
	else
		echo 'You have latest.'
	fi
fi

