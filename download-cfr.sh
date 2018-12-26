#!/bin/sh
# Copyright (c) 2018 Brendan Chong Email: opr_nexus@yahoo.com

cfr_filematch="cfr*[.-_][0-9.-_]*[0-9].jar"
cfr_download="http://www.benf.org/other/cfr/index.html"
lib_path=("app" "libs")

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



#echo "<a.*a>\\$cfr_filematch"

latest_result=$(download $cfr_download | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"') #| grep -Eo 'cfr*[.-_][0-9.-_]*[0-9].jar'

res=$(echo $latest_result | grep -Eo 'cfr[-._][0-9]+\.[0-9]{1,3}+.jar' )

echo $res

lib_path=$(printf '%s/' "${lib_path[@]%/}" )

cd $lib_path 

lib_cfr=$(ls | grep -o "$cfr_filematch" )

echo $lib_cfr
#latest_result=$(download $cfr_download \ | xmllint --xpath 'string(//a[text()="some value"]/@href)' - )

#latest_result=$(echo "$latest_result" | grep "/<a\s+(?:[^>]*?\s+)?href=([\"'])(.*?)\1/") 

#res=$(echo "$latest_result" | grep -o "$cfr_filematch")

#echo $res



# download http://www.benf.org/other/cfr/cfr-0.138.jar > temp.jar