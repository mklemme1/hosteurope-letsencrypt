#!/bin/bash

echo
date 

######## Configuration

# domain to be equipped
export KIS_DOMAIN=''

# Password to HostEurope's admin website KIS
export KIS_PASSWD=''
# login name for KIS, not customer number!
export KIS_KDNUMMER=''
# WebPack ID/ Contract ID, as found in KIS: Product Administration->Web Hosting
export KIS_WP_ID=''

# Virtual Host ID, "0" for global certificate
# check the URL of the KIS upload form for the ID
export KIS_V_ID=0


# FTP user to this domain, in order to upload challenge files
export FTP_USER=''
# Password to FTP user
export FTP_PASSWD=''

######## End of Configuration

./getssl -u -w . "$KIS_DOMAIN"

#./upload_to_kis.pl   

#end
