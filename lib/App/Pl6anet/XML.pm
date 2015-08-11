use v6;
use XML;

constant DEBUG = %*ENV<DEBUG>;

role App::Pl6anet::XML {
    has Str $.xml;

    method get-updated {
        my $xml = from-xml($.xml);

        my $updated;
        if  ($updated = $xml.getElementsByTagName("updated")).so  {
            $updated =  $updated.[0].contents.Str;
        } 

        DEBUG and warn "STM: ", :$updated.perl;

        return $updated;

    }

    method get-content {
        my $xml = from-xml($.xml);

        my $content;
        if  ($content = $xml.getElementsByTagName("content")).so  {
            $content =  $content.[0].contents;
            warn "STM", :$content.gist;
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
        #        $content = unescape($content);
        DEBUG and warn :$content.perl;
        return $content;
    }
}
