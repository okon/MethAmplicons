# Setting up AmpliVar alias for ease
#PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin
#alias AmpliVar="bash ../../AmpliVar-master/bin/universal/amplivar_wrapper.sh"

# Input directory with fastq.gz files 
DIR="../data/raw/fastq"

# AmpliVar output directory - needs to be an existing directory
AMPLIVAR_DIR="../data/processed/amplivar/"

# Supporting files directory
SUP_DIR="../data/meth_supporting/"

for f in ${DIR}/*R1_001.fastq.gz
do
	FILEBASE=`basename $f _R1_001.fastq.gz`
	OUT_DIR=${AMPLIVAR_DIR}/${FILEBASE}/grouped/
	
	# cheat way to deal with SeqPrep bug - where SeqPrep successfully runs every nth time
	echo $OUT_DIR
	while [ ! -d $OUT_DIR ]
	do
		AmpliVar -m GENOTYPING -i $DIR \
		-o $AMPLIVAR_DIR -f $FILEBASE \
		-p ${SUP_DIR}/RAD51C_me_flanks.txt \
		-t 1 -d NEXTERA \
		-s ${SUP_DIR}/RAD51C_me_lookup.txt
	done
done

# Copy grouped files out to project directory
cp ${AMPLIVAR_DIR}/*/grouped/*grp  ../data/processed/amplicon_meth/