# wocli

## Intro

A small tool to install or update World of Warcraft addons from Curse.com (main target is Linux but you never know, it can work on other OS). Unlike other implementation it doesn't relly on parsing Curse.com website and is way faster than other programs.

The goal is to provide a command line tool as well as a nice UI.

So far it's a Perl script but things will change (or not). 

Please note it's work in progress. Feel free to help.

## Status

Wocli is still under development, you can find the backlog here:
https://github.com/arnauddupuis/wocli/issues

For Windows users it works with Cygwin provided that you install Perl and the required modules (have a look at the Install section).

## Help

Here is a basic help for this little program.

### Install

No need too, just run the script from the Github repo.
The following Perl modules are used, they should be part of the Perl distribution on your Linux box:
* LWP::UserAgent
* LWP::Protocol::https
* Data::Dumper
* Getopt::Long
* File::Path 
* Time::HiRes
* XML::Simple
* Term::ANSIColor
* List::Util
* JSON::XS


However, if you want to install system wide, you can do:
```bash
[adupuis@localhost wocli] $ sudo "make"
[sudo] password for adupuis: 
install -m 0755 wocli.pl /usr/local/bin
ln -s /usr/local/bin/wocli.pl /usr/local/bin/wocli
```

you can then call wocli system wide:
```bash
[adupuis@localhost ~] $ wocli search aki
speakinspell: Says random things in chat when casting any spell or ability. Type "/ss help" for the user's manual.

Found 1 partial name results.


```

## Uninstall

If you did install wocli you can uninstall it by running:
```bash
[adupuis@localhost wocli] $ sudo make uninstall
rm -f /usr/local/bin/wocli.pl
rm -f /usr/local/bin/wocli

```

### Quick first run

First, tell wocli where your World of Warcraft install is (and build the cache at the same time):
```bash
wocli.pl --wow-dir /your/path/to\ your/wow\ --save buildcache
```

Then you should be able to install/update/add/search easily:
```bash
wocli.pl install bagnon titan-panel gatherer
```

Please note that for install we need what we call "shortnames", wich is the X-Curse-Project-ID. When you search for an addon, the shortname is displayed first in green in the results list (here there is no formatting).
```bash
[adupuis@localhost wocli] $ ./wocli.pl search gath
gathernow: Give logical progression of Mining, Herbalism & Skinning. Will not be updated with WoD zones
gathermate2: Collects Herbs, Mines, Gas Clouds, Archaeology, Treasure and Fishing locations and adds them to the worldmap and minimap
titan-gathered: This simple WoW addon track all useful tradeitems and materials in your bag and show result in Titan Bar. Over right click is...
gathermate2_data-carbonite: GatherMate2 Data - Carbonite Edition
ygather: English yGather - Gatherers Map is a resource stack mapper. It records resource stack locations as you walk by and shows them...
gatherer: Helps track the closest plants, deposits and treasure locations on your minimap.
gathermate2_data: Wowhead Data dump for GatherMate2
gathertip: Show useful Tooltip for gather information!
gathermate_sharing: Database sharing module for GatherMate2

Found 9 partial name results.
[adupuis@localhost wocli] $ ./wocli.pl install gathermate2 gathermate2_data
Install:        gathermate2                                       :     installed (GatherMate2 1.35.5).
Install:        gathermate2_data                                  :     installed (GatherMate2_Data v29.4).

```

You can ask wocli to detect all your addons automatically by running the ```detect``` command:

```
[adupuis@localhost wocli] $ ./wocli.pl detect
WARNING: All detected addons are perfect matches, this means that they perfectly match the description (folder list) from Curse.com. Adding them to your installed database is safe and you can re-run anytime.

Following addons are going to be added to your installed database:
libdbicon-1-0, libsharedmedia-3-0, titan-panel-ranged-crit, libqtip-1-0, titan-panel-clan, libsink-2-0, titan-panel, libtoast-1-0, libitemupgradeinfo-1-0, ace3, libgroupinspect
Is that ok? (y/n) y
Adding: libdbicon-1-0                                     :     added (LibDBIcon-1.0 r50-release).
Adding: libsharedmedia-3-0                                :     added (LibSharedMedia-3.0 6.2.0).
Adding: titan-panel-ranged-crit                           :     added (Titan Panel [Ranged Crit] Titan Panel [Ranged Crit] ).
Adding: libqtip-1-0                                       :     added (LibQTip-1.0 r176-release).
Adding: titan-panel-clan                                  :     added (Titan Panel [Clan] r36).
Adding: libsink-2-0                                       :     added (LibSink-2.0 r111-release).
Adding: titan-panel                                       :     added (Titan Panel 5.6.19.60200).
Adding: libtoast-1-0                                      :     added (LibToast-1.0 6.2.0.3).
Adding: libitemupgradeinfo-1-0                            :     added (LibItemUpgradeInfo-1.0 Release-60203-15).
Adding: ace3                                              :     added (Ace3 Release-r1134).
Adding: libgroupinspect                                   :     added (LibGroupInSpecT LibGroupInSpecT-1.1-1.1.0).
[adupuis@localhost wocli] $ 
```

