#!/bin/bash
# Usage: fastq_interleaving_actions.sh [i|d] f.fastq r.fastq

if [[ $1 == "i" ]]; then
  INTERLEAVE=1
elif [[ $1 == "d" ]]; then
  INTERLEAVE=0
else
  echo "Usage: fastq_interleaving_actions.sh [i|d] f.fastq r.fastq i.fastq"
  echo "Please specify i for interleaving or d for deinterleaving"
  exit
fi

if [[ ${INTERLEAVE} == 1 ]]; then 
  paste $2 $3 | paste - - - - | awk -v OFS="\n" -v FS="\t" '{print($1,$3,$5,$7,$2,$4,$6,$8)}'
else
   paste - - - - - - - - | tee >(cut -f 1-4 | tr "\t" "\n" > $2) | cut -f 5-8 | tr "\t" "\n" > $3
fi
