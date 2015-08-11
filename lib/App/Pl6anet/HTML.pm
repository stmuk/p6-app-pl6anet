use v6;
use Template::Mojo;
use HTML::Restrict;

role App::Pl6anet::HTML {

    #    subset File of Str where -> $x { so $x && $x.IO.e };
    has Str  $.tmpl;

    method render-html(%data) {
        my $f = slurp $.tmpl;
        my $t = Template::Mojo.new($f);
        my $html =  $t.render( %data );
        #my $hr = HTML::Restrict.new;
        #my XML::Document $doc = $hr.process(:$html);
        #$html = $doc.gist;
        return $html;
    }

}

# vim: expandtab shiftwidth=4 ft=perl6
