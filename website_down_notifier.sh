#!/bin/bash

# List of URLs to check.
urls=(
  http://www.example1.com
  http://www.example2.com
)

for url in "${urls[@]}"
do
  /usr/bin/wget --server-response -O /dev/null $url > /dev/null 2> /dev/null
  if [ $? -ne 0 ]
  then
    # Full URLs can disappear in text messages. Extract the domain and use that
    # for all error reporting instead.
    domain=`echo $url | awk -F/ '{print $3} down'`

    # If the website appears down, check again in five minutes to eliminate
    # false positives.
    echo "$domain down. Waiting 5 minutes."
    sleep 300

    /usr/bin/wget --server-response -O /dev/null $url > /dev/null 2> /dev/null
    if [ $? -ne 0 ]
    then
      echo "$domain still down. Sending email and/or text messages."
      echo "$domain down" | /usr/sbin/sendmail 123456789@txt.att.net email@address.com
    fi
  fi
done
