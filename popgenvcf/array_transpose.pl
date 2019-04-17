#!/usr/bin/env perl

use strict;
use warnings;
use Array::Transpose;

my $filename = $ARGV[0];

open IN, "$filename";

my @array;

while (<IN>) {
  chomp;
  my @p = split(/\t/,$_);
  push(@array,\@p);
}

close IN;

my @q_array=transpose(\@array);

for (my $i=0; $i < scalar(@q_array); $i++) {
  my @nex = @{$q_array[$i]};
  print ">".$nex[0]."\n";
  for (my $k = 1 ; $k < scalar(@nex) ; $k++) {
    print $nex[$k];
  }
  print "\n";
}
