use strict;
use warnings;

package Curry;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(|
   curry
   uncurry
|);

sub curry {
   my $func = shift;
   sub {
      my $x = shift;
      sub {
         $func->($x,@_);
      }
   }
}

sub uncurry {
   my $func = shift;
   sub {
      my $x = shift;
      $func->($x)->(@_);
   }
}

1;
