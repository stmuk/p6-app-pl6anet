use v6;
use XML;
use Net::Curl::Easy;

constant DEBUG = %*ENV<DEBUG>;

role App::Pl6anet::Cache {

    has Str $.cfile;

    method cached(%data) {

        return EVALFILE $.cfile if $.cfile.IO.e; # cache hit

        for %data.keys -> $url {
            DEBUG and warn :$url.perl;
            my $resp = Net::Curl::Easy.new(:url($url)).download;
            my $xml = from-xml($resp);
            %data{$url}<content> = get-content( $xml );
            %data{$url}<updated> = get-updated( $xml );
        }

        spurt($.cfile, %data.perl);

        return %data;
    }

    # TODO refactor into XML
    sub get-updated($xml) {

        my $updated;
        if  ($updated = $xml.getElementsByTagName("updated")).so  {
            $updated =  $updated.[0].contents.Str;
        } 

        DEBUG and warn "STM: ", :$updated.perl;

        return $updated;

    }

    sub get-content($xml) {

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
