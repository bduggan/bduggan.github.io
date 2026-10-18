use Color::Names::CSS3;
use Color::Names::Crayola;
use Color::Names::FS595B;
use Color::Names::FS595C;
use Color::Names::NBS;
use Color::Names::NCS;
use Color::Names::RAL-CL;
use Color::Names::RAL-DSP;
use Color::Names::Resene;
use Color::Names::X11-Grey;
use Color::Names::X11;
use Color::Names::XKCD;

my %groups =
  'CSS3'     => Color::Names::CSS3.color-data,
  'Crayola'  => Color::Names::Crayola.color-data,
  'FS595B'   => Color::Names::FS595B.color-data,
  'FS595C'   => Color::Names::FS595C.color-data,
  'NBS'      => Color::Names::NBS.color-data,
  'NCS'      => Color::Names::NCS.color-data,
  'RAL-CL'   => Color::Names::RAL-CL.color-data,
  'RAL-DSP'  => Color::Names::RAL-DSP.color-data,
  'Resene'   => Color::Names::Resene.color-data,
  'X11-Grey' => Color::Names::X11-Grey.color-data,
  'X11'      => Color::Names::X11.color-data,
  'XKCD'     => Color::Names::XKCD.color-data;

sub color-count($group) is export {
  %groups{$group}.elems
}

sub color-groups is export {
  %groups.keys.sort
}

# number of pages in a group, $per colors per page
sub page-count(Str $group, $per = 20) is export {
  (%groups{$group}.elems + $per - 1) div $per
}

# color keys on page $page (1-based) of a group, in sorted order
sub color-page(Str $group, $page = 1, $per = 20) is export {
  my @keys = %groups{$group}.keys.sort;
  my $start = ($page - 1) * $per;
  @keys[$start ..^ min($start + $per, @keys.elems)]
}

sub color-name(Str $group, Str $key) is export {
  %groups{$group}{$key}<name> // $key
}

sub color-hex(Str $group, Str $key) is export {
  my ($r, $g, $b) = %groups{$group}{$key}<rgb>;
  sprintf '#%02x%02x%02x', $r, $g, $b;
}

sub color-contrast(Str $group, Str $key) is export {
  my ($r, $g, $b) = %groups{$group}{$key}<rgb>;
  my $luma = 0.2126 * $r + 0.7152 * $g + 0.0722 * $b;
  return $luma > 128 ?? '#000000' !! '#ffffff';
}


sub color-info(Str $group, Str $key) is export {
  %(
    name => color-name($group, $key),
    hex  => color-hex($group, $key),
    contrast => color-contrast($group, $key),
  )
}
1;
