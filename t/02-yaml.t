use v6;
use Test;

plan 2;

BEGIN { @*INC.unshift( 'lib' ) }

use App::Pl6anet::YAML;

my $yaml = App::Pl6anet::YAML.new( :file('t/testrc') );

ok $yaml.so, "got summat";

my $got =  $yaml.parse-yaml;

my $expected = {"http://stevemynott.blogspot.com/feeds/posts/default" => {:title("Steve Mynott"), :web("http://stevemynott.blogspot.com/feeds/posts/default")}};

is-deeply $got, $expected, "got result";

