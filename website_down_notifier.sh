#!/bin/bash

# Access the website either with its domain name or IP address. Acessing the
# website by IP address will ignore DNS issues, which may be out of our control.
url=http://www.example.com
#url=http://123.123.123.13

# If the website appears down, check again in five minutes to eliminate
# false positives.
/usr/bin/wget --server-response -O /dev/null $url > /dev/null 2> /dev/null
if [ $? -ne 0 ]
then
  echo "Website down. Waiting 5 minutes."
  sleep 300
  /usr/bin/wget --server-response -O /dev/null $url > /dev/null 2> /dev/null
  if [ $? -ne 0 ]
  then
    echo "Website down. Sending email and/or text messages."
    /usr/bin/mail -s "Website Down" 1234567890@txt.att.net email@address.com < /dev/null
  fi
fi
