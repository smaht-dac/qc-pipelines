# This script is a Python 3 version of the script by Richard Corbett.
# Additional modifications have beem made to accomodate the SMaHT use case.
#
# Author: Alexander Veit (alexander_veit@hms.harvard.edu)
# Purpose: Provide a python script for iterating and calculate basic stats from a bam file
#
# Dependencies: This script needs samtools to be installed.
# Required Python packages: click


import click
import json, re
import subprocess

# Global variables
WQT = 10  # default quality threshold


@click.command()
@click.help_option("--help", "-h")
@click.option("-b", "--bam", required=True, type=str, help="Input BAM file")
@click.option(
    "-q",
    "--quality",
    required=False,
    type=int,
    default=40,
    help="Optional quality threshold.",
)
@click.option(
    "-c",
    "--chip",
    required=False,
    type=bool,
    default=True,
    help="Don't filter chastity reads, used for chip libraries.",
)
@click.option(
    "-s",
    "--second",
    required=False,
    type=bool,
    default=False,
    help="Use only the second read in a pair to generate results.",
)
@click.option(
    "-g",
    "--gsize",
    required=False,
    type=int,
    default=2913022398,  # Effective genome size / Length of the mappable genome. https://deeptools.readthedocs.io/en/develop/content/feature/effectiveGenomeSize.html
    help="Number of bases in the reference genome (hg38 is used by default)",
)
@click.option(
    "-p",
    "--print-result",
    required=False,
    type=bool,
    default=False,
    help="Print the results to the console",
)
@click.option(
    "-o",
    "--out",
    required=True,
    type=str,
    help="Output file that contains the JSON encoded results",
)
def main(bam, quality, chip, second, gsize, print_result, out):
    """This script calculates basic statistics of the provided BAM file

    Example usage:
    python bamStats.py -b MY_BAM.bam

    """

    WsnpQThresh = quality
    keepChastity = False if chip == False else True

    # Counter variables
    nChastPass = 0
    nChastFail = 0
    nReads = 0
    mapScores = [0] * 10
    nMapped = 0
    nUnmapped = 0
    nUnAmb = 0
    nAmb = 0
    WnUnambThresh = 0
    nUnAmb0 = 0  # for counting the number of mismatches in unambiguous alignments
    nUnAmb1 = 0
    nUnAmb2 = 0
    nUnAmb3 = 0
    nQCsumNoDups = 0
    WnDistinctUniqueThresh = 0
    # WnSnpBases=0
    WsnpReads = 0
    chr_count = {}
    nPairedAligned = 0
    sumInsert = 0
    WgenecovReads = 0
    nDups = 0
    WnDistinctUnique = 0
    bitFlag = 0
    xCalcSum = 0
    readLengths = {}

    # compile our regex's in hopes it makes this a little faster
    m0 = re.compile(r"NM:i:0")
    m1 = re.compile(r"NM:i:1")
    m2 = re.compile(r"NM:i:2")
    m3 = re.compile(r"NM:i:3")
    m0s = re.compile(r"CM:i:0")
    m1s = re.compile(r"CM:i:1")
    m2s = re.compile(r"CM:i:2")
    m3s = re.compile(r"CM:i:3")
    c_spl = re.compile(r".*[A-Z]")

    #bamfile = pysam.AlignmentFile(bam, "r")
    #Slurp from our bam file
    proc = subprocess.Popen('samtools view '+bam,
                            shell=True,
                            stdout=subprocess.PIPE)
    
    for line_bytes in proc.stdout:
        line = str(line_bytes, encoding='utf-8')
        linep=line.split("\t")
        bitFlag=int(line[1])

        #Do we only want the second reads of the pairs?
        if(second and (bitFlag & 64)):
            continue

        nReads+=1
        # if nReads % 1000 == 0:
        #     print(nReads)

        # Store read lengths
        l = len(linep[9])
        if(l in readLengths):
            readLengths[l] +=1
        else:
            readLengths[l] = 1

        #check for chastity filtering
        if((bitFlag & 512)==512 and keepChastity == False):
            nChastFail+=1
            continue
        else:
            nChastPass+=1

        if((bitFlag & 4) != 4): #Not unmapped
            nMapped+=1
            #Add to the mapping score histogram
            mapScore=int(linep[4])
            if(mapScore==0):
                mapScores[0]+=1
            elif(mapScore>0 and mapScore<10):
                mapScores[1]+=1
            elif(mapScore>=10 and mapScore<20):
                mapScores[2]+=1
            elif(mapScore>=20 and mapScore<30):
                mapScores[3]+=1
            elif(mapScore>=30 and mapScore<40):
                mapScores[4]+=1
            elif(mapScore>=40 and mapScore<50):
                mapScores[5]+=1
            elif(mapScore>=50 and mapScore<60):
                mapScores[6]+=1
            elif(mapScore>=60 and mapScore<70):
                mapScores[7]+=1
            elif(mapScore>=70 and mapScore<80):
                mapScores[8]+=1
            elif(mapScore>=80 and mapScore<90):
                mapScores[9]+=1

            if(mapScore != 0):
                nUnAmb+=1
            else:
                nAmb+=1

            if(mapScore >= WQT):
                WnUnambThresh+=1

            #Count the mismatches in the unique alignments
            if(mapScore>0):   
                if(m0.search(line) or m0s.search(line)):
                    nUnAmb0+=1
                if(m1.search(line) or m1s.search(line)):
                    nUnAmb1+=1
                if(m2.search(line) or m2s.search(line)):
                    nUnAmb2+=1
                if(m3.search(line) or m3s.search(line)):
                    nUnAmb3+=1

            #Not dups
            if((bitFlag & 1024)==0):
                xCalcSum+=(len(linep[9]))
                nQCsumNoDups+=1
                if(mapScore>=WQT):
                    WnDistinctUniqueThresh+=1
                if(mapScore>=WsnpQThresh):
                    WsnpReads+=1
                    #Count the basees
                    #cigar=linep[5]
                    #for part in cigar.split("M"):
                        #part=c_spl.sub("", part)
                        #if(part==""):
                            #continue;
                        #WnSnpBases+=int(part)

                if(mapScore>0):
                    key=linep[2]
                    if key not in chr_count:
                        chr_count[key] = 0
                    chr_count[key]+=1


        else: #unmapped
            nUnmapped+=1

        if((bitFlag&2)==2): #paired read
            nPairedAligned+=1
            sumInsert+=abs(int(linep[8]))

        if((bitFlag&1024)==1024): #dup flag
            nDups+=1
        elif((bitFlag&4)!=4 and mapScore >0): #not a dup, aligned, and mapScore > 0
            WnDistinctUnique+=1

    result = {
        "Read_lengths": readLengths,
        "Total_Number_Of_Reads": nReads,
        "Number_of_Reads_QC_Passed": nChastPass,
        "Number_of_Reads_QC_Failed": nChastFail,
        "Number_of_Duplicates": nDups,
        "Number_Reads_Aligned": nMapped,
        "Number_Reads_Unaligned": nUnmapped,
        "Number_Aligned_Reads_With_Mapping_Qualities": {
            "0": mapScores[0],
            "1-9": mapScores[1],
            "10-19": mapScores[2],
            "20-29": mapScores[3],
            "30-39": mapScores[4],
            "40-49": mapScores[5],
            "50-59": mapScores[6],
            "60-69": mapScores[7],
            "70-79": mapScores[8],
            "80-89": mapScores[9],
        },
        "Number_Unique_Alignments": nUnAmb,
        "Number_Non_Unique_Alignments": mapScores[0],
        "Number_Unique_Alignments_With_N_Mismatches": {
            "0": nUnAmb0,
            "1": nUnAmb1,
            "2": nUnAmb2,
            "3": nUnAmb3,
        },
        "Number_of_Paired_Alignments": nPairedAligned,
        "Average_Insert_Size": sumInsert/nPairedAligned if nPairedAligned>0 else 0,
        f"Number_of_Uniquely_Aligned_Reads_with_Q_>=_{WQT}": WnUnambThresh,
        "Number_of_Uniquely_Aligned_Reads_without_Dups_Q_>_0": WnDistinctUnique,
        f"Number_of_Uniquely_Aligned_Reads_without_Dups_and_Q_>=_{WQT}": WnDistinctUniqueThresh,
        f"Number_of_Uniquely_Aligned_Reads_without_Dups_and_Q_>=_{WsnpQThresh}": WsnpReads,
        "Estimate_Average_Coverage": float(xCalcSum)/float(gsize),
        "Number_Uniquely_Aligned_Without_Dups_to_Each_Chr": chr_count
    }

    if(print_result):
        print(json.dumps(result, indent=2))

    
    # Save it to file
    with open(out, "w") as outfile:
        result_enc = json.dumps(result, indent=4)
        outfile.write(result_enc)



if __name__ == "__main__":
    main()
