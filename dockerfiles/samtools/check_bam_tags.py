#!/usr/bin/env python3

################################################
#
#   Check BAM tags
#
#   Michele Berselli
#   berselli.michele@gmail.com
#
################################################


################################################
#   Libraries
################################################

import sys
import argparse
import pysam


################################################
#   Functions
################################################

def check_tags_in_file(file: str, tags: list, threads: int = 1) -> None:
    """
    Checks if the requested tags are present in `file`.

    :param file: File to check
    :type file: str
    :param tags: List containing the requested tags as string
    :type tags: list
    :param threads: Number of threads to use for compression/decompression, defaults to 1
    :type threads: int, optional
    :raises SystemExit: If the requested tags are not present in `file`
        or if an error occurs while processing `file`
    :return: None
    :rtype: None
    """
    tags_set = set(tags)

    try:
        with pysam.AlignmentFile(file, 'rb', threads=threads, check_sq=False) as samfile:
            for read in samfile.fetch():
                tags_ = {tag_val[0] for tag_val in read.get_tags()}
                tags_set.difference_update(tags_)
                if not tags_set:
                    sys.stdout.write('\nAll tags found\n')
                    break

        if tags_set:
            sys.exit('\nMissing tags: ' + ' '.join(tags_set))
    except Exception as e:
        sys.exit(f'\nError processing file: {e}')


def main(args: dict) -> None:
    """
    Main function.

    :param args: Arguments from the command line
    :type args: dict
    :return: None
    :rtype: None
    """
    check_tags_in_file(args['file'], args['tags'], args['threads'])


################################################
#   MAIN
################################################
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Checks the presence of requested tags in a BAM file')

    parser.add_argument('-i', '--file',
                        help='Input BAM file', required=True)
    parser.add_argument('-l', '--tags',
                        help='List of tags to check', required=True, nargs='+')
    parser.add_argument('-t', '--threads', default=1,
                        help='Number of threads to use for compression/decompression [1]', required=False)

    args = vars(parser.parse_args())

    main(args)
