This script can be used alongside [jgclark's BibleGateway-to-Markdown](https://github.com/jgclark/BibleGateway-to-Markdown) and [bontibon's kjv](https://github.com/bontibon/kjv) to create a command-line Bible for any version available on Bible Gateway.

This will not download any Apocryphal books with Bibles that have them, although the script could be easily modified to handle these books.
See [Luke Smith's kjv](https://github.com/lukesmithxyz/kjv) for an example.

NOTE: This has not been tested on non-English translations.

## DISCLAIMER

Each Bible translation available on BibleGateway has its own licensing terms.
As far as I am aware, this script does not violate any terms of service for BibleGateway, but use your discretion when downloading Bibles.

## Installation

Clone the git repo and make the script executable.

```shell
git clone https://github.com/rwroberson/bible-down.git
cd bible-down
chmod +x bible-down.sh
```
## Usage

Run the script:

```shell
./bible-down.sh
```

You will be prompted for a location to store your files.
The directory name will be the command you'll use to search the Bible, so be sure to confirm that you don't have conflicting commands.
(For example, 'net' won't work.)

Next, you'll be prompted for a Bible version.
Most abbreviations will be obvious, but if you're unsure, check [BibleGateway.com](biblegateway.com) for the appropriate abbreviation.

After the download completes, navigate to the directory you specified and run:
```shell
sudo make install
```
