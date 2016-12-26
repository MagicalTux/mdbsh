#!/bin/sh

FILE=$1
if [ x"$FILE" = x ]; then
	echo >&2 "Syntax: $0 filename"
	echo >&2 "Filename is a Access database. A new file with appended .db will be created"
	exit 1
fi

if [ ! -f "$FILE" ]; then
	echo >&2 "File not found!!"
	echo >&2 "Syntax: $0 filename"
	echo >&2 "Filename is a Access database. A new file with appended .db will be created"
	exit 1
fi

echo >&2 "Writing data to current directory..."

set -e

for foo in `mdb-tables "$FILE"`; do
	echo >&2 "Exporting table $foo ..."
	mdb-export "$FILE" "$foo" >"${FILE}_${foo}.csv"
done

echo >&2 "Process completed!"

