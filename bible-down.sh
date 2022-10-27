#!/bin/bash

# check for dependencies

echo "Checking dependencies..."

if $(which ruby > /dev/null)
then
	:
else
	echo "Please install the latest version of ruby." ; exit 0
fi

if [[ -z $(gem list --local | grep 'net-http') ]]
then
	read -p "net-http not found. Would you like to install it? (Y/n) " yn
	case $yn in
		[Yy]* ) gem install net-http; break;;
        [Nn]* ) exit;;
        * ) gem install net-http; break;;
	esac
fi

if [[ -z $(gem list --local | grep 'colorize') ]]
then
	read -p "colorize not found. Would you like to install it? (Y/n) " yn
	case $yn in
		[Yy]* ) gem install colorize; break;;
        [Nn]* ) exit;;
        * ) gem install colorize; break;;
	esac
fi

if [[ -z $(gem list --local | grep 'optparse') ]]
then
	read -p "optparse not found. Would you like to install it? (Y/n) " yn
	case $yn in
		[Yy]* ) gem install optparse; break;;
        [Nn]* ) exit;;
        * ) gem install optparse; break;;
	esac
fi

if [[ -z $(gem list --local | grep 'clipboard') ]]
then
	read -p "clipboard not found. Would you like to install it? (Y/n) " yn
	case $yn in
		[Yy]* ) gem install clipboard; break;;
        [Nn]* ) exit;;
        * ) gem install clipboard; break;;
	esac
fi
# Defining arrays for book names, abbreviations, and lengths

bookarray=(Genesis Exodus Leviticus Numbers Deuteronomy Joshua Judges Ruth "1 Samuel" "2 Samuel" "1 Kings" "2 Kings" "1 Chronicles" "2 Chronicles" Ezra Nehemiah Esther Job Psalms Proverbs Ecclesiastes "Song of Solomon" Isaiah Jeremiah Lamentations Ezekiel Daniel Hosea Joel Amos Obadiah Jonah Micah Nahum Habakkuk Zephaniah Haggai Zechariah Malachi Matthew Mark Luke John Acts Romans "1 Corinthians" "2 Corinthians" Galatians Ephesians Philippians Colossians "1 Thessalonians" "2 Thessalonians" "1 Timothy" "2 Timothy" Titus Philemon Hebrews James "1 Peter" "2 Peter" "1 John" "2 John" "3 John" Jude Revelation)
abbarray=(Ge Exo Lev Num Deu Josh Jdgs Ruth 1Sm 2Sm 1Kgs 2Kgs 1Chr 2Chr Ezra Neh Est Job Psa Prov Eccl SSol Isa Jer Lam Eze Dan Hos Joel Amos Oba Jonah Mic Nah Hab Zep Hag Zec Mac Mtt Mark Luke John Acts Rom 1Cor 2Cor Gal Eph Phi Col 1Th 2Th 1Tim 2Tim Tit Phmn Heb Jas 1Pt 2Pt 1Jn 2Jn 3Jn Jude Rev)
lengtharray=(50 40 27 36 34 24 21 4 31 24 22 25 29 36 10 13 10 42 150 31 12 8 66 52 5 48 12 14 3 9 1 4 7 3 3 3 2 14 4 28 16 24 21 28 16 16 13 6 6 4 4 5 3 6 4 3 1 13 5 5 3 5 1 1 1 22)

# Choosing directory and command name
echo "Where would you like to store your Bible? Use $HOME instead of ~ or \$HOME."
read -ep "(The folder destination will also be the Bible command, e.g, kjv) " dest
mkdir -vp $dest
com=$(echo $dest | sed 's#\/$##;s#.*\/##')
COM=$(echo $com | tr '[:lower:]' '[:upper:]')

# Choosing Bible translation
read -p "What Bible translation would you like to use (e.g.; KJV, WEB)? " trans

echo "Downloading Bible. This may take a few minutes..."

# Cycling through book array
for ((i=0; i < ${#bookarray[@]}; i++))
do
	echo -n "${bookarray[$i]}"
	
	# Cycling through chapters of each book
	for ((j=1; j <= ${lengtharray[$i]}; j++))
	do
		ruby bg2md.rb -ceflr -v $trans "${abbarray[$i]}"$j | \
		sed 's/^[ \t]*//;s/[ \t]*$//' | \
		tr '\n' ' ' | \
		sed 's/###### /\n/g' | \
		sed 's/ /\t/' | \
		grep -v '#' | \
		awk \
			-v b="${bookarray[$i]}" \
			-v a="${abbarray[$i]}" \
			-v c="$j" \
			-v n="$(($i+1))" \
			'{print b"\t"a"\t"n"\t"c"\t"$0}' \
		>> $dest/$com.tsv
		echo -n '.'
	done
	echo ""
done

# Correcting scripts and build files
sed "s/kjv/$com/g;s/KJV/$COM/g" kjv.sh > $dest/$com.sh
sed "s/kjv/$com/g;s/KJV/$COM/g" kjv.awk > $dest/$com.awk
sed "s/kjv/$com/g" Makefile > $dest/Makefile

# Finish installation
echo "To finish installation:"
echo "cd $dest && sudo make install"
