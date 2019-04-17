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

while (<IN>) {
  my $line = $_;
  chomp($line);
  my @p=split(/\t/,$line);
  if ($line =~ /^##/) {next;}
  elsif ($line=~/^#/) {
    @headers = split(/\t/,$line);
  }
  elsif ($p[4]=~/,/) {my $ok = 1}
  else {
    my $i=9;
    while ($i<@p) {
      my @gt_stats = split(/:/,$p[$i]);
      my $gt = $gt_stats[0];
      if ($gt eq "0/0" || $gt eq "0/1" || $gt eq "1/1"){
        my $rd = $gt_stats[1];
        my $min_ad = min split(/,/,$gt_stats[2]);
        my $frac = $min_ad/$rd;
        $lib_stats{$headers[$i]}{"count"}++;
        push (@{$lib_stats{$headers[$i]}{"rd"}},$rd);
        push (@{$lib_stats{$headers[$i]}{"frac"}},$frac);
        print "$headers[$i]\t$p[0]\t$p[1]\t$gt\t$rd\t$frac\n";
      }
      $i++;
    }
  }
  $k++;
  #if ($k == 100) {
  #  last;
  #}
}

#print Dumper(\%lib_stats);
