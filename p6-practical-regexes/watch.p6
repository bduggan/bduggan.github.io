#!/usr/bin/env perl6

loop {
  say "waiting";
  react whenever 'index.mt'.IO.watch {
    sleep 0.2;
    say "building";
    shell "make";
    done;
  }
}
