use v6;
use Test;

plan 2;

BEGIN { @*INC.unshift( 'lib' ) }

use App::Pl6anet::HTML;

my $data = {"http://stevemynott.blogspot.com/feeds/posts/default" => {:title("Steve Mynott"), :web("http://stevemynott.blogspot.com/feeds/posts/default"), :content("Now is the time for all good men")}};

my $html = App::Pl6anet::HTML.new( :tmpl('t/index.tmpl'), :$data );

ok $html.so, "got summat";

my $got =  $html.render-html;

my $expected = "<html>\n<head>\n<meta charset=\"utf-8\">\n</head>\n<body>\n<a href=\"http://stevemynott.blogspot.com/feeds/posts/default\">Steve Mynott</a> \nNow is the time for all good men\n</body>\n</html>\n";

is-deeply $got, $expected, "got result" or die $got.gist;
