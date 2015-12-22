#!/usr/bin/perl

use warnings;
use strict;

# This script extracts all images from the Categories.xml file and saves images.

my $categories = shift(@ARGV);

die "Need a Categories.xml file in parameter.\n" unless (defined($categories) && -e $categories && $categories =~ /Categories.xml/);

system("mkdir img");

open( my $fh, "<", $categories) or die "Unable to open $categories\n";
open (my $sqlfh, ">categories.sql") or die "Unable to write in categories.sql\n";

my $bindata="";
my $catname="";
my $catid=0;
while(my $line = <$fh>){
	chomp($line);
	if($line =~ /<Data.+>([^<]+)<\/Data>/){
		$bindata = $1;
	}
	elsif($line=~/<_x003C_Slug_x003E_k__BackingField>([^<]+)<\/_x003C_Slug_x003E_k__BackingField>/){
		$catname=$1;
	}
	elsif($line=~ /<_x003C_Id_x003E_k__BackingField>([^<]+)<\/_x003C_Id_x003E_k__BackingField>/){
		$catid=$1;
	}
	elsif($line=~/<\/CCategory>/){
		$bindata="";
		$catname="";
		$catid=0;
	}
	
	if(defined($bindata) && defined($catname) && $bindata ne "" && $catname ne "" && $catid > 0 ){
		print "Category data and name found: $catname\n";
		system("echo \"$bindata\" | base64 -d > img/$catname.png");
		print $sqlfh "insert into CategoriesImages values ($catid,\"$catname.png\");\n";
		$bindata="";
		$catname="";
		$catid=0;
	}
}

close($fh);
close($sqlfh);