You can re-run this command as many time as you like (although it might be absolutely useless, but will do no harm).

IMPORTANT: As pointed out by [@khogeland](https://github.com/khogeland) in issue [#11](https://github.com/arnauddupuis/wocli/issues/11) the detect function assume all of your detected addons are up-to-date. As it is not always the case you should then run ```wocli reinstall```. This will reinstall all addons and optionally their dependencies.
EDIT: This is no longer the case. In 0.7.0 version is detected, and if the version couldn't be determined, it is set to 0 so the addon is updated at the next update.

```
[adupuis@localhost wocli]$ ./wocli reinstall
The following addons will be re-installed:
ace-gui-3-0-shared-media-widgets, ace3, auctionator, auto-bar, bagnon, bartender4, callbackhandler, classhandler-1-0, conslegion, customtutorials-1-0, dbm-pvp, deadly-boss-mods, deadly-boss-mods-wod, embedhandler, garrison-mission-manager, gatherer, gathermate2, gathermate2_data, gathermate_sharing, gladius, glamor, handynotes, handynotes_legionrarestreasures, handynotes_legiontreasures, handynotes_suramarleylines, handynotes_suramartelemancy, herebedragons, libactionbutton-1-0, libbabble-boss-3-0, libbabble-creaturetype-3-0, libbabble-subzone-3-0, libbuttonglow-1-0, libcompress, libdbicon-1-0, libdualspec-1-0, libkeybound-1-0, libqtip-1-0, libsharedmedia-3-0, libsink-2-0, libttscan-1, libwindow-1-1, master-plan, postal, rarity, scrap, spartan-ui, titan-currtrack, titan-panel, titan-panel-currencies-multi, titanap, titanpanel-recommended-zone, titanrep, titantreasury, unfit, worldquestgroupfinder

The following dependencies are required and will be re-installed as well:
embedhandler, embedhandler, deadly-boss-mods, deadly-boss-mods, gathermate2, bartender4, titan-panel, glamor, titan-panel

The following dependencies are optional and SHOULD be re-installed:
libttscan-1, addon-loader, glamor

The following dependencies are nice to have and MAY be re-installed:
ace3, libsharedmedia-3-0, callbackhandler, ace3, unfit, ace3, libkeybound-1-0, callbackhandler, libdbicon-1-0, libwindow-1-1, libdualspec-1-0, libactionbutton-1-0, libbuttonglow-1-0, libsharedmedia-3-0, libchatanims, liblatency, ace3, herebedragons, ace3, ace3, herebedragons, callbackhandler, callbackhandler, libbuttonglow-1-0, ace3, ace3, ace-gui-3-0-shared-media-widgets, libbabble-boss-3-0, libbabble-creaturetype-3-0, libcompress, libsharedmedia-3-0, libsink-2-0, libqtip-1-0, libdbicon-1-0, libbabble-subzone-3-0, herebedragons, embedhandler, classhandler-1-0, customtutorials-1-0, unfit, ace3, libdualspec-1-0, ace3, libsharedmedia-3-0, libqtip-1-0

What do you want to do?
R) Re-install addons + required dependencies.
O) Re-install addons + required dependencies (if any) + optional dependencies.
E) Re-install addons + required dependencies (if any) + optional dependencies (if any) + nice to have dependencies.
N) Do nothing and exit.
> E
Install:        ace-gui-3-0-shared-media-widgets                  :     installed (AceGUI-3.0-SharedMediaWidgets r57-release).
Install:        ace3                                              :     installed (Ace3 Release-r1151).
Install:        addon-loader                                      :     installed (AddonLoader r140-release).
Install:        auctionator                                       :     installed (Auctionator Auctionator 4.0.16).
Install:        auto-bar                                          :     installed (AutoBar AutoBar_7.1.5.02.zip).
Install:        bagnon                                            :     installed (Bagnon 7.1.1).
Install:        bartender4                                        :     installed (Bartender4 4.7.6).
Install:        callbackhandler                                   :     installed (CallbackHandler-1.0 1.0.6.70000).
Install:        classhandler-1-0                                  :     installed (ClassHandler-1.0 1).
Install:        conslegion                                        :     installed (ConsLegion ConsLegion v1.28).
Install:        customtutorials-1-0                               :     installed (CustomTutorials-2.0 5).
Install:        dbm-pvp                                           :     installed (Deadly Boss Mods - PvP Mods DBM-PvP-r59).
Install:        deadly-boss-mods                                  :     installed (Deadly Boss Mods 7.1.15).
Install:        deadly-boss-mods-wod                              :     installed (Deadly Boss Mods - Warlords of Draenor mods DBM-WoD-r10).
Install:        embedhandler                                      :     installed (EmbedHandler-1.0 4).
Install:        garrison-mission-manager                          :     installed (Garrison Mission Manager v55).
Install:        gatherer                                          :     installed (Gatherer 7.0.4).
Install:        gathermate2                                       :     installed (GatherMate2 1.39).
Install:        gathermate2_data                                  :     installed (GatherMate2_Data v30.1).
Install:        gathermate_sharing                                :     installed (GatherMate_Sharing v1.10).
Install:        gladius                                           :     installed (Gladius 5.1.1).
Install:        glamor                                            :     installed (Glamour Release 1.4.4).
Install:        handynotes                                        :     installed (HandyNotes v1.4.12).
Install:        handynotes_legionrarestreasures                   :     installed (Handynotes_LegionRares&Treasures v1.01b).
Install:        handynotes_legiontreasures                        :     installed (HandyNotes: Legion Treasures v10).
Install:        handynotes_suramarleylines                        :     installed (HandyNotes: Suramar Leylines v1).
Install:        handynotes_suramartelemancy                       :     installed (HandyNotes: Suramar Telemancy v5).
Install:        herebedragons                                     :     installed (HereBeDragons-1.0 1.17-release).
Install:        libactionbutton-1-0                               :     installed (LibActionButton-1.0 0.29.1).
Install:        libbabble-boss-3-0                                :     installed (LibBabble-Boss-3.0 7.0-release4).
Install:        libbabble-creaturetype-3-0                        :     installed (LibBabble-CreatureType-3.0 7.0-release1).
Install:        libbabble-subzone-3-0                             :     installed (LibBabble-SubZone-3.0 7.1-release2).
Install:        libbuttonglow-1-0                                 :     installed (LibButtonGlow-1.0 1.2.6).
Install:        libchatanims                                      :     installed (LibChatAnims r28-release).
Install:        libcompress                                       :     installed (LibCompress r76-release).
Install:        libdbicon-1-0                                     :     installed (LibDBIcon-1.0 r56-release).
Install:        libdualspec-1-0                                   :     installed (LibDualSpec-1.0 v1.13).
Install:        libkeybound-1-0                                   :     installed (LibKeyBound-1.0 r104 release).
Install:        liblatency                                        :     installed (LibLatency r15-release).
Install:        libqtip-1-0                                       :     installed (LibQTip-1.0 r178-release).
Install:        libsharedmedia-3-0                                :     installed (LibSharedMedia-3.0 7.1.0).
Install:        libsink-2-0                                       :     installed (LibSink-2.0 r120-release).
Install:        libttscan-1                                       :     installed (LibTTScan-1.0  v4).
Install:        libwindow-1-1                                     :     installed (LibWindow-1.1 r15-70000).
Install:        master-plan                                       :     installed (Master Plan 0.105).
Install:        postal                                            :     installed (Postal v3.5.8).
Install:        rarity                                            :     installed (Rarity r585a-release).
Install:        scrap                                             :     installed (Scrap (Junk Seller) 13.4).
Install:        spartan-ui                                        :     installed (SpartanUI 4.3.2-R10).
Install:        titan-currtrack                                   :     installed (Titan [CurrencyTracker] (+Glamour) Release 1.3.1 for WoW 6.0.3).
Install:        titan-panel                                       :     installed (Titan Panel 5.10.5.70100).
Install:        titan-panel-currencies-multi                      :     installed (Titan Panel [Currencies] Multi v5.14c).
Install:        titanap                                           :     installed (Titan Panel [Melee Attack Power] Titan Panel [Melee Attack Power] ).
Install:        titanpanel-recommended-zone                       :     installed (TitanPanel [Recommended Zone] TPRecZone 6.0.0.0).
Install:        titanrep                                          :     installed (Titan [Reputation] (+Glamour) TitanReputation-release-3.8.8.zip).
Install:        titantreasury                                     :     installed (Titan Panel [Treasury] r27).
Install:        unfit                                             :     installed (Unfit-1.0 3).
Install:        worldquestgroupfinder                             :     installed (World Quest Group Finder 0.21.2).
[adupuis@localhost wocli]$
```

### Run

Here is a list of the commands and options you can use.

#### Options

* **--build-cache**: Force wocli to rebuild the addon cache. If this option is not set and the cache is recent enough wocli will start faster by just loading existing cache.
* **--wow-dir**: Set the World of Warcraft directory (on my computer it looks like: $ENV{HOME}/.cxoffice/World\ of\ Warcraft/drive_c/Program\ Files/World\ of\ Warcraft/). It only affect the current session. See --save for permanent changes.
* **--save**: Is going to save your configuration in $ENV{HOME}/.wocli/config.
* **--debug**: Turn debug on, meaning: lots of debug messages and lots of intermediate data saved in your local cache ($ENV{HOME}/.wocli/cache/).
* **--db-ttl**: Takes an integer as parameter. It will set the cache time to live in seconds. Default is set to 7200 (2 hours). Do not set it to high to avoid issue with DB not synced with Curse.com.
* **--show-config**: Display the configuration before processing other tasks.
* **--version**: Display wocli version and exit.

#### Commands

##### install

Install addons, takes a list of addons shortnames in parameters. It's going to install all mandatory dependencies and ask you about the optional dependencies.

##### reinstall

Re-install addons without taking their version number in consideration. This command will reinstall all addons and there dependencies wether they are up-to-date or not.
It takes nothing or a list of addons shortnames in parameters. It's going to install all mandatory dependencies and ask you about the optional dependencies.
If called without arguments, it will reinstall all addons. If called with a list of addons in parameters it will only reinstall the listed addons and their dependencies.

```
[adupuis@localhost wocli]$ ./wocli reinstall scrap
The following addons will be re-installed:
scrap

The following dependencies are nice to have and MAY be re-installed:
embedhandler, classhandler-1-0, customtutorials-1-0, unfit

What do you want to do?
A) Re-install addons without installing any optional dependencies.
E) Re-install addons + required dependencies (if any) + optional dependencies (if any) + nice to have dependencies.
N) Do nothing and exit.
> E
Install:        classhandler-1-0                                  :     installed (ClassHandler-1.0 1).
Install:        customtutorials-1-0                               :     installed (CustomTutorials-2.0 5).
Install:        embedhandler                                      :     installed (EmbedHandler-1.0 4).
Install:        scrap                                             :     installed (Scrap (Junk Seller) 13.4).
Install:        unfit                                             :     installed (Unfit-1.0 3).
[adupuis@localhost wocli]$
```


##### update

Update your installed addons to the latest version. This finds your previously installed addons , as long as their .toc file contains a X-Curse-Project-ID tag.
Otherwise it's too risky to do anything automatically.
If you want your addon to be added to the tracked list of addon you can either re-install it with wocli (so it's the latest version available):
```bash
wocli.pl install <your addon list>
```

Or you can use the add command:
```bash
wocli.pl add <your addon list>
```

PLEASE REFER TO THE DOCUMENTATION FOR BOTH OF THESE COMMANDS.

##### remove

Remove an installed addon. It is neither removing dependencies nor it is warning or removing addons that depends on the removed one.

You can use the "*" wildcard in the addons names, you can even mix it with shortnames.

```
[adupuis@localhost wocli] $ ./wocli.pl remove *ell* rolecall
Following addons are going to be removed:
rolecall, tell-track
Is that ok? (y/n):y
Remove: rolecall                                          :     removed.
Remove: tell-track                                        :     removed.
[adupuis@localhost wocli] $ 
```

##### clean

Clean the local cache.

##### search

Will search for the addons that matches your query.

##### add

This command add a list of addon to the installed database. This is super useful if some of your addons that were installed without wocli are not automatically found by wocli. Default behaviour is that wocli only updates addons with a .toc file containing a X-Curse-Project-ID tag. 
If it is not the case of your addon (likely to happen), just add it to the list. It's that easy!
You don't need to do it for addon installed with wocli.

WARNING: wocli will NOT verify that the addon is actually installed (only that the addon name is a valid one). It means that next time you update your addons, it will install the addon that were added and not previously installed.
```bash
wocli.pl add titan-panel titan-panel-attributes-multi
```

##### showconfig

Simply display the wocli current configuration. It looks like that:
```
[adupuis@localhost wocli] $ ./wocli.pl showconfig
               -----------------------
               | WOCLI CONFIGURATION |
               -----------------------
config_dir          :  /home/adupuis/.wocli
config_file         :  config
db                  :  /home/adupuis/.wocli/cache/wocli_db.csv
db_ttl              :  900
installed_db        :  /home/adupuis/.wocli/wocli_installed_db.csv
uri_category        :  /addons/wow/category
uri_complete_db     :  http://clientupdate.curse.com/feed/Complete.xml.bz2
uri_home            :  /addons/wow?page=1
url_base            :  http://www.curse.com
wow_dir             :  ./test/

```

##### info

Display all the information available from Curse.com on **one** addon (anything after the first argument to this command is going to be ignored.

```
[adupuis@localhost wocli] $ ./wocli.pl info titan-panel
Here are the informations about:titan-panel:
Name: Titan Panel
Version: 5.6.19.60200
Curse Id: 489
Download Url: http://addons.curse.cursecdn.com/files/903/469/TitanPanel-5.6.19.60200.zip
Folders: Titan, TitanBag, TitanClock, TitanGold, TitanLocation, TitanLootType, TitanPerformance, TitanRepair, TitanVolume, TitanXP
Wocli score: 3056690
Summary: About Titan Panel adds one or two information bars on the top and/or bottom of the screen and allows a framework for extensiv...
[adupuis@localhost wocli] $ 
```

##### installed

Display the list of installed addons on your computer.

```
[adupuis@localhost wocli] $ ./wocli.pl installed
Here is the list of World of Warcraft addons, installed on your computer:
- LibDBIcon-1.0 (r50-release)
- LibGroupInSpecT (LibGroupInSpecT-1.1-1.1.0)
- LibItemUpgradeInfo-1.0 (Release-60203-14)
- LibQTip-1.0 (r176-release)
- LibSharedMedia-3.0 (6.2.0)
- LibSink-2.0 (r111-release)
- LibToast-1.0 (6.2.0.3)
[adupuis@localhost wocli] $ 
```

#### detect

This command allows you to detect all installed addons quite safely by looking up the directories in Interface/AddOns/ and compare them to Curse.com database that contains the list of all folders for every addon.
Then it is added to your installed database.

```
[adupuis@localhost wocli] $ ./wocli.pl detect
WARNING: All detected addons are perfect matches, this means that they perfectly match the description (folder list) from Curse.com. Adding them to your installed database is safe and you can re-run anytime.

Following addons are going to be added to your installed database:
libdbicon-1-0, libsharedmedia-3-0, titan-panel-ranged-crit, libqtip-1-0, titan-panel-clan, libsink-2-0, titan-panel, libtoast-1-0, libitemupgradeinfo-1-0, ace3, libgroupinspect
Is that ok? (y/n) y
Adding: libdbicon-1-0                                     :     added (LibDBIcon-1.0 r50-release).
Adding: libsharedmedia-3-0                                :     added (LibSharedMedia-3.0 6.2.0).
Adding: titan-panel-ranged-crit                           :     added (Titan Panel [Ranged Crit] Titan Panel [Ranged Crit] ).
Adding: libqtip-1-0                                       :     added (LibQTip-1.0 r176-release).
Adding: titan-panel-clan                                  :     added (Titan Panel [Clan] r36).
Adding: libsink-2-0                                       :     added (LibSink-2.0 r111-release).
Adding: titan-panel                                       :     added (Titan Panel 5.6.19.60200).
Adding: libtoast-1-0                                      :     added (LibToast-1.0 6.2.0.3).
Adding: libitemupgradeinfo-1-0                            :     added (LibItemUpgradeInfo-1.0 Release-60203-15).
Adding: ace3                                              :     added (Ace3 Release-r1134).
Adding: libgroupinspect                                   :     added (LibGroupInSpecT LibGroupInSpecT-1.1-1.1.0).
[adupuis@localhost wocli] $ 
```

### wb

This command is the WoW Battle mode (or who's best), it compares 2 addons and tells you wich one is the most praised by the curse.com community (the score is calculated as following: (DownloadCount/2+InstallCount*1.5+Likes*20)/4, this score is giving more importance to feedbacks from users that actually uses the addons).

```
[adupuis@localhost wocli]$ ./wocli wb auctioneer auctionator
The Curse.com community prefers auctioneer
```

The goal of this feature is to help you decide wich addon to choose between 2 addons.
