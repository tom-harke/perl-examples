# perl-examples
examples in Perl

Curry.{pm,t}
   - keywords: higher order functions
   - generic 'currying' function which converts a multi-argument function into
     a function that takes only the first argument and returns another which
     takes the remaining args
   - uncurry is the inverse of curry

list-{adt,oo}.pl
   - keywords: higher order functions, scott encoding
   - constrasts object-oriented data versus algebraic data
   - takes the simplest non-trivial recursive data type (lists), encodes them
     in both styles and runs the same tests
