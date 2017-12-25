#!/usr/bin/perl

use strict;
use WWW::Curl;
use WWW::Curl::Form;
use WWW::Curl::Easy qw();

# Login 
#my $kdnummer='176111';
my $kdnummer=$ENV{"KIS_KDNUMMER"};
my $passwd=$ENV{"KIS_PASSWD"};
my $wp_id=$ENV{"KIS_WP_ID"};

my $post_data = WWW::Curl::Form->new;
$post_data->formadd("v_id", '0');  # use different ID for specific web site
$post_data->formadd("menu", '6');
$post_data->formadd("mode", 'sslupload');
$post_data->formadd("wp_id", $wp_id);
$post_data->formadd("submode", 'sslfileupload');
#$post_data->formadd("", '');

#$post_data->formaddfile('mklemme.de.crt', "certfile", "application/pkix-cert");
$post_data->formaddfile('domainchain.crt', "certfile", "application/pkix-cert");
$post_data->formaddfile('mklemme.de.key', "keyfile", "application/pkix-cert");

my $curl = WWW::Curl::Easy->new;
$curl->setopt(WWW::Curl::Easy::CURLOPT_URL(), 
              "https://kis.hosteurope.de/administration/webhosting/admin.php?kdnummer=$kdnummer&passwd=$passwd");

my ($response_body,$response_header);
$curl->setopt(WWW::Curl::Easy::CURLOPT_WRITEDATA(),\$response_body);
$curl->setopt(WWW::Curl::Easy::CURLOPT_WRITEHEADER(), \$response_header);
$curl->setopt(WWW::Curl::Easy::CURLOPT_HTTPPOST(), $post_data);
$curl->setopt(WWW::Curl::Easy::CURLOPT_ENCODING() ,"UTF-8");

my $retcode = $curl->perform;
unless  ($retcode == 0) {
    die ("An error happened: $retcode ".$curl->strerror($retcode)." ".
         $curl->errbuf."\n");
}
    
my $response_code = $curl->getinfo(WWW::Curl::Easy::CURLINFO_HTTP_CODE());
if($response_code != 200) {
    die "unerwarteter HTTP Antwort-Code $response_code: $response_body";
}
open (PAGE, '>/tmp/page.html') || die $!;
print PAGE "response_header: $response_header\n";
print PAGE $response_body;
close PAGE;

unless ($response_body =~ /Die Dateien wurden erfolgreich hochgeladen./gis) {
    die "Upload nicht erfolgreich";
}

#end
