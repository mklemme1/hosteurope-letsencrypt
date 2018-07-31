# hosteurope-letsencrypt

Automatically use Let's Encrypt certificates with a HostEurope WebPack

> **HostEurope has closed down the interface to automatically upload certificates.
> There is currently no alternative known for this.
> Please let me know if you found a new interface.**


## Situation

I have a WebPack hosting package at [HostEurope](https://www.hosteurope.de/).
They allow uploading certificates like the ones from [Let's
Encrypt](https://letsencrypt.org/), but there is no automation for the Let's
Encrypt renewal. I have now created a script that automates the process. It
runs on my Linux computer at home and organizes the process.

## Solution

_I did this a while ago, so let me know if you find the procedure does not
work for you!_

Modify the attached `run.sh` to contain variables for your situation. Set its permissions to 700 to protect your passwords: `chmod 700 run.sh`

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
    
Use the attached Perl Program to upload the certificates to the server
    
    
    RELOAD_CMD="upload_to_kis.pl"
    

### Run it

If all goes right, you just need to enter the directory and call `./run.sh`.

This can also be done as a cron job:

     23 5 * * * cd xxxxxx; ./run.sh >> log

### Debugging

#### Check if you can log into KIS with the credentials
Open this URL in your browser
`https://kis.hosteurope.de/administration/webhosting/admin.php?kdnummer=XXX&passwd=YYY`

`KIS_KDNUMMER` is not the Customer Number, as the name suggests, but the login name to KIS

**Let me know if this works out for you!**

