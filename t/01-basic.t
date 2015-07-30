use v6;
use Test;

plan 2;

BEGIN { @*INC.unshift( 'lib' ) }

use-ok("App::Pl6anet");
use-ok("App::Pl6anet::YAML");

