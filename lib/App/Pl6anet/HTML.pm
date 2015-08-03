use v6;
use Template::Mojo;

role App::Pl6anet::HTML {

    #    subset File of Str where -> $x { so $x && $x.IO.e };
    has Str  $.tmpl;
    #    has Hash  %.data;

    method render-html(%data) {
        my $f = slurp $.tmpl;
        my $t = Template::Mojo.new($f);
        my $html =  $t.render( %data );
        return $html;
    }

}

# vim: expandtab shiftwidth=4 ft=perl6
