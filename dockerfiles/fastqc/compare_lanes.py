#!/usr/bin/env python
# -*- coding: utf-8 -*-

################################################
#
#   Compare lane's identifiers
#   across multiple FASTQ files to check
#   if there are duplicates.
#
#   Input is a list of text files,
#   one per each FASTQ file,
#   where lane's identifiers are listed as a column
#   after a header line.
#
#   E.g,
#       #- SMAUR5IPLE5A.fastq.gz
#       LH00180_99_2235GWLT4_8
#
#   Michele Berselli
#   berselli.michele@gmail.com
#
################################################


################################################
#   Libraries
################################################
import sys, argparse, os

################################################
#   Functions
################################################
def main(args):

    identifiers_dict = {}

    # Collecting lane information
    for file in args['inputfiles']:
        with open(file) as fi:
            for line in fi:
                if line.startswith("#"):
                    filename = line.rstrip().replace('#- ', '')
                else:
                    identifiers_dict.setdefault(line.rstrip(), [])
                    identifiers_dict[line.rstrip()].append(filename)

    # Parsing lane information
    is_duplicate = False
    sys.stdout.write('\n')
    for identifier, filenames_list in identifiers_dict.items():
        filenames = ','.join(filenames_list)
        sys.stdout.write(f'{identifier}: {filenames}\n')
        if len(filenames_list) > 1:
            is_duplicate = True

    # Fail if duplicates
    if is_duplicate:
        sys.exit("\nFiles with duplicate lane's identifiers found!\n")

    sys.stdout.write('\nAll good!\n')

################################################
#   MAIN
################################################
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='')

    parser.add_argument('-i','--inputfiles', nargs='+', help="list of input files containing lane's identifiers", required=True)

    args = vars(parser.parse_args())

    main(args)
