use v6;
use Test;

plan 2;

BEGIN { @*INC.unshift( 'lib' ) }

use App::Pl6anet::HTML;

my $data = {"http://stevemynott.blogspot.com/feeds/posts/default" => {:title("Steve Mynott"), :web("http://stevemynott.blogspot.com/feeds/posts/default"), :content("Now is the time for all good men")}};

my $html = App::Pl6anet::HTML.new( :tmpl('t/index.tmpl') );

ok $html.so, "got summat";

my $got =  $html.render-html($data);

my $expected = "<?xml version=\"1.0\"?><html> <head> <meta charset=\"utf-8\"/>  </head>  <body> <a href=\"http://stevemynott.blogspot.com/feeds/posts/default\">Steve Mynott</a>  Now is the time for all good men </body>  </html>";

is-deeply $got, $expected, "got result" or die $got.gist;
