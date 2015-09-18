#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Data::Dumper;
use Getopt::Long;
use DBI;

# Global variables
my $DEBUG=0;
my $total_page=1;
my $db = "curse_db.csv";
my $addon_list_content="";
my %addon_table = ();
my %base_urls = (
	base => 'http://www.curse.com',
	home => 'http://www.curse.com/addons/wow?page=1',
	category => 'http://www.curse.com/addons/wow/category',
);
my $ua;
my $dbi;

# Options
my $opt_build_cache=0;
my $opt_wow_dir = "$ENV{HOME}/.cxoffice/World\ of\ Warcraft\ FR/drive_c/Program\ Files/World\ of\ Warcraft/";

# Methods

# Print debug messages when debug is enabled
sub debug_print {
	return unless defined($DEBUG);
	print "[debug] ",@_;
}

sub getAddonListContent {
	my $raw_content = shift(@_);
	my $last_key="";
	foreach my $tmp_line (split(/\n/,$raw_content)){
		if($tmp_line =~ /<a href="\/addons\/wow\/([^"]+)">([^<]+)<\/a>/){
# 			print "add: $2 (short: $1)\n";
			$addon_table{"$1"} = {name=>"$2",versionuptodate=>"0.0.0",version=>"0.0.0"};
			$last_key=$1;
			# Get addon version number
			unless($last_key =~ /^category/){
				my $response = $ua->get("$base_urls{base}/addons/wow/$last_key");
				if ($response->is_success) {
					if($DEBUG){
						system("mkdir -p cache/debug/db/addon");
						writeFile("cache/debug/db/addon/$last_key.html",$response->decoded_content);
					}
					if($response->decoded_content =~ /<li class="newest-file">Newest File: ([^<]+)<\/li>/){
						$addon_table{$last_key}->{version}=$1;
					}
					else{
						print "[error] unable to get version number for $last_key.\n";
					}
				}
				else{
					die $response->status_line;
				}
			
			}
		}
		elsif($tmp_line=~ /<li class="version version-up-to-date">Supports: ([\d\.]+)<\/li>/ ){
			$addon_table{$last_key}->{versionuptodate}=$1;
# 			print "add version $1 to $last_key\n";
		}
	}
}

sub installAddon {
	my $addon_shortname = shift(@_);
	if(exists($addon_table{$addon_shortname})){
		my $response = $ua->get("$base_urls{base}/addons/wow/$addon_shortname/download");
		if ($response->is_success) {
			if($response->decoded_content =~ /<a data-project="(\d+)" data-file="(\d+)" data-href="([^"]+)" class="download-link" href="#">click here<\/a>/){
				my $url = $3;
				if($url=~ /^.*\/([^\/]+)$/){
					my $file = $1;
					print "\t[debug] got addon download URL: $url (dl to $file)\n";
					$response = $ua->get($url,':content_file'=>"./cache/$file");
				}
				else{
					die "Can't extract file name from URL: $url\n";
				}
			}
			else{
				print "[error] couldn't extract download URL.\n";
			}
		}
		else{
			die $response->status_line;
		}
	}
	else{
		print "[error] $addon_shortname is not a valid (existing) addon short name.\n";
	}
}

sub writeFile{
	my $file_name = shift(@_);
	open(my $fh,">:encoding(UTF-8)",$file_name) or die "Can't open $file_name for writing\n";
	print $fh join('',@_);
	close($fh);
}

sub writeCache{
	open(my $fh,">:encoding(UTF-8)",$db) or die "Can't open $db for writing\n";
	foreach my $addon_shortname (keys(%addon_table)){
		print $fh "$addon_shortname;$addon_table{$addon_shortname}->{name};$addon_table{$addon_shortname}->{versionuptodate};$addon_table{$addon_shortname}->{version}\n";
	}
	close($fh);
}

