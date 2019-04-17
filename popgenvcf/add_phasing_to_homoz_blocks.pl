#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

my %variants;
my $num_samples = 2;
my @headers;
my $filename = $ARGV[0];

open IN, $filename;

while (<IN>) {
  my $line = $_;
  chomp($line);
  if ($line =~ /^##/) {
    print "$line\n";
  }
  elsif ($line =~ /^#CHROM/) {
    @headers = split(/\t/,$line);
    $num_samples = scalar(@headers)-9;
    foreach my $header (@headers) {
      @{$variants{$header}}=();
    }
    print "$line\n";
  }
  else {
    my @l;
    my @p = split(/\t/,$line);
    unless ($p[4]=~/,/ || $line =~ /\.:/) {
      my $vcf_line = "$p[0]\t$p[1]\t$p[2]\t$p[3]\t$p[4]\t$p[5]\t$p[6]\t$p[7]\t$p[8]";
      push @{$variants{"POS"}},$vcf_line ;
      my $i = 9;
      while ($i<@p) {
        push @{$variants{$headers[$i]}},$p[$i] ;
        $i++;
      }
    }
  }
}


my $k = 1 ;
my $num_of_lines = scalar(@{$variants{$headers[9]}});
my @final_lines;

while ($k<$num_of_lines-1) {
  my $i = 9;
  my @printed_line;
  push (@printed_line,$variants{"POS"}[$k]);
  while ($i<9+$num_samples) {
    my $pre_gt = $variants{$headers[$i]}[$k-1];
    my $cur_gt = $variants{$headers[$i]}[$k];
    my $fut_gt = $variants{$headers[$i]}[$k+1];
    my @pre_d = split(/:/,$pre_gt);
    my @cur_d = split(/:/,$cur_gt);
    my @fut_d = split(/:/,$fut_gt);
    my $pre_group = ".";
    my $cur_group = ".";
    my $fut_group = ".";
    if (scalar(@cur_d) < 9) {
      $cur_group = ".";
      $cur_d[8] = "."
    }
    else {
      $cur_group = $cur_d[8];
    }
    if ( scalar(@pre_d) < 9 || scalar(@fut_d) < 9) {
      $pre_group = ".";
      $fut_group = ".";
      $pre_d[8] = $pre_group;
      $fut_d[8] = $fut_group;
    }
    else {
      $pre_group = $pre_d[8];
      $fut_group = $fut_d[8];
    }
    if( $pre_group ne "." && $fut_group ne ".") {
      if ($cur_group eq ".") {
        if ($pre_group == $fut_group) {
          $cur_group = $pre_group;
          $cur_d[8] = $cur_group;
        }
      }
    }
    my $cur_print = join(":",@cur_d);
    push (@printed_line,$cur_print);
    $i++;
  }
  my $final_line = join("\t",@printed_line);
  my @c = $final_line =~ /(:\.)/g;
  push (@final_lines,$final_line);
  $k++;
}

my $id = 0 ;
my @groups;

foreach my $line (@final_lines) {
  my @p=split(/\t/,$line);
  my $i = 9;
  my $same = 1;
  my @new_groups;
  while ($i<scalar(@p)) {
    my @cur_d = split(/:/,$p[$i]);
    if ($cur_d[8] ne ".") {
      push (@{$groups[$i]},$cur_d[8]);
      push (@{$new_groups[$i]},$cur_d[8]);
    }
    @{$groups[$i]} = uniq(@{$groups[$i]});
    if (scalar(@{$groups[$i]})>1) {
      $same = 0;
      @groups = @new_groups;
    }
    $i++;
  }
  if (!$same) {
    $id ++;
  }
  $p[0] = $p[0] . "_$id";
  my $end_line = join("\t",@p);
  print "$end_line\n";
}
