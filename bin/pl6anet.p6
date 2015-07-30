#!/usr/bin/env perl6

use v6;
use XML;
use XML::Parser::Tiny;
use LWP::Simple;
use Data::Dump;
use Net::Curl::Easy;

constant DEBUG = %*ENV<DEBUG>;

my $f = @*ARGS.[0];

die "supply filename" unless $f;

my $cache-f = "cache.pl6"; 

my %feeds = parse-yaml($f);

if DEBUG {
    make-cache(%feeds, $cache-f);
}
else {
    make-cache(%feeds, $cache-f) unless $cache-f.IO.e;
}

my %cache = EVALFILE $cache-f;

say '<html>';
say '<head>';
say '<meta charset="utf-8">';
say '</head>';
say '<body>';
for %cache.keys -> $k {
    #warn Dump %cache{$k};
    say '<a href="'~ $k ~'">'~%cache{$k}<title>~'</a>';
    say %cache{$k}<content>; 
}
say '</body>';
say '</html>';

sub make-cache(%feeds,$f) {

    for %feeds.keys -> $url {
        DEBUG and warn :$url.perl;
        my $resp = Net::Curl::Easy.new(:url($url)).download;
        %feeds{$url}<content> = process-xml( $resp );
        #        DEBUG and last; # XXX
    }

    spurt($f, %feeds.perl);
}

sub get-urls($f) {
    my $xml = slurp 'opml.xml';
    my $parser = XML::Parser::Tiny.new;
    my $tree = $parser.parse($xml);
    my @leafs = $tree<body><data>.values.[1].values.[2].values;
    return @leafs;
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

sub parse-yaml ($f) {
    my $lines = slurp $f or die $!;
    $lines ~~ s:g/\n//;

    my (Any, @lines) = $lines.split("feeds:");
    my (Any, @feeds) = @lines.join.split(" - ");

    my %feed;
    for @feeds -> $feed {
        $feed ~~ / 'url:' \s*(.*?)\s* 'title:' \s* (.*?) \s* 'web:' \s* (.*) \s* /;
        %feed{~$0} = { :title( ~$1), :web( ~$2 ) } ;
    }

    return %feed;
}

# vim: expandtab shiftwidth=4 ft=perl6
