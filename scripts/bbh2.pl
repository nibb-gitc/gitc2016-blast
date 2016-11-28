#!/usr/bin/perl

$RATIO = 0.9;

while (<>) {
	@F = split;
	$name1 = $F[0];
	$name2 = $F[1];
	$score = $F[11];

	if (! defined $Best1{$name1}) {
		$Best1{$name1} = $score;
	}
	if (! defined $Best2{$name2}) {
		$Best2{$name2} = $score;
	}
	if ($score >= $Best1{$name1} * $RATIO && $score >= $Best2{$name2} * $RATIO) {
	#	print "$Best1{$name1},$Best2{$name2};$_";
		print;
	}
}
