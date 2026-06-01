#!/bin/bash
# vcftomatrix.sh - Extract genotype matrix from VCF
# Extracted from 1k1RG Database Training Workshop 2025

invcf=${1? Input VCF file }   #  Raw_SNP_and_InDel/IRRI_lines_SNP_DP3_QD2_MQ30_QUAL30_FS60.vcf.gz}
pref=${2? Output dir}
mkdir -p $pref

bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%TGT]\n' $invcf |  tr "|" "/"  | \
 tr -d "/" | \
 sed "s:chr0\?::"  | \
 awk -v OFS="\t" '{$1 = $1 + 0; print $0}'  > ${pref}/mat_vcf.txt

cut -f1-4 $pref/mat_vcf.txt > $pref/pos.txt

bcftools view -o -   -h $invcf  |  grep CHR | tr "\t" "\n"  | tail -n+10 > $pref/sample_list.txt
