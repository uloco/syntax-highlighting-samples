#!/usr/bin/perl
use strict;
use v5.10;
package Foo::Bar;
use constant CONSTANT => 42;
print CONSTANT;
BEGIN { use Mojo::Base -strict; };
sub AUTOLOAD{}
autoloaded_sub_call();
#@method
sub sub_declaration: method;
#@deprecated
sub sub_definition($$$){}
*sub_declaration = \&sub_definition;
LWP::UserAgent->new();
my $scalar: someattr = `Executable string`; # line comment
$scalar =~ /is there something/;
my @array = (42, @{$scalar}, @$scalar, %$scalar, <STDIN>);
my %hash = ( bareword_string => %{@array[0]});
START: print 'Single quoted string';
say "Double quoted string";
say __LINE__;
say <<'MOJO';
    %= print "Mojo perl code"
    <% print "Some more Mojo code"; %>
MOJO


