#!/usr/bin/perl -s
use File::Basename;

$BLOCK_SIZE=100000 if (! $BLOCK_SIZE);

$QSUB_SCRIPT_FILE = "qsub_blast.sh" if (! $QSUB_SCRIPT_FILE);

$query_file = $ARGV[0];

die "Usage: $0 [-BLOCK_SIZE=($BLOCK_SIZE)] [-QUERY_OUT_DIR=(query_<query_file_name>)] [-QSUB_SCRIPT_FILE=($QSUB_SCRIPT_FILE)] query_file\n" if (! $query_file);

$QFILE_NAME =  basename($query_file);
$QUERY_OUT_DIR = "query_$QFILE_NAME" if (! $QUERY_OUT_DIR);
$OUTPUT_FILENAME = "$QUERY_OUT_DIR/$QFILE_NAME";

## to create qsub script
$BLAST_OUT_DIR = "blastout_${QFILE_NAME}";
$BLAST_OPTIONS = "-outfmt 6 -evalue 0.001";
$BLAST_DB = "nr" if (! $BLAST_DB);
$MAX_EXEC = 32;

mkdir $QUERY_OUT_DIR;

$fn = 1;
while (<>) {
	if (/^>/){
		if ($len >= $BLOCK_SIZE) {
			&output_query($out, $fn);
			$fn++;
			$out = '';
			$len = 0;
    		}
	} else {
		$seq = $_;
		chomp $seq;
		$seq =~ s/\s+//g;
		$len += length($seq);
	}
	$out .= $_;
}

if ($len > 0) {
	&output_query($out, $fn);
}

&output_qsub_script($fn);

sub output_query {
	my($out, $fn) = @_;
	open(O, ">$OUTPUT_FILENAME.$fn");
	print O $out;
	close(O);
}

## create qsub script
sub output_qsub_script {
	my($num_split) = @_;
	open(O, ">${QSUB_SCRIPT_FILE}");
	print O <<SCRIPT_END;
#!/bin/sh
#\$ -cwd
#\$ -t 1-$num_split
#\$ -tc $MAX_EXEC
#\$ -N blastjob
#\$ -S /bin/sh
DB=${BLAST_DB}
SEQDIR=${QUERY_OUT_DIR}
OUTPUTDIR=${BLAST_OUT_DIR}

OPTIONS=(${BLAST_OPTIONS})

if [ ! -d \$OUTPUTDIR ]; then
	mkdir \$OUTPUTDIR
fi
blastp -db \$DB -query ${QUERY_OUT_DIR}/${QFILE_NAME}.\$SGE_TASK_ID -out \$OUTPUTDIR/${QFILE_NAME}.blast.\$SGE_TASK_ID "\${OPTIONS\[\@\]}"

SCRIPT_END
}
