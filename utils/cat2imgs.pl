#!/usr/bin/perl

use warnings;
use strict;

# This script extracts all images from the Categories.xml file and saves images.

my $categories = shift(@ARGV);

die "Need a Categories.xml file in parameter.\n" unless (defined($categories) && -e $categories && $categories =~ /Categories.xml/);

system("mkdir img");

open( my $fh, "<", $categories) or die "Unable to open $categories\n";

my $bindata="";
my $catname="";
while(my $line = <$fh>){
	chomp($line);
	if($line =~ /<Data.+>([^<]+)<\/Data>/){
		$bindata = $1;
	}
	elsif($line=~/<_x003C_Slug_x003E_k__BackingField>([^<]+)<\/_x003C_Slug_x003E_k__BackingField>/){
		$catname=$1;
	}
	elsif($line=~/<\/CCategory>/){
		$bindata="";
		$catname="";
	}
	
	if(defined($bindata) && defined($catname) && $bindata ne "" && $catname ne ""){
		print "Category data and name found: $catname\n";
		system("echo \"$bindata\" | base64 -d > img/$catname.png");
		$bindata="";
		$catname="";
	}
}

close($fh);