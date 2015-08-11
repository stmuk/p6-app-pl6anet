use v6;
use Test;

plan 3;

BEGIN { @*INC.unshift( 'lib' ) }

use-ok("App::Pl6anet");
use-ok("App::Pl6anet::YAML");
use-ok("App::Pl6anet::XML");

