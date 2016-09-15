stats
=====

### stats.R
Calculates statistics for numbers from STDIN
```
cat [numbers list] | stats.R
```

### RnB_counter
Calculates number of reads and bases in a fastq file (works also on gz files)
```
# To compile
cc -g -O2 RnB_counter.c -o RnB_counter -lz
# To run
RnB_counter [sequence_file]
```
