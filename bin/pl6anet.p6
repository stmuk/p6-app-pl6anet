#!/usr/bin/env perl6

use v6;
use App::Pl6anet;

my $cfile = "cache.pl6"; 

my $app = App::Pl6anet.new( :file('t/perlanetrc'), :tmpl('t/index.tmpl'), :$cfile );

my %feeds = $app.parse-yaml;

my %cache = $app.cached( %feeds );

say $app.render-html(%cache);

# vim: expandtab shiftwidth=4 ft=perl6
