
use Test::More;
use DBI;

my $dbfile = "tmp_$$.db";
my $rv = system "perl import.pl -gpm -db $dbfile t/data/gpm.tsv";
is($rv, 0, "import success");
ok( -f $dbfile );

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile", '', '');

my $count = $dbh->selectall_arrayref('select count(*) from gpm');
is($count->[0][0], 10, 'got 10 rows');

unlink $dbfile;

my $rows = $dbh->selectall_arrayref('select * from gpm limit 1');
is(@{$rows->[0]}, 18, 'got 18 cols');
is($rows->[0][0], 1, 'got sequence');
like($rows->[0][16], qr/scans:\s\d+$/, 'got scans');
like($rows->[0][17], qr/^\w+\.mgf$/, 'got file');

done_testing;
