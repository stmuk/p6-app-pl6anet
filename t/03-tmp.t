use v6;
use Test;

shell "perl6 -Ilib ./bin/pl6anet.p6 t/perlanetrc > t/index2.html";

ok qx!diff t/index*! eq '', "no diffs";
