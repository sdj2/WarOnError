package Test::OutputIs;

use warnings;
use strict;
use Test::More;
use IO::String;
use Exporter qw(import);

our @EXPORT = qw(output_is);
our @EXPORT_OK = qw(output_is);

# is() for STDOUT produced by closure
sub output_is {
	my $closure = shift;
	my $expected = shift;
	my $testName = shift;

	my $add_io = IO::String->new;
	my $old_handle = select($add_io);

	&$closure();

	select($old_handle);

	is(${$add_io->string_ref}, $expected, $testName);

	undef $add_io;
}

1;
