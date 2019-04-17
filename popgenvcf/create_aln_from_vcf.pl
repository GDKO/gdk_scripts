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
my $ok;

while (<IN>) {
  my $line = $_;
  chomp($line);
  my @p=split(/\t/,$line);
  if ($line =~ /^##/) {next;}
  elsif ($line=~/^#/) {
    @headers = split(/\t/,$line);
    my $l = join("\t",@headers[9..scalar(@headers)-1]);
    print("$l\n")
  }
  else {
    my $i=9;
    if (length($p[3])==length($p[4])) {
      my @snps;
      while ($i<@p) {
        my @gt_stats = split(/:/,$p[$i]);
        my $gt = $gt_stats[0];
        if ($gt eq "0/0") {
          push(@snps,$p[3])
        }
        elsif ($gt eq "1/1") {
          push(@snps,$p[4])
        }
        else {
          push(@snps,"wtf")
        }
        $i++;
      }
    my $l = join("\t",@snps);
    print "$l\n";
    }
  }
  #$k++;
  #if ($k == 100) {
  #  last;
  #}
}
