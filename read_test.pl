#!/usr/bin/perl
use strict;
use warnings;

select STDOUT;
$| = 1;

while (1) {
	my $len = read_amount(2);
	last unless defined $len;
	$len = unpack( 'n', $len );
	my $data = read_amount($len);
	print STDERR $data;
	print pack( 'n', length $data ), $data;
}

sub read_amount {
	my $buf    = '';
	my $remain = shift;
	while ( $remain > 0 ) {
		my $read = read STDIN, $buf, $remain, length $buf;
		die "Can't read $!" unless defined $read;
		return unless $read;
		$remain -= $read;
	}
	return $buf;
}
