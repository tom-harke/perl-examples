use strict;
use warnings;

use lib ".";
use Curry qw|curry uncurry|;

sub plus {
   my ($x,$y) = @_;
   $x+$y
}

printf "1+2 = %d\n", plus(1,2);

my $cplus = curry(\&plus);
my $incr  = $cplus->(1);
printf "incr(2) = %d\n", $incr->(2);

my $plus = uncurry($cplus);

printf "uncurried/curried: 1+2 = %d\n", $plus->(1,2);
