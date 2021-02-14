use strict;
use warnings;

# TODO:
#   - find OO version of Cata

package List;

   sub rev {
      my $self = shift;
      $self->rev_worker(Nil->new());
   }


package Cons;
   @Cons::ISA = ('List');

   sub new {
      my ($class,$head,$tail) = @_;
      my $self = bless {
         head => $head,
         tail => $tail, 
      }, $class;
   }

   sub len {
      my $self = shift;
      1 + $self->{tail}->len();
   }

   sub convert {
      my $self = shift;
      ($self->{head}, $self->{tail}->convert());
   }

   sub rev_worker {
      my ($self,$acc) = @_;
      $self->{tail}->rev_worker( Cons->new($self->{head}, $acc ) );
   }

   sub app {
      my ($self,$snd) = @_;
      Cons->new( $self->{head}, $self->{tail}->app($snd) );
   }

   sub evens {
      my ($self) = @_;
      Cons->new( $self->{head}, $self->{tail}->odds() );
   }

   sub odds {
      my ($self) = @_;
      $self->{tail}->evens();
   }

   sub weave {
      my ($evens,$odds) = @_;
      Cons->new( $evens->{head}, $odds->weave($evens->{tail}) )
   }

   sub drop {
      my ($self,$count) = @_;
      if (0 < $count--) {
         $self->{tail}->drop($count)
      } else {
         $self
      }
   }

   sub take {
      my ($self,$count) = @_;
      if (0 < $count--) {
         Cons->new( $self->{head}, $self->{tail}->take($count) )
      } else {
         Nil->new()
      }
   }

   sub fold {
      my ($self,$nil,$cons) = @_;
      $cons->($self->{head}, $self->{tail}->fold($nil,$cons))
   }

package Nil;
   @Nil::ISA = ('List');

   sub new {
      my ($class) = @_;
      my $self = bless {}, $class;
   }

   sub len     { 0 }
   sub convert { () }

   sub rev_worker {
      my ($self,$acc) = @_;
      $acc;
   }

   sub app {
      my ($self,$snd) = @_;
      $snd;
   }

   sub evens { shift }
   sub odds  { shift }

   sub weave {
      my ($evens,$odds) = @_;
      $odds;
   }

   sub drop { shift }
   sub take { shift }

   sub fold {
      my ($self,$nil,$cons) = @_;
      $nil->();
   }


package Util;

   sub to_list {
      my $acc = Nil->new();
      $acc = Cons->new(pop,$acc) while @_;
      $acc
   }


package Examples;

my $nil = Nil->new();
my $x   = Cons->new('x',Nil->new());

print $nil->len(),   "\n";
print $x->len(),     "\n";
print $x->convert(), "\n";

my $alphabet = Util::to_list(qw|a b c d e f g h i j k l m n o p q r s t u v w x y z|);
my $digits   = Util::to_list(qw|0 1 2 3 4 5 6 7 8 9|);

print Cons->new('A', Cons->new('B', Cons->new('C', Nil->new())))->convert(), "\n";
print $alphabet->len(),                     "\n";
print $digits->convert(),                   "\n";
print $digits->rev()->convert(),            "\n";
print $digits->app($digits)->convert(),     "\n";
print $alphabet->evens()->convert(),        "\n";
print $alphabet->odds()->convert(),         "\n";
print $alphabet->weave($digits)->convert(), "\n";
print $digits->weave($alphabet)->convert(), "\n";
print $digits->drop(5)->convert(),          "\n";
print $digits->take(5)->convert(),          "\n";
print $digits->take(15)->convert(),         "\n";

print $alphabet->fold( sub {0},  sub { my ($h,$t) = @_; 1+$t    } ), "\n";
print $digits->fold(   sub {()}, sub { my ($h,@t) = @_; ($h,@t) } ), "\n";
