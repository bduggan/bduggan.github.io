#!/usr/bin/env rakupp

use lib $?FILE.IO.parent.Str;

use Webraku;
use deps;

stylesheet 'style.css'.IO.slurp;

page '/', :title('colors'), {
  my $note;
  my $picker;
  my $groups;
  my ($prev-top, $next-top, $prev-bottom, $next-bottom);
  my $active-group;
  my $active-color;
  my $group-info;
  my $range;
  my $pager;
  my $default-group = 'XKCD';
  my $per-page = 100;
  my %page-of;   # group => current page, remembered when switching groups

  my $page = main {
    span 'Browse named colors, from ';

    a( :href<https://raku.land/zef:thundergnat/Color::Names>, 'Color::Names') ~ '.';

    br;

    $groups = span :class<groups>, { };
    hr;

    span 'Click a color to change the background.';
    hr;

    div {
      my $g = $active-group.?text // $default-group;
      $group-info = h3 "group: $g";
      $range = span :class<range>, "showing 1 to { min($per-page, color-count($g)) } of { color-count($g) }";
    }

    div :class<pager-row>, {
      $pager = span :class<pager>, { };
    }

    div :class('step-row top'), {
      $prev-top = button '« prev', :class<prev>;
      $next-top = button 'next »', :class<next>;
    }

    $picker = span :class<picker>, { };

    div :class('step-row bottom'), {
      $prev-bottom = button '« prev', :class<prev>;
      $next-bottom = button 'next »', :class<next>;
    }

    $note = pre '';

    hr;
  }

  sub show-colors {
   my $g = $active-group.text;
   my $p = %page-of{$g} // 1;
   color-page($g, $p, $per-page).map: -> $key {
     my $info = color-info($g, $key);
     my ($name, $bg, $fg) = ($info<name hex contrast>);

     my $b = button :style<<background-color: $bg; color: $fg;>>, $name;
     $b.clicks.tap: {
       .set('class', '') with $active-color;
       $active-color = $b.set('class', 'active');
       $page.set('style', "background-color: $bg; color: $fg");
       $note.text = "set to $bg ($name from $g)";
     }
   }
  }

  # "showing X to Y of Z" for the current page
  sub show-range {
   my $g = $active-group.text;
   my $p = %page-of{$g} // 1;
   my $total = color-count($g);
   my $first = ($p - 1) * $per-page + 1;
   my $last = min($p * $per-page, $total);
   $range.text = "showing $first to $last of $total";
  }

  # a link per page; the current one is highlighted
  sub show-pager {
   my $g = $active-group.text;
   my $p = %page-of{$g} // 1;
   (1 .. page-count($g, $per-page)).map: -> $n {
     my $b = button "$n", :class($n == $p ?? 'page active' !! 'page');
     $b.clicks.tap: { go-to-page($n) }
   }
  }

  sub show-page {
   show-range();
   render-list $pager, { show-pager() }
   render-list $picker, { show-colors() }
  }

  sub go-to-page($n) {
   my $g = $active-group.text;
   return if $n < 1 || $n > page-count($g, $per-page);
   %page-of{$g} = $n;
   show-page();
  }

  sub turn-page($delta) {
   go-to-page((%page-of{$active-group.text} // 1) + $delta);
  }

  sub show-groups {
   color-groups.map: -> $g {
     my $b = button $g, :class<group>;
     unless $active-group {
       $active-group = $b.set('class', 'group active') if $g eq $default-group;
     }
     $b.clicks.tap: {
       .set('class', 'group') with $active-group;
       $active-group = $b.set('class', 'group active');
       $group-info.text = "group: " ~ $active-group.text;
       show-page()
     }
   }
  }

  react {
    whenever after(0) {
      render-list $groups, { show-groups() }
      show-page()
    }
    whenever $prev-top.clicks    { turn-page(-1) }
    whenever $next-top.clicks    { turn-page(1) }
    whenever $prev-bottom.clicks { turn-page(-1) }
    whenever $next-bottom.clicks { turn-page(1) }
  }
}

serve;
