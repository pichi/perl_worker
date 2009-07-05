package Erlang::PacketIO;

use strict;
use warnings;
use IO::Handle;

my ( $stdin, $stdout );

$stdin  = IO::Handle->new_from_fd( 0, 'r' );
$stdout = IO::Handle->new_from_fd( 1, 'w' );
$stdout->autoflush;

tie *STDIN,  __PACKAGE__;
tie *STDOUT, __PACKAGE__;

*ARGV = *STDIN;

sub TIEHANDLE { my $i; bless \$i, shift }

sub READLINE {
	my $len = read_amount(2);
	return unless defined $len;
	$len = unpack( 'n', $len );
	return read_amount($len);
}

sub PRINT {
	shift();
	my $len;
	$len += length for @_;
	print $stdout pack( 'n', $len ), @_;
}

sub read_amount {
	my $buf    = '';
	my $remain = shift;
	while ( $remain > 0 ) {
		my $read = read $stdin, $buf, $remain, length $buf;
		die "Can't read $!" unless defined $read;
		return unless $read;
		$remain -= $read;
	}
	return $buf;
}

1;
