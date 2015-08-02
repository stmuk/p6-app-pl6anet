use v6;
use Test;

plan 2;

BEGIN { @*INC.unshift( 'lib' ) }

use App::Pl6anet::Cache;

my $data = {"http://stevemynott.blogspot.com/feeds/posts/default" => {:title("Steve Mynott"), :web("http://stevemynott.blogspot.com/feeds/posts/default"), :content("Now is the time for all good men")}};
my $file ="t/cache.tmp";

my $cache = App::Pl6anet::Cache.new( :$data, :$file );

ok $cache.so, "got summat";

$cache.make-cache;

my $got = EVALFILE $file;

is-deeply $got, $data, "got result" or die $got.gist;
