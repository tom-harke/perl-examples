# TODO:
#  - make lazy
#     - ones, fib, hamming
#  - add checks to [Cc]ons/[Nn]il ensuring 2/0 args
#  - add 'else'
#
# 
# Notes:
#  - last item in a sub is the return value, even if there is no explicit return
#  - @_ can be coerced into a hash
#  - hashes are used for Nil/Cons because order does not matter
#  - pop vs shift
#  - shift can be used in an expression
#     - eliminates need for a variable name
#     - analogous to '0 < $i--'
#  - the idiom 'sub foo (&) {...}' allows us to abbreviate 'foo sub {...}' as 'foo {...}'
use strict;
use warnings;

# Constructors
sub cons { my @args = @_; sub { return {@_}->{cons}(@args) } }
sub nil  { my @args = @_; sub { return {@_}->{nil} (@args) } }

# Pattern Matching
# These thingies take a block of code & wrap them up into 1 key/value pair
sub Cons (&) { cons => shift }
sub Nil  (&) { nil  => shift }


sub len {
   shift->(
      Nil  { 0 },
      Cons { shift; 1+len(shift) },
   )
}

sub convert {
   shift->(
      Nil  { () },
      Cons { (shift,convert(shift)) },
   )
}


sub app {
   my $fst = shift;
   my $snd = shift;
   $fst->(
      Nil  { $snd },
      Cons { cons(shift,app(shift,$snd)); },
   )
}

sub rev {
   sub worker {
      my $list = shift;
      my $acc  = shift;
      $list->(
         Nil  { $acc },
         Cons { worker(pop, cons(pop,$acc)) },
      )
   }
   worker(shift,nil())
}

sub evens {
   shift->(
      Nil  { nil() },
      Cons {
         cons(shift,
            shift->(
               Nil  { nil() },
               Cons { evens(pop) },
            )
         )
      }
   )
}

sub odds { evens(tail(shift)) }

sub weave {
   # Example
   #   weave( [a,b,c], [0,1,2,3] )
   # produces
   #   [a,0,b,1,c,2,3]
   my $evens = shift; # list which will occupy the even positions in the output
   my $odds  = shift; # list which will occupy the odd  positions in the output
   $evens->(
      Nil  { $odds },
      Cons { cons(shift,weave($odds,shift)) }
   )
}

sub take {
   my $count = shift;
   my $list  = shift;
   $list->(
      Nil  { nil() },
      Cons {
         if (0 < $count--) {
            cons(shift,take($count,shift))
         } else {
            nil()
         }
      }
   )
}

sub tail ($) {
   shift->(
      Nil  { nil() },
      Cons { pop },
   )
}

sub to_list {
   my $acc = nil();
   $acc = cons(pop,$acc) while @_;
   $acc
}


my $alphabet = to_list(qw|a b c d e f g h i j k l m n o p q r s t u v w x y z|);
my $digits   = to_list(qw|0 1 2 3 4 5 6 7 8 9|);

print convert(cons('A', cons('B', cons('C', nil())))), "\n";
print len($alphabet),                    "\n";
print convert($digits),                  "\n";
print convert(rev($digits)),             "\n";
print convert(app($digits,$digits)),     "\n";
print convert(evens($alphabet)),         "\n";
print convert(odds($alphabet)),          "\n";
print convert(weave($alphabet,$digits)), "\n";
print convert(weave($digits,$alphabet)), "\n";
print convert(tail(tail($digits))),      "\n";
print convert(take(5,$digits)),          "\n";
print convert(take(15,$digits)),         "\n";


sub fold (&&) {
   my $nfun  = shift;
   my $cfun = shift;
   sub {
      shift->(
         Nil  { $nfun->() },
         Cons {
            my ($h,$t) = @_;
            $cfun->($h,fold->($nfun,$cfun)->($t))
         },
      )
   }
}

my $len2 =
   fold(
      sub { 0; },
      sub { my ($h,$ft) = @_; 1+$ft }
   );

my $convert2 =
   fold(
      sub { ();},
      sub { my ($h,@ft) = @_; ($h,@ft) }
   );

print "fold length of alphabet: ", $len2->($alphabet),   "\n";
print "fold length of digits: ",   $len2->($digits),     "\n";
print "fold convert digits: ",     $convert2->($digits), "\n";


# TODO: add laziness so that the following works:
# sub ones { cons(1,ones()); }
# print convert(take(5,ones->())), "\n";