sub loadCache {
	open(my $fh,"<",$db) or die "Can't open $db for reading\n";
	while(my $line = <$fh>){
		chomp($line);
		my @split = split(/;/,$line);
		my $shortname = $split[0];
		my $name = "";
		my $version = $split[$#split];
		my $updateversion = $split[$#split-1];
		if($#split>3){
			$split[0]="";
			$split[$#split-1]="";
			$split[$#split]="";
			$name = join('',@split);
		}
		else{
			$name = $split[1];
		}
		$addon_table{$shortname} = {name=>"$name",versionuptodate=>"$updateversion",version=>"$version"};
	}
	close($fh);
}

sub loadToc{
	my $toc_file = shift(@_);
	debug_print "Loading TOC file: $toc_file\n";
	my %toc_table=(shortname=>"",deps=>[],optdeps=>[],version=>"0.0.0");
# 	opendir(my $dh, $opt_wow_dir) or die "Can't open directory $opt_wow_dir for reading\n";
# 	my @tocs = grep { /^.*\.toc$/i } readdir($dh);
# 	closedir $dh;
	open my $fh, "<","$toc_file" or die "Can't open $toc_file for reading\n";
	## Dependencies: AtlasLoot_Loader
	## LoadOnDemand: 1
	## OptionalDeps: Ace3, LibBabble-Boss-3.0, LibBabble-Faction-3.0, LibBabble-Inventory-3.0, LibBabble-ItemSet-3.0, LibBabble-Zone-3.0, LibDBIcon-1.0, LibDataBroker-1.1
	## X-Curse-Packaged-Version: v6.05.03
	## X-Curse-Project-Name: AtlasLoot Enhanced
	## X-Curse-Project-ID: atlasloot-enhanced
	while(my $line = <$fh>){
		chomp($line);
# 		debug_print "(loadToc): '$line'\n";
# 		my $shortname = "";
# 		my $name = "";
# 		my $version = "0.0.0";
# 		my $updateversion = "0.0.0";
		
		if($line=~/^\s*##\s*X-Curse-Project-ID:\s*([^\s]+)/i){
			debug_print "(loadToc): found X-Curse-Project-ID\n";
			$toc_table{shortname}=$1;
		}
		elsif( $line=~/^\s*##\s*X-Curse-Packaged-Version:\s*([^\s]+)/i ){
			$toc_table{version}=$1;
		}
		elsif( $line=~/^\s*##\s*Dependencies:\s*([^\s]+)/i ){
			$toc_table{deps}=split(/,\s*/,$1);
		}
		elsif( $line=~/^\s*##\s*OptionalDeps:\s*([^\s]+)/i ){
			$toc_table{optdeps}=split(/,\s*/,$1);
		}
		
	}
	
	close $fh;
	return(%toc_table);
}

# Getting options from command line.
GetOptions(
  "build-cache"=>\$opt_build_cache,
  "wow-dir=s" => \$opt_wow_dir,
  "debug" => \$DEBUG
);

debug_print "/!\\ DEBUG is enabled, it can generate a lot of output/!\\\n";
debug_print "WoW directory: $opt_wow_dir\n";
debug_print "Remaining args: ".join(',',@ARGV)."\n";

$ua = LWP::UserAgent->new(agent => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.94 Safari/537.36');
$ua->timeout(10);
$ua->env_proxy;

if( -e $db && !$opt_build_cache ){
	debug_print "Loading cache (no download)\n";
	loadCache();
}
else{
	debug_print "Downlaoding new cache\n";
	my $response = $ua->get($base_urls{home});

	if ($response->is_success) {
	# 	print $response->decoded_content;  # or whatever
		if($response->decoded_content =~ /<span class="pager-display">Page 1 of (\d+)<\/span>/){
			$total_page=$1;
	# 		print "Total pages: $total_page\n";
			%addon_table = ();
			print "[progress] 1/$total_page\n";
			getAddonListContent($response->decoded_content);
			for (my $k=2;$k<=$total_page;$k++){
				print "[progress] $k/$total_page\n";
				$response = $ua->get("$base_urls{base}/addons/wow?page=$k");
				if ($response->is_success) {
					getAddonListContent($response->decoded_content);
				}
				else{
					print "[error] can't get page $k/$total_page\n";
				}
			}
			writeCache();
		}
		else{
			print "[error] unable to retrieve number of addons.\n";
		}
	}
	else {
		die $response->status_line;
	}
}

if($ARGV[0] eq 'install') {
	installAddon($ARGV[1]);
}
elsif($ARGV[0] eq 'update'){
	# Now we get to look for installed addons.
	my @toc_files = split(/\n/,`find '$opt_wow_dir' -name "*.toc"`);
	foreach my $tf (@toc_files){
		my %toc_data = loadToc($tf);
		if($DEBUG){
			print Data::Dumper::Dumper(%toc_data);
			debug_print "Continue?";
			<STDIN>;
		}
	}
}
else{
	die "Unknown command: $ARGV[0]\n";
}