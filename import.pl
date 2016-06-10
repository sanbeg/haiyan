#! /usr/bin/perl

use strict;
use warnings;
use DBI;
use Getopt::Long;

my $table;
my $dbfile = 'protein.db';
my $max_lines;
my $max_errors = 10;
my $parse_spectrum = 0;

GetOptions(
	   'table=s' => \$table,
	   'db=s'    => \$dbfile,
	   'max=i'   => \$max_lines,
	   'max-errors' => \$max_errors,
	   'gpm!' => \$parse_spectrum,
	  ) or die;

$table //= $parse_spectrum ? 'gpm' : 'reporter';
my $sep_re = qr/\t/;

sub get_cols($) {
    my $line = shift;
    chomp (my @cols = map lc, split $sep_re, $line);
    # $cols[0] .= '_id';

    if ($parse_spectrum) {
	my $lastcol = pop @cols;
	push @cols, 'spectrum_title';
	# push @cols 'run_file';
    }

    return @cols;
}


my @cols = get_cols(<>);
my $col_list   = join(',', map "`$_`", @cols);
my $place_list = join(',', ('?') x @cols);

print "$col_list\n";

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile", '', '');

do {
    my $col_list = join(',', map("`$_` NUMERIC", @cols));
    warn $col_list;
    $dbh->do("CREATE TABLE `$table` ($col_list)");
};

my $stmt = "INSERT INTO `$table` ($col_list) VALUES ($place_list)";
my $sth = $dbh->prepare($stmt);

my $lines = 0;
my $errors = 0;
$dbh->do('begin');

my $prev_sequence = 'xxx';
while (<>) {
    chomp;
    s/&quot;/"/g;
    my @data = split $sep_re;

    if ($parse_spectrum) {

	if ($data[0] eq $prev_sequence) {
	    next;
	} else {
	    $prev_sequence = $data[0];
	}

	my $lastcol = pop @data;
	if ($lastcol =~ m/^(.+?scans:\s*\d+)\s*.+\\(.+)\|/) {
	    push @data, $1; #$2 was run_file col
	} elsif ($lastcol =~ m/^(.+?scans:\s*"\d+")/) {
	    push @data, $1;
	} else {
	    warn "Failed to parse last column: $lastcol";
	    ++ $errors;
	    warn("Too many errors!"), last if defined($max_errors) and $errors > $max_errors;
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

print "imported $lines to $table\n";

for my $col (@cols) {
    $dbh->do("CREATE INDEX IF NOT EXISTS `${col}_idx` on `$table`($col)")
      if $col eq 'title' or $col eq 'spectrum_title';
}

# select spectrum_id, count(*) as count from gpm group by spectrum_id having count > 1 order by count desc
