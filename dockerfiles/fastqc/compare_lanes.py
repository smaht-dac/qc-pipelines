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
    output_log = ''

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
    for identifier, filenames_list in identifiers_dict.items():
        filenames = '|'.join(filenames_list)
        output_log += f'{identifier}: {filenames}\n'
        if len(filenames_list) > 1:
            is_duplicate = True

    # Fail if duplicates
    if is_duplicate:
        sys.stderr.write(output_log)
        sys.exit("\nERROR. Files with duplicate lane's identifiers found!\n")

    # Write output log if pass
    with open(args['outputlog'], 'w') as fo:
        fo.write(output_log)

    sys.stderr.write("\nAll good. No duplicate lane's identifiers found!\n")

################################################
#   MAIN
################################################
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='')

    parser.add_argument('-i', '--inputfiles', nargs='+', help="list of input files containing lane's identifiers", required=True)
    parser.add_argument('-o', '--outputlog', help="output log file", default='log.txt', required=False)

    args = vars(parser.parse_args())

    main(args)
