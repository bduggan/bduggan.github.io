#!/usr/bin/env perl6

use Text::Markdown;

my $data = $*ARGFILES.slurp;
say Text::Markdown.new($data).render;


