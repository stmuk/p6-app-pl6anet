use v6;
use Test;
plan 1;

shell "perl6 -Ilib ./bin/pl6anet.p6 t/perlanetrc > t/index2.html";

ok qx!diff t/index.html t/index2.html! eq '', "no diffs";
