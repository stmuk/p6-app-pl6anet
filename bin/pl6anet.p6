#!/usr/bin/env perl6

use v6;
use XML;
use Data::Dump;
use Net::Curl::Easy;
use App::Pl6anet::YAML;
use App::Pl6anet::HTML;
use App::Pl6anet::Cache;

constant DEBUG = %*ENV<DEBUG>;

my $f = @*ARGS.[0];

die "supply filename" unless $f;

my $file = "cache.pl6"; 

my $yaml = App::Pl6anet::YAML.new( :file('t/perlanetrc') );

my %feeds =  $yaml.parse;

my $cache = App::Pl6anet::Cache.new( :data(%feeds), :$file );

if DEBUG {
    $cache.make-cache;
}
else {
    $cache.make-cache unless $file.IO.e;
}

my %cache = EVALFILE $file;

my $html = App::Pl6anet::HTML.new( :tmpl('t/index.tmpl'), :data(%cache) );

say $html.render;

# vim: expandtab shiftwidth=4 ft=perl6
