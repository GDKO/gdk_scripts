#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

my %variants;

### Contig, Type [C,A], Distance, No. Genotypes
### $variants{$contig} = [[4988,0,1,0,0],[5666,0,1,0]]

my $filename = $ARGV[0];
my $num_samples = 2;
open IN, $filename;



while (<IN>) {
  my $line = $_;
  chomp($line);
  if ($line =~ /^##/) {
    next;
  }
  elsif ($line =~ /^#CHROM/) {
    my @p = split(/\t/,$line);
    $num_samples = scalar(@p)-11;
  }
  else {
    my @l;
    my @p = split(/\t/,$line);
    unless ($p[4]=~/,/ || $line =~ /0\/1/ || $line =~ /\.:/) {
      push @l, $p[1];
      my $i = 9;
      while ($i<@p) {
        my @d = split(/:/,$p[$i]);
        my @f = split(/\//,$d[0]);
        push @l,$f[0];
        $i++;
      }
    push @{$variants{$p[0]}}, \@l;
    }
  }
}



foreach my $contig (keys %variants) {
  next if @{$variants{$contig}}<2; # skipping contigs with one or less SNP
  my $i = 0;
  while ($i < @{$variants{$contig}} - 1) {
    my $k = $i + 1;
    while ($k < @{$variants{$contig}}) {
      my $type = "A";
      if ($k - $i == 1) {
        $type = "C";
      }
      my $distance = $variants{$contig}[$k][0] - $variants{$contig}[$i][0];
      my @genotypes;
      for (my $n = 1 ; $n < @{$variants{$contig}[$i]}; $n ++) {
        my $genotype = "$variants{$contig}[$i][$n]"."$variants{$contig}[$k][$n]";
        push @genotypes, $genotype;
      }

      my $c00 = grep { $_ eq "00"  } @genotypes;
      my $c01 = grep { $_ eq "01"  } @genotypes;
      my $c10 = grep { $_ eq "10"  } @genotypes;
      my $c11 = grep { $_ eq "11"  } @genotypes;


      my $p0 = ($c00 + $c01)/$num_samples;
      my $p1 = ($c10 + $c11)/$num_samples;
      my $q0 = ($c00 + $c10)/$num_samples;
      my $q1 = ($c01 + $c11)/$num_samples;

      my $r2 = "NA";
      my $D = "NA";

      unless ($p0 == 0 || $p1 == 0 || $q0 == 0 || $q1 == 0 ) {
        $D = (($c00*$c11)/($num_samples*$num_samples)) - (($c01*$c10)/($num_samples*$num_samples));
        $r2 = ($D*$D)/($p0*$p1*$q0*$q1);
        $D = sprintf("%.3f", $D);
        $r2 = sprintf("%.3f", $r2);
        my $uniq_genotypes = scalar(uniq @genotypes);
        print "$contig\t$type\t$distance\t$uniq_genotypes\t$r2\t$D\n";
      }
      $k++;
    }
    $i++;
  }
}
