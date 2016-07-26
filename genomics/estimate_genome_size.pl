#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long qw(:config pass_through no_ignore_case);

my ($kmer_length,$kmer_peak,$number_of_reads,$number_of_bases);

GetOptions(
	"k|kmer_length=i" => \$kmer_length,
	"p|kmer_peak=i" => \$kmer_peak,
	"r|number_of_reads=i" => \$number_of_reads,
	"b|number_of_bases=i" => \$number_of_bases
);

die "Usage: estimate_genome_size.pl -k [kmer_length] -p [kmer_peak] -r [number_of_reads] -b [number_of_bases]\n" unless $kmer_length and $kmer_peak and $number_of_reads and $number_of_bases;

my $read_length=$number_of_bases/$number_of_reads;
my $coverage=($kmer_peak * $read_length) / ($read_length - $kmer_length + 1);
my $genome_size = int($number_of_bases / $coverage);

$coverage=int($coverage);

print "Est Coverage:$coverage\n";
print "Est Genome Size:$genome_size\n";
