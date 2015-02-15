#! /usr/bin/perl

use strict;
use warnings;
use DBI;

chomp (my @cols = split "\t", <>);
$cols[0] .= '_id';

print "$_\n" for @cols;

my $dbh = DBI->connect("dbi:SQLite:dbname=dbfile","","");
my $col_list = join(',', map "`\L$_`", @cols);

my $stmt = "CREATE TABLE `gpm` ($col_list)";

print "$stmt\n";
$dbh->do($stmt);

my $place_list = join(',', ('?') x @cols);
$stmt = "INSERT INTO `gpm` ($col_list) VALUES ($place_list)";

print "$stmt\n";

my $sth = $dbh->prepare($stmt);

my $lines = 0;
$dbh->do('begin');
while (<>) {
    chomp;
    my @data = split "\t";
    $sth->execute(@data);

    if (++$lines % 1000 == 0) {
	$dbh->do('commit');
	$dbh->do('begin');
    }

}
$dbh->do('commit');

# select spectrum_id, count(*) as count from gpm group by spectrum_id having count > 1 order by count desc
