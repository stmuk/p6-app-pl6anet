use v6;
use Test;

plan 2;

BEGIN { @*INC.unshift( 'lib' ) }

use App::Pl6anet::Cache;

my $cdata = {"http://stevemynott.blogspot.com/feeds/posts/default" => {:title("Steve Mynott"), :web("http://stevemynott.blogspot.com/feeds/posts/default"), :content("Now is the time for all good men")}};
my $cfile ="t/cache.tmp";

my $cache = App::Pl6anet::Cache.new( :$cdata, :$cfile );

ok $cache.so, "got summat";

$cache.make-cache;

my $got = EVALFILE $cfile;

is-deeply $got, $cdata, "got result" or die $got.gist;
