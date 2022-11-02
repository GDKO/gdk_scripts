#!/usr/bin/env perl

use strict;
use warnings;

my $filename = $ARGV[0];

open IN, $filename;
my %aln;
my @headers;

while (my $line = <IN>) {
  chomp($line);
  $line =~ s/>//;
  my $seq = <IN>;
  chomp($seq);
  $aln{$line}=$seq;
  push(@headers,$line);
}

for (my $i=0;$i<@headers;$i++) {
  my @f = split(//,$aln{$headers[$i]});
  for (my $k=$i+1;$k<@headers;$k++) {
    my @s = split(//,$aln{$headers[$k]});
    my $total_nucs = scalar(@f);
    my $gaps = 0;
    my $matches = 0;
    my $mismatches = 0;
    for(my $d=0;$d<@f;$d++) {
      if ($f[$d] eq "-" || $s[$d] eq "-") {
        $gaps++;
      }
      elsif ($f[$d] eq $s[$d]) {
        $matches++;
      }
      else {
        $mismatches++;
      }
    }
    my $full = $total_nucs - $gaps;
    my $div = 0;
    if ($full == 0) {
      $div="NA";
    }
    else {
      $div = $matches/$full;
    }
    print "$headers[$i]\t$headers[$k]\t$div\n";

  }
}
