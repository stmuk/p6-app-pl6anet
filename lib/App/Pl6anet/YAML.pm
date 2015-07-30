use v6;

role App::Pl6anet::YAML {

    subset File of Str where -> $x { so $x && $x.IO.e };
    has File  $.file;

    method parse {

        my $lines = slurp $.file or die $!;
        $lines ~~ s:g/\n//;

        my (Any, @lines) = $lines.split("feeds:");
        my (Any, @feeds) = @lines.join.split(" - ");

        my %feed;
        for @feeds -> $feed {
            $feed ~~ / 'url:' \s*(.*?)\s* 'title:' \s* (.*?) \s* 'web:' \s* (.*) \s* /;
            %feed{~$0} = { :title( ~$1), :web( ~$2 ) } ;
        }

        return %feed;
    }

}

# vim: expandtab shiftwidth=4 ft=perl6
