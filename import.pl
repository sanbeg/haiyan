#! /usr/bin/perl

use strict;
use warnings;
use DBI;
use Getopt::Long;

my $table;
my $dbfile = 'protein.db';
my $max_lines;
my $parse_spectrum = 0;

GetOptions(
	   'table=s' => \$table,
	   'db=s'    => \$dbfile,
	   'max=i'   => \$max_lines,
	   'gpm!' => \$parse_spectrum,
	  ) or die;

$table //= $parse_spectrum ? 'gpm' : 'reporter';

sub get_cols($) {
    my $line = shift;
    chomp (my @cols = map lc, split "\t|,", $line);
    # $cols[0] .= '_id';

    if ($parse_spectrum) {
	my $lastcol = pop @cols;
	push @cols, 'spectrum_title', 'run_file';
    }

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
    my @data = split "\t|,";

    if ($parse_spectrum) {
	my $lastcol = pop @data;
	if ($lastcol =~ m/^(.+?scans:\s*\d+)\s*.+\\(.+)\|/) {
	    push @data, $1, $2;
	} else {
	    warn "Failed to parse last column: $lastcol";
	    next;
	}
    }

    $sth->execute(@data);

    if (++$lines % 1000 == 0) {
	$dbh->do('commit');
	$dbh->do('begin');
    }
    last if defined($max_lines) and $lines > $max_lines;
}
$dbh->do('commit');

# select spectrum_id, count(*) as count from gpm group by spectrum_id having count > 1 order by count desc
