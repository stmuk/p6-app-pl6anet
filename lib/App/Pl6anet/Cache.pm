use v6;
use XML;
use Net::Curl::Easy;

constant DEBUG = %*ENV<DEBUG>;

role App::Pl6anet::Cache {

    has Hash %.data;
    has Str $.file;

    method make-cache {
        my %data = %.data;

        for %data.keys -> $url {
            DEBUG and warn :$url.perl;
            my $resp = Net::Curl::Easy.new(:url($url)).download;
            %data{$url}<content> = process-xml( $resp );
        }

        spurt($.file, %data.perl);
        return %data;
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

}

# vim: expandtab shiftwidth=4 ft=perl6
