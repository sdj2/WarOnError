package WarOnError::Processor;

use warnings;
use strict;

sub new {
	my $package = $_[0];
	my %processor = ('classifier' => undef);
	bless \%processor, $package;
}

sub process {
	my ($processor, $message) = @_;
	my $classify = $processor->{classifier};

	if (!defined($classify)) {
		return 0;
	}

	my @handlers = $classify->($message);

	foreach (@handlers) {
		if (!$message) {
			last;
		}
		$message = $_->($message);
	}
}

sub setClassifier {
	my ($processor, $classifier) = @_;
	$processor->{classifier} = $classifier;
}

1;
