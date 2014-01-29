#! /usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $min = 0;
my $max;

GetOptions (
  'min=f' => \$min,
  'max=f' => \$max,
 ) or die;

my %weights = (
  #letter,mono,avg
  A => [ 71.037114, 71.0779 ],
  R => [ 156.101111, 156.1857 ],
  N => [ 114.042927, 114.1026 ],
  D => [ 115.026943, 115.0874 ],
  C => [ 103.009185, 103.1429 ],
  E => [ 129.042593, 129.114 ],
  Q => [ 128.058578, 128.1292 ],
  G => [ 57.021464, 57.0513 ],
  H => [ 137.058912, 137.1393 ],
  I => [ 113.084064, 113.1576 ],
  L => [ 113.084064, 113.1576 ],
  K => [ 128.094963, 128.1723 ],
  M => [ 131.040485, 131.1961 ],
  F => [ 147.068414, 147.1739 ],
  P => [ 97.052764, 97.1152 ],
  S => [ 87.032028, 87.0773 ],
  T => [ 101.047679, 101.1039 ],
  U => [ 150.95363, 150.0379 ],
  W => [ 186.079313, 186.2099 ],
  Y => [ 163.06332, 163.1733 ],
  V => [ 99.068414, 99.1311 ],

  H2O => [2.015650 + 15.994915, 2.0159 + 15.9994],
 );


foreach my $str ( @ARGV ) {
  my @l = split //, uc($str);

  START:
  for my $i (0 .. $#l) {
    my $sum_mono = $weights{H2O}[0];
    my $sum_avg  = $weights{H2O}[1];
    my $word='';
    for my $j ( $i .. $#l ) {

      my $c = $l[$j];
      my $aa = $weights{ $c };
      if (defined $aa) {
	$sum_mono += $aa->[0];
	$sum_avg += $aa->[1];
	$word .= $c;
      } else {
	warn "Skipping unknown char: $c";
      }

      next START if defined $max and $sum_mono > $max;
      next if $sum_mono < $min;

      if ( length $word ) {
	print $word;
	printf("\t%.5f\t%.5f\n", $sum_mono, $sum_avg);
      }
    }
  }
}
