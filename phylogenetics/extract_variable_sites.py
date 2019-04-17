#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""extract_variable_sites.py
    Usage:
        extract_variable_sites.py -f <FILE> [-t <STR>]

    Options:
        -h, --help               show this
        -f, --filename <FILE>    alignment file
        -t, --type <STR>         alignment type [default: fasta]

"""

from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from docopt import docopt


def main():
    args = docopt(__doc__,version='1.03')
    filename = args['--filename']
    type = str(args['--type'])

    records = list(SeqIO.parse(filename, type))
    variable_sites = {}
    i = 0
    while i < len(records):
        variable_sites[records[i].id]=""
        i += 1

    k = 0

    while k < len(records[0].seq):
        i = 0
        pos = ["-", "N"]
        sites = []
        while i < len(records):
            q = records[i].seq[k]
            pos.append(q)
            sites.append(q)
            i += 1
        pos_set = set(pos)
        if len(pos_set) > 3:
            i = 0
            while i < len(records):
                variable_sites[records[i].id] += sites[i]
                i += 1
        k += 1

    final_records = []
    for id, seq in variable_sites.items():
        #print (">" + str(id) + "\n" + str(seq))
        record = SeqRecord(Seq(seq),id = id,description="")
        final_records.append(record)

    SeqIO.write(final_records, filename + ".variable_sites." + "fasta", type)

if __name__ == '__main__':
    main()
