#!/usr/bin/perl -s

if (! $fasta_files) {
	die "Usage: $0 -fasta_files=[file1,file2..] [-col=col] file\n";
}
$col = 0 if (! $col);

foreach $fasta (split(/,/, $fasta_files)) {
	open(F, $fasta) || die;
	while (<F>) {
		if (/^>(\S+)\s+(\S.*)$/) {
			$name = $1; $title = $2;
			$Title{$name} = $title;
		}
	}
	close(F);
}
close(F);

while(<>) {
	chomp;
	@Fields = split(/\t/);
	print;
	$name = $Fields[$col];
	if ($Title{$name}) {
		print "\t$Title{$name}";
	}
	print "\n";
}
