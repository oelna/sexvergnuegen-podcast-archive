#!/bin/zsh

if [ $# -eq 0 ]
	then
		echo "Please provide a valid path as argument."
		exit 64;
fi

dir=$1
tmpfile1="${dir}/tmp1"
tmpfile2="${dir}/tmp2"

find "$dir" -type f -name "*.srt"|while read filename; do

	if [ -f "${filename%.srt}.vtt" ]; then
		echo "skipped ${filename##*/}"
	else
		cp -- "$filename" "$tmpfile1"

		# fix misspelled names and words
		sed -i "" -E 's/Layla|Leila|Laila/Leila/g' "$tmpfile1"
		sed -i "" -e 's/L[aeä]*ila[[:space:]]Lo[a-z]*/Leila Lowfire/gi' "$tmpfile1"
		sed -i "" -e 's/Ines[[:space:]]An[a-z]*i/Ines Anioli/gi' "$tmpfile1"

		sed -i "" -e 's/Notte/Nutte/g' "$tmpfile1"
		sed -i "" -e 's/Sex[a-zäöü]*gen/Sexvergnügen/g' "$tmpfile1"

		echo "WEBVTT\n" | cat - "$tmpfile1" > "$tmpfile2"

		# fix timestamp format for VTT
		sed -i "" -e 's/:\([0-9]*\),\([0-9]*\)/:\1.\2/g' "$tmpfile2"

		# remove item numbers/indexes
		sed -i "" -e 's/^[0-9][0-9]*$//g' "$tmpfile2"

		cat -s "$tmpfile2" > "${filename%.srt}.vtt"

		echo "converted ${filename##*/}"
	fi

done

# clean up
if [ -f "$tmpfile1" ]; then
	rm "$tmpfile1"
fi
if [ -f "$tmpfile2" ]; then
	rm "$tmpfile2"
fi

exit;
