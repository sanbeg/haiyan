# haiyan
stuff for Haiyan

Usage:

    perl import.pl -gpm -db OUTFILE.db INFILE.tsv

To read the input from INFILE.tsv and import into the gpm table in OUTFILE.db.

|Option|Meaning|
|------|-------|
|-gpm   | Specify that it is in GPM format; otherwise it uses reporter format                     |
| -db FILE.db | Write output to the specified FILE.db, which will be created if it doesn't exist. |
