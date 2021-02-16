use strict;
use warnings;

my $n = 36;

#my $memos = {}; # UNCOMMENT ALL 3 FOR SPEED
sub fibonacci {
   my $in = shift;
   #return $memos->{$in} if defined $memos->{$in}; # UNCOMMENT ALL 3 FOR SPEED
   my $out
         = $in<2
         ? $in
         : fibonacci($in-1) + fibonacci($in-2)
         ;
   #$memos->{$in} = $out; # UNCOMMENT ALL 3 FOR SPEED
   return $out;
}

printf "fibonacci($n) = %d\n", fibonacci($n);
