#!/usr/bin/perl

#https://www.openldap.org/faq/data/cache/629.html

# Perl code to create and print SHA1 and MD5 hashes of passwords
# shamelessly stolen from the openLDAP Faq-O-Matic
# written 19-Jul-01 by Ed Truitt
# Updated 12-Oct-01 to include a {crypt} version of the password

$theGoodWord = $ARGV[0];
chomp($theGoodWord);

# First, print the clear text version

print "\n" ;
print "The Good Word is ==> $theGoodWord \n " ;
print "\n" ;

# Now generate and print the SHA1 hash

use Digest::SHA1;
use MIME::Base64;
$ctx = Digest::SHA1->new;
$ctx->add($theGoodWord);
$hashedSHAPasswd = '{SHA}' . encode_base64($ctx->digest,'');
print 'userPassword: ' .  $hashedSHAPasswd . "\n";


# Now generate and print the MD5 hash

use Digest::MD5;
use MIME::Base64;
$ctx = Digest::MD5->new;
$ctx->add($theGoodWord);
$hashedMD5Passwd = '{MD5}' . encode_base64($ctx->digest,'');
print 'userPassword: ' .  $hashedMD5Passwd . "\n";


# Now generate and print the CRYPT version

# first we need to generate the salt

@chars = ("A" .. "Z", "a" .. "z", 0 .. 9, qw(. /) );
$salt = join("", @chars[ map { rand @chars} ( 1 .. 4) ]);

# now to generate the password itself

$cryptPasswd = '{crypt}' . crypt($theGoodWord,$salt);
print 'userPassword: ' .  $cryptPasswd . "\n";
print "\n";
