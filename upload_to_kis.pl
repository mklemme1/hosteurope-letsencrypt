#!/usr/bin/perl -w

use strict;
use WWW::Mechanize ();
use Data::Dumper;

### Login-Daten  
my $kdnummer=$ENV{"KIS_KDNUMMER"};
my $passwd=$ENV{"KIS_PASSWD"};
my $wp_id=$ENV{"KIS_WP_ID"};
my $v_id=$ENV{"KIS_V_ID"};


my $mech = WWW::Mechanize->new(
	cookie_jar => {},
	autocheck => 1,
	protocols_allowed => [ 'http', 'https' ],
#	verbose_forms => 1, 
	);
$mech->agent_alias( 'Windows Mozilla' );

### Login
## Hole Startseite für Cookies
$mech->get("https://kis.hosteurope.de/administration/webhosting/admin.php");
$mech->get('https://sso.hosteurope.de/?app=kis&path=%2F');

## POST der Login-Daten
$mech->add_header("Content-Type" => "application/json");
$mech->post('https://sso.hosteurope.de/api/app/v1/login',
	content=> 
	'{"brandId":"b9c8f0f0-60dd-4cab-9da8-512b352d9c1a","locale":"de-DE","identifier":"'.
	$kdnummer.'","password":"'.$passwd.'"}');

my $content= $mech->content;
die "Authentifizierung nicht erfolgreich: $content"
  unless ($content =~ m|"success":true}|) ;

$mech->delete_header("Content-Type" );
$mech->get('https://sso.hosteurope.de/api/app/v1/redirectUrl?brandId=b9c8f0f0-60dd-4cab-9da8-512b352d9c1a&app=kis&path=%2F');

### Upload
## Formular holen
$mech->get('https://kis.hosteurope.de/administration/webhosting/admin.php?menu=6&wp_id='.$wp_id.'&mode=sslupload');

## Formular ausfüllen
my $certfile=$ENV{"KIS_DOMAIN"}.'/domainchain.crt';
die ("$certfile not found") 
    unless  (-f $certfile);
my $keyfile=$ENV{"KIS_DOMAIN"}."/".$ENV{"KIS_DOMAIN"}.".key";
die ("$keyfile not found") 
    unless  (-f $keyfile);

$mech->form_with_fields(("keyfile")) || die $!;
$mech->field("v_id"=> $v_id);  
$mech->field("menu"=> '6');
$mech->field("mode"=> 'sslupload');
$mech->field("wp_id"=> $wp_id);
$mech->field("submode"=> 'sslfileupload');
$mech->field("certfile"=>  $certfile);
$mech->field("keyfile"=>  $keyfile);

$mech->submit();
die "konne Formular nicht senden" unless ($mech->success);


$content=$mech->content;
die ("Upload nicht erfolgreich") 
	unless ($content =~ m|Die Dateien wurden erfolgreich hochgeladen.|);

#print $mech->content. "\n---\n";
open (OUT, ">/tmp/page.html"); 
print OUT $mech->content;
close OUT;
#$mech->dump_headers();
#exit;

#end
