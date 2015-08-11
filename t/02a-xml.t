use v6;
use Test;

plan 2;

BEGIN { @*INC.unshift( 'lib' ) }

use App::Pl6anet::XML;

my $src = slurp 't/brentlaabs.xml';

my $xml = App::Pl6anet::XML.new( :xml($src));

ok $xml.so, "got summat";

say $xml.get-content;
say $xml.get-updated;

#my $expected = {"http://stevemynott.blogspot.com/feeds/posts/default" => {:title("Steve Mynott"), :web("http://stevemynott.blogspot.com/feeds/posts/default")}};
#
#is-deeply $got, $expected, "got result";

