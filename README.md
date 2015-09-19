# wocli

## Intro

A toolset to get an update World of Warcraft addons from Curse.com (main target is Linux but you never know, it can work on other OS).

The goal is to provide a command line tool as well as a nice UI.

So far it's a Perl script but things will change (or not). 

Please note it's work in progress. Feel free to help.

## Status

It is still under heavy development, nothing really works right now and it's more like a test of a workflow than the finale implementation.
However, I can promise one thing: this Perl script is going to work and do the job. So if I get tired of this or loose my purpose (stop playing WoW ^^). You still have a working tool.

## Help

Here is a basic help for this little program.

### Install

No need too, just run the script from the Github repo.
The following Perl modules are used, they should be part of the Perl distribution on your Linux box:
* LWP::UserAgent
* Data::Dumper
* Getopt::Long
* File::Path 

### Run

Here is a list of the commands and options you can use.

#### Options

* --build-cache: Force wocli to rebuild the addon cache. If this option is not set and the cache is recent enough wocli will start faster by just loading existing cache.
* --wow-dir: Set the World of Warcraft directory (on my computer it looks like: $ENV{HOME}/.cxoffice/World\ of\ Warcraft/drive_c/Program\ Files/World\ of\ Warcraft/). It only affect the current session. See --save for permanent changes.
* --save: is going to save your configuration in $ENV{HOME}/.wocli/config.
* --debug: turn debug on, meaning: lots of debug messages and lots of intermediate data saved in your local cache ($ENV{HOME}/.wocli/cache/).

#### Commands

##### install

Install addons, takes a list of addons shortnames in parameters. It's going to install all mandatory dependencies and ask you about the optional dependencies.

##### update

Update your installed addons to the latest version.

##### remove

Remove an installed addon. It will not remove the dependencies (so far because I don't want to bother with dependencies resolution on removale ^^).

##### clean

Clean the local cache.

##### search

Will search for the addons that matches your query.

