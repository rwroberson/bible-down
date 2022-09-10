#!/bin/bash

# Defining arrays for book names, abbreviations, and lengths

bookarray=(Genesis Exodus Leviticus Numbers Deuteronomy Joshua Judges Ruth "1 Samuel" "2 Samuel" "1 Kings" "2 Kings" "1 Chronicles" "2 Chronicles" Ezra Nehemiah Esther Job Psalms Proverbs Ecclesiastes "Song of Solomon" Isaiah Jeremiah Lamentations Ezekiel Daniel Hosea Joel Amos Obadiah Jonah Micah Nahum Habakkuk Zephaniah Haggai Zechariah Malachi Matthew Mark Luke John Acts Romans "1 Corinthians" "2 Corinthians" Galatians Ephesians Philippians Colossians "1 Thessalonians" "2 Thessalonians" "1 Timothy" "2 Timothy" Titus Philemon Hebrews James "1 Peter" "2 Peter" "1 John" "2 John" "3 John" Jude Revelation)
abbarray=(Ge Exo Lev Num Deu Josh Jdgs Ruth 1Sm 2Sm 1Kgs 2Kgs 1Chr 2Chr Ezra Neh Est Job Psa Prov Eccl SSol Isa Jer Lam Eze Dan Hos Joel Amos Oba Jonah Mic Nah Hab Zep Hag Zec Mac Mtt Mark Luke John Acts Rom 1Cor 2Cor Gal Eph Phi Col 1Th 2Th 1Tim 2Tim Tit Phmn Heb Jas 1Pt 2Pt 1Jn 2Jn 3Jn Jude Rev)
lengtharray=(50 40 27 36 34 24 21 4 31 24 22 25 29 36 10 13 10 42 150 31 12 8 66 52 5 48 12 14 3 9 1 4 7 3 3 3 2 14 4 28 16 24 21 28 16 16 13 6 6 4 4 5 3 6 4 3 1 13 5 5 3 5 1 1 1 22)


text=$(mktemp)

for ((i=0; i < ${#bookarray[@]}; i++))
do
	#echo "${bookarray[$i]}" "${abbarray[$i]}"
	for ((j=1; j <= ${lengtharray[$i]}; j++))
	do

		ref=$(echo "${abbarray[$i]}"$j)
		$HOME/.scripts/bg2md.rb -ceflr -v ESV $ref | \
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
		>> esv.tsv

	done
done
