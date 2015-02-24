#! /usr/bin/perl

use strict;
use warnings;
use DBI;

my $table  = 'gpm';
my $dbfile = 'protein.db';

sub get_cols($) {
    my $line = shift;
    chomp (my @cols = map lc, split "\t", $line);
    $cols[0] .= '_id';
    return @cols;
}

my @cols = get_cols(<>);
my $col_list   = join(',', map "`$_`", @cols);
my $place_list = join(',', ('?') x @cols);

print "$col_list\n";

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile", '', '');
$dbh->do("CREATE TABLE `$table` ($col_list)");

my $stmt = "INSERT INTO `$table` ($col_list) VALUES ($place_list)";
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
