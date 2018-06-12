# hosteurope-letsencrypt

Automatically use Let's Encrypt certificates with a HostEurope WebPack

## Situation

I have a WebPack hosting package at [HostEurope](https://www.hosteurope.de/).
They allow uploading certificates like the ones from [Let's
Encrypt](https://letsencrypt.org/), but there is no automation for the Let's
Encrypt renewal. I have now created a script that automates the process. It
runs on my Linux computer at home and organizes the process.

## Solution

_I did this a while ago, so let me know if you find the procedure does not
work for you!_

Modify the attached `run.sh` to contain variables for your situation

Get [getssl](https://github.com/srvrco/getssl) to communicate with Let's
Encrypt.

Call `./getssl -w . -c yourdomain.com` to set up

### Modify `yourdomain.com/getssl.cfg`

Modify the file `yourdomain.com/getssl.cfg` that has been created in the last
step.

Set additional domains as needed

    
    
    SANS="www.yourdomain.com,subdomain.yourdomain.com,otherdomain.de"

In each web domain, create the directory `.well-known/acme-challenge`

For the base domain, and each additional domain, create a line in `ACL`. Add
the path to the domain's `.well-known/acme-challenge` as last parameter.

    
    
    ACL=(
    "ftp:${FTP_USER}:${FTP_PASSWD}:${DOMAIN}:www/.well-known/acme-challenge"
    "ftp:${FTP_USER}:${FTP_PASSWD}:${DOMAIN}:www/.well-known/acme-challenge"
    "ftp:${FTP_USER}:${FTP_PASSWD}:${DOMAIN}:/subdomain/.well-known/acme-challenge"
    "ftp:${FTP_USER}:${FTP_PASSWD}:${DOMAIN}:/otherdomain/.well-known/acme-challenge"
    )

Store the produced certificates in the current folder

    
    
    DOMAIN_CERT_LOCATION="${KIS_DOMAIN}.crt"
    DOMAIN_KEY_LOCATION="${KIS_DOMAIN}.key"	
    CA_CERT_LOCATION="chain.crt"
    DOMAIN_CHAIN_LOCATION="domainchain.crt" # this is the domain cert and CA cert
    

use the attached Perl Program to upload the certificates to the server

    
    
    RELOAD_CMD="upload_to_kis.pl"
    

### Run it

If all goes right, you just need to enter the directory and call `./run.sh`.

This can also be done as a cron job:  
`23 5 * * * cd xxxxxx; ./run.sh >> log`

**Let me know if this works out for you!**

