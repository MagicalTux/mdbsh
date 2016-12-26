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

OUT="${FILE}.db"
echo >&2 "Writing data to $OUT"

set -e
mdb-schema "$FILE" sqlite | sqlite3 "$OUT"

for foo in `mdb-tables "$FILE"`; do
	echo >&2 "Exporting table $foo ..."
	echo "BEGIN;"
	mdb-export -I sqlite -b octal "$FILE" "$foo"
	echo "COMMIT;"
done | sqlite3 "$OUT"

echo >&2 "Process completed!"

