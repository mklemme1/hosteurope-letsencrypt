#!/bin/bash

echo
date 

######## Configuration
# Password to HostEurope's admin website KIS
export KIS_PASSWD=''
# customer No used in KIS
export KIS_KDNUMMER=''
# WebPack ID
export KIS_WP_ID=''
# domain to be equipped
export KIS_DOMAIN=''
# FTP user to this tomain, in order to upload challenge files
export FTP_USER=
# Password to FTP user
export FTP_PASSWD=

######## End of Configuration

./getssl -u -w . "$KIS_DOMAIN"

#./upload_to_kis.pl   

#end
