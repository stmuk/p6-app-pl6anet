#!/usr/bin/env perl6

use v6;
use XML;
use Data::Dump;
use Net::Curl::Easy;
use App::Pl6anet::YAML;
use App::Pl6anet::HTML;

constant DEBUG = %*ENV<DEBUG>;

my $f = @*ARGS.[0];

die "supply filename" unless $f;

my $cache-f = "cache.pl6"; 

my $yaml = App::Pl6anet::YAML.new( :file('t/perlanetrc') );

my %feeds =  $yaml.parse;

if DEBUG {
    make-cache(%feeds, $cache-f);
}
else {
    make-cache(%feeds, $cache-f) unless $cache-f.IO.e;
}

my %cache = EVALFILE $cache-f;

my $html = App::Pl6anet::HTML.new( :tmpl('t/index.tmpl'), :data(%cache) );

say $html.render;

sub make-cache(%feeds,$f) {

    for %feeds.keys -> $url {
        DEBUG and warn :$url.perl;
        my $resp = Net::Curl::Easy.new(:url($url)).download;
        %feeds{$url}<content> = process-xml( $resp );
    }

    spurt($f, %feeds.perl);
}

sub process-xml($data) {
    my $xml = from-xml($data);

    DEBUG and warn :$data.perl;

    my $content;

    if  ($content = $xml.getElementsByTagName("content")).so  {
        $content =  $content.[0].contents;
        DEBUG and warn "#1";
    } 
    elsif ($content = $xml.getElementsByTagName("content:encoded")).so {
        $content = $content.[0].nodes.[0].data;
        DEBUG and  warn "#2";
    }
    elsif ($content = $xml.getElementsByTagName("item")).so {
        $content = $content.[0].getElementsByTagName("description").[0].contents;
        DEBUG and warn "#3";
    }

    $content = $content.Str; 
    $content = unescape($content);
    DEBUG and warn :$content.perl;
    return $content;
}

sub unescape($body is copy) {
    $body.=subst(/'&gt;'/ ,">", :g);
    $body.=subst(/'&lt;'/ ,"<", :g);
    $body.=subst(/'&quot;'/, '"', :g);
    $body.=subst(/'&amp;'/, '&', :g);
    return $body;
}

# vim: expandtab shiftwidth=4 ft=perl6
