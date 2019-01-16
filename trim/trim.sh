for filename in *_R1_*.fastq
do
# first, make the base by removing fastq
  base=$(basename $filename .fastq)
  echo $base
  
# now, construct the R2 filename by replacing R1 with R2
  baseR2=${base/_R1_/_R2_}
  echo $baseR2
        
# finally, run Trimmomatic
  trimmomatic PE ${base}.fastq ${baseR2}.fastq \
    ${base}.qc.fq.gz s1_se.gz \
    ${baseR2}.qc.fq.gz s2_se.gz \
    ILLUMINACLIP:combined.fa:2:40:15 \
    LEADING:2 TRAILING:2 \
    SLIDINGWINDOW:4:2 \
    MINLEN:25

# save the orphans
  zcat s1_se.gz s2_se.gz >> orphans.qc.fq.gz
  rm -f s1_se.gz s2_se.gz
done
