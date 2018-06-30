#!/usr/bin/perl

use strict;
use WWW::Curl;
use WWW::Curl::Form;
use WWW::Curl::Easy qw();
use URI::Escape;

# Login 
my $kdnummer=$ENV{"KIS_KDNUMMER"};
my $passwd=$ENV{"KIS_PASSWD"};
my $wp_id=$ENV{"KIS_WP_ID"};
my $v_id=$ENV{"KIS_V_ID"};


my $post_data = WWW::Curl::Form->new;
$post_data->formadd("v_id", $v_id);  
$post_data->formadd("menu", '6');
$post_data->formadd("mode", 'sslupload');
$post_data->formadd("wp_id", $wp_id);
$post_data->formadd("submode", 'sslfileupload');

my $certfile=$ENV{"KIS_DOMAIN"}.'/domainchain.crt';
die ("$certfile not found") 
    unless  (-f $certfile);
$post_data->formaddfile($certfile,
                        "certfile", "application/pkix-cert");

my $keyfile=$ENV{"KIS_DOMAIN"}."/".$ENV{"KIS_DOMAIN"}.".key";
die ("$keyfile not found") 
    unless  (-f $keyfile);
$post_data->formaddfile($keyfile,
                        "keyfile", "application/pkix-cert");

my $curl = WWW::Curl::Easy->new;
my $url=
    "https://kis.hosteurope.de/administration/webhosting/admin.php?kdnummer=".
    uri_escape($kdnummer, { encode_reserved => 1 }) .
    "&passwd=" .
    uri_escape($passwd, { encode_reserved => 1 }); 
$curl->setopt(WWW::Curl::Easy::CURLOPT_URL(), $url);

my ($response_body,$response_header);
$curl->setopt(WWW::Curl::Easy::CURLOPT_WRITEDATA(),\$response_body);
$curl->setopt(WWW::Curl::Easy::CURLOPT_WRITEHEADER(), \$response_header);
$curl->setopt(WWW::Curl::Easy::CURLOPT_HTTPPOST(), $post_data);
$curl->setopt(WWW::Curl::Easy::CURLOPT_ENCODING() ,"UTF-8");
#$curl->setopt(WWW::Curl::Easy::CURLOPT_FOLLOWLOCATION, 1);

my $retcode = $curl->perform;
unless  ($retcode == 0) {
    die ("An error happened: $retcode ".$curl->strerror($retcode)." ".
         $curl->errbuf."\n");
}
    
my $response_code = $curl->getinfo(WWW::Curl::Easy::CURLINFO_HTTP_CODE());
if($response_code != 200) {
    die "unerwarteter HTTP Antwort-Code $response_code: $response_body";
}

unless ($response_body =~ /Die Dateien wurden erfolgreich hochgeladen./gis) {
    die "Upload nicht erfolgreich:\n$response_body\n";
}

#end
