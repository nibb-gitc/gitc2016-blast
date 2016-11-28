#!/usr/bin/perl

while (<>) {
	@F = split;
	$name1 = $F[0];
	$name2 = $F[1];
	$evalue = $F[10];
	$score = $F[11];

	next if ($evalue > 0.001);

	$Rank1{$name1}++;
	$Rank2{$name2}++;
	if ($Rank1{$name1} == 1 && $Rank2{$name2} == 1) {
		print;
	}
}
