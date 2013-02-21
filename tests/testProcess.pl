#!/usr/bin/env perl

use warnings;
use strict;
use Test::More tests => 8;

use lib '../lib';
use lib '../..';

use Test::OutputIs;

# Test handlers
my $null = sub { return ''; };
sub makeEat($) {
	my $num = shift;
	return sub($) {
		print 'ATE:' . substr $_[0], 0, $num;
		return substr $_[0], $num;
	};
}

# Test classifier with three rules
my $classifier = sub($) {
	my (@handlers);

	if ($_[0] =~ /12/) { push (@handlers, makeEat(2)); }
	if ($_[0] =~ /STOP/) { push (@handlers, $null); }
	if ($_[0] =~ /3/) { push (@handlers, makeEat(1)); }

	return @handlers;
};

# Processor unit tests
BEGIN { use_ok( 'WarOnError::Processor' ); }

my $processor = WarOnError::Processor->new;

output_is(sub {$processor->process('1234')}, '', 
	'No classifiers = no output');

ok($processor->setClassifier($classifier), 'Set classifier');

output_is(sub {$processor->process('')}, '', 
	'Empty message = empty output');
output_is(sub {$processor->process('.')}, '', 
	'No classes = empty output');
output_is(sub {$processor->process('1234')}, 'ATE:12ATE:3', 
	'Each handler is applied in order');
output_is(sub {$processor->process('234')}, 'ATE:2', 
	'Only matched handlers are applied');
output_is(sub {$processor->process('12STOP34')}, 'ATE:12', 
	'Handling stops when message is empty');
