#!/usr/bin/env perl

use strict;
use warnings;
use List::Util qw( min max );
use Data::Dumper;

my $filename = $ARGV[0];

open IN,"$filename";
my @headers;

my %lib_stats;
my $k = 0;
my $print = 0;

while (<IN>) {
  my $line = $_;
  chomp($line);
  if ($line =~ /^#/) {print "$line\n";}
  else {
    $print = 1;
    my @p=split(/\t/,$line);
    my $i=9;
    while ($i<@p) {
      my @gt_stats = split(/:/,$p[$i]);
      my $gt = $gt_stats[0];
      if ($gt eq "0/1" or $gt eq "0|1" or $gt eq "1|0") {$print=0}
      if ($p[4] =~ /,/) {$print=0}
      $i++;
    }
  }
  if ($print) {print "$line\n"}
  $k++;
  #if ($k == 100) {
  #  last;
  #}
}

#print Dumper(\%lib_stats);
