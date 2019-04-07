html {
 head {
  meta[charset="UTF-8"]:
 }
 title: p6-practical-regexes
 link[rel=stylesheet,href="w3.css"]:
 link[rel=stylesheet,href="index.css"]:
 link[rel=styleshieet,href="https://fonts.googleapis.com/css?family=Raleway"]:
 body {
  div.w3-content,w3-display-container,w3-padding,w3-border,w3-card,w3-round-large,w3-margin,full,w3-white {

slide=div.slide,w3-xlarge,w3-display-top,w3-margin {
  big=div.w3-xlarge,w3-display-middle {

      h1.w3-center: Practical Perl 6 Regexes

--

      h3.w3-center {
        Brian Duggan

        small: bduggan@matatu.org

      }

--

      small: DC Baltimore Perl Workshop, April 6, 2019

  }
}

bigslide=div.w3-xxxlarge,w3-display-middle,slide,w3-center {

  p {
    <img.w3-image:logo.png>
  }
}

slide {
  center: Why?
  
  Perl 5 set the standard for regexes BUT

  ul {
    * terse
    * too many special cases
    * "write only"
    * not composable
  }

  Perl 6 regexes
  ul {
    * not as terse
    * consistent
    * more readable
    * first class objects.  Building blocks for grammars.
  }
}

slidem=div.slide,w3-xlarge,w3-display-middle,w3-margin {

  big {
    center: Outline
    ul.w3-ul,w3-border {
      * * Characters *
      * Groups
      * Quantifiers
      * Capturing
      * Composing
    }
  }
}

slide {
right=div.w3-right,w3-small,w3-text-grey: Characters
h2: Question:
Which of these print `True`?  (in Perl 6)

multicode 〈
say so 'abc' =~ /b/

say so 'abc' ~~ /b/

say so 'abc' ~~ / 'b' /

say so 'abc' ~~ regex { b }

my regex letter-b {
   b
}
say so 'abc' ~~ / <letter-b> /
〉

Use `/` or `regex` to make a regex.

}

slide {
right: Characters
h2: Literals

How about these?

multicode 〈
say so 'good' ~~ / good /

say so 'not-good' ~~ / not-good /

say so 'not-good' ~~ / 'not-good' /

say so 'schőn' ~~ / schőn /
〉

Use quotes inside a regex.  *Everything* except *alphanumeric characters* and *underscores* must be quoted.

}

slide {
right: Characters
h2: Spaces

multicode 〈
say so 'abc' ~~ / abc /

say so 'abc' ~~ / a b c /

say so 'a b c' ~~ / a b c /

say so 'a b c' ~~ / 'a b c' /

say so 'a b c' ~~ / a ' ' b ' ' c /

say so 'a b c' ~~ / a \s+ b \s+ c /

say so 'a b c' ~~ / a 
    # hey, this is a comment
    \s+ b \s+ c /

〉

Spaces are not significant.  Neither are comments.

}

slide {
right: Characters
h2: Adverbs

multicode 〈
say so 'a b c' ~~ /a \s* b \s* c/;
say so 'a b c' ~~ /a <ws> b <ws> c/;
say so 'a b c' ~~ /:s a b c/;
say so 'a b c' ~~ /:sigspace a b c/;

say so 'ABC' ~~ /:i b/;
say so 'ABC' ~~ /:ignorecase b/;

say so 'abc' ~~ /:r b/;
say so 'abc' ~~ /:ratchet b/;
〉

Adverbs start with `:`.

Ratcheting makes matching much faster -- no backtracking.

Sigspace improves readability.
}

slide {
right: Characters
h2: Tokens and rules

multicode 〈
say so 'abc' ~~ regex { :r abc }
say so 'abc' ~~ token { abc }

say so 'a b c' ~~ token { :s a b c }
say so 'a b c' ~~ rule { a b c }
〉

A `token` is a regex with ratching.

A `rule` is a token with sigspace.

These are deep concepts!  Tokens and rules are building blocks for
grammars.
}


slide {
right: Characters

h2: Back to basics

Vehicle Identification Numbers

multicode 〈
my $vin = '1FAHP3GNXBW107581';
if $vin ~~ / I | O | Q / {
  say "Invalid VIN"
} else {
  say "Maybe it's okay";
}
〉

For alternation, use `|`.

}

slide {
right: Character classes
h2: TMTOWDI
Alternation

multicode 〈
say so 'QUIT' ~~ / I | O | Q /

say so 'QUIT' ~~ / | I | O | Q /

say so 'QUIT' ~~ / | I
                   | O
                   | Q /

say so 'QUIT' ~~ / <[IOQ]> /

〉

You can put an extra `|` at the beginning.

Construct character classes using `<[` and `]>`.

}


slide {
right: Character classes
h2: Character classes

multicode 〈
say so 'e' ~~ / <[a e i o u]> /

say so 'b' ~~ / <[a..e]> /

my regex vowels { <[a e i o u]> }
say so 'e' ~~  / <vowels> /;

〉

Put lists of characters or ranges in character classes.

Spaces can be in character classes.

}

slide {
right: Character classes
h2: Negate Character classes

multicode 〈
my regex not-vowels {
  <-[aeiou]>
}
say so 'x' ~~ / <not-vowels> /;
say so '!' ~~ / <not-vowels> /;

my regex consonants {
 <[a..z] - [aeiou]>
}
say so '!' ~~ / <consonants> /;
say so 'x' ~~ / <consonants> /;

〉

Take the complement of a character class `<-[` ... `]>`.

Or use `-` to take the set difference.

}

slidem {

  big {
    center: Outline
    ul.w3-ul,w3-border {
      * Characters
      * * Groups *
      * Quantifiers
      * Capturing
      * Composing
    }
  }
}

slide {
 right: Groups
 h2: Grouping

Brackets make a non-capturing group.

multicode 〈
say so 'sat, apr 6' ~~ /
  [ sat | sun ] ', '
  [ mar | apr | may ]
  <[0..9]> 
 /
〉

Like `(?:...)` from Perl 5.
}

slide {
 right: Groups
 h2: Grouping

| Digression -- why did that not match?

multicode 〈
say so 'sat, apr 6' ~~ / 'sat, apr 6' /

say so 'sat, apr 6' ~~ / 'sat, ' 'apr ' '6' /

say so 'sat, apr 6' ~~ / sat ', ' apr ' ' 6 /

say so 'sat, apr 6' ~~ /
   [ sat | sun ] ', '
   [ mar | apr | may ]
   ' '
   <[0..9]> /
〉
}

slide {
 right: Groups
 h2: Grouping

| Spot the difference

multicode 〈
say so 'sat, apr 6' ~~ /
  [ sat | sun ] ', '
  [ mar | apr | may ]
  <[0..9]> 
 /

say so 'sat, apr 6' ~~ /
   [ sat | sun ] ', '
   [ mar | apr | may ]
   ' '
   <[0..9]>
 /
〉
}

slide {
 right: Groups
 h2: Anyway, back to groups
multicode 〈
say so 'sat, apr 6' ~~ /
   < sat sun> ', '
   < mar apr may>
   ' '
   <[0..9]>
 /
〉

Start `< ` `>` with a space to make a word list.
}

slide {
 right: Groups
 h2: As usual, tmtowtdi
multicode 〈
my @days = <sat sun>;
my @months = <mar apr may>;
say so 'sat, apr 6' ~~ /
   @days ', ' @months ' '
   <[0..9]>
 /
〉

Or use an array.  Scalar are interpolated too, btw.

How about two digit days?
}

slidem {

  big {
    center: Outline
    ul.w3-ul,w3-border {
      * Characters
      * Groups
      * * Quantifiers *
      * Capturing
      * Composing
    }
  }
}

slide {
 right: Quantifiers
 h2: Quantifiers
multicode 〈
say so 'a' ~~ / a? /; # 0 or 1

say so 'a' ~~ / a* /; # 0 or more

say so 'a' ~~ / a+ /; # 1 or more

say so 'a' ~~ / a**2 /; # exactly 2

say so 'a' ~~ / a**1..5 /; # 1 to 5
〉

Use `?`, `*`, and `+` as usual.

Use `**` (exponentiation) for values or ranges.

}

slide {
 right: Quantifiers
 h2: Quantifiers
multicode 〈
my @days = <sat sun>;
my @months = <mar apr may>;
say so 'sat, apr 6' ~~ /
   @days ', ' @months ' '
   <[0..9]> ** 1..2
 /
〉
}

slide {
 right: Quantifiers
 h2: Modified Quantifiers
multicode 〈
my regex part { <-[/]>+ }
my regex path { '/' [ <part> '/' ]* <part> }
say so '/home/brian/talk.txt' ~~ / <path> /

my regex part { <-[/]>+ }
my regex path { '/' <part>* % '/' }
say so '/home/brian/talk.txt' ~~ / <path> /;
〉

| "separated by" `A* % B` is a shorthand for `[ AB ]* A?`.

Works for other quantifiers too (`+`, `**`)

Useful with `,`.

See also `%%`.

}

slidem {

  big {
    center: Outline
    ul.w3-ul,w3-border {
      * Characters
      * Groups
      * Quantifiers
      * * Capturing *
      * Composing
    }
  }
}

slide {
 right: Capturing
 h2: Capturing
multicode 〈
say 'abc' ~~ / abc /;
〉

multicode 〈
my $match = 'abc' ~~ / abc /;
say $match.WHAT;
〉

A match returns a match object.

multicode 〈
'abc' ~~ / abc/;
say $/.WHAT;
say $/;
〉

The most recent match is stored in `$/`.

Use `say` to print `$/.gist` which provides the match tree.
}

slide {
 right: Capturing
 h2: Captures
multicode 〈
'hello, world' ~~ /^ [ <-[,]>+ ] ', ' (.*) $/;
say $/;
〉

Parentheses will capture.

multicode 〈
'hello, world' ~~ /^ [ <-[,]>+ ] ', ' (.*) $/;
say $/[0];
say ~$/[0];
〉

You can get positional captures by treating `$/` like an array.

Stringify with `~`.
}

slide {
 right: Capturing
 h2: Named Captures
multicode 〈
my regex word { <-[,]>+ }
'hello, world' ~~
  /^ <word> ', ' (.*) $/;
say $/;
〉

Named captures use the names of embedded regexes.

The match tree can help.
}

slide {
 right: Capturing
 h2: Named Captures
multicode 〈
my regex word { <-[,]>+ }
'hello, world' ~~
  /^ <word> ', ' (.*) $/;
say $/{'word'};
say $/<word>;
say $<word>;   # all the same
〉

When accessing named captures in `$/`, you can omit the `/`.
}

slide {
 right: Capturing
 h2: Named Captures
multicode 〈
my regex word { <-[,]>+ }
'hello, world' ~~
  /^ <word> ', ' <word> $/;
say $<word>;
say $<word>[0];
〉

It's matches all the way down.
}

slide {
 right: Capturing
 h2: Named Captures
multicode 〈
my regex word { <-[,]>+ }
say 'new york, new york' ~~
  /^ <word> ', ' $<word> $/;
〉

You can interpolate the match variable in the regex
to be clever.
}

slide {
 right: Capturing
 h2: Named Captures
multicode 〈
my regex word { <-[,]>+ }
say 'oh, ho' ~~
/^ <word> ', ' <{ $<word>.flip }> $/;
〉

You can even put code in the regex if you want to be very
clever.
}

slide {
 right: Capturing
 h2: Restricted Captures

multicode 〈
my regex char {
 <-["]> | '\"' 
}
my regex quoted {
   '"' <char>* '"'
}
'a "good" program' ~~ / <quoted> /;
say ~$<quoted>;
〉

}

slide {
 right: Capturing
 h2: Restricted Captures

multicode 〈
my regex char {
 <-["]> | '\"' 
}
my regex quoted {
   '"' <( <char>* )> '"'
}
'a "good" program' ~~ / <quoted> /;
say ~$<quoted>;
〉

Pro tip: use `<(` and `>)` to restrict the entire match.
}

slidem {

  big {
    center: Outline
    ul.w3-ul,w3-border {
      * Characters
      * Groups
      * Quantifiers
      * Capturing
      * * Composing *
    }
  }
}

slide {
  right: Composing
  h2: Grammars

multicode 〈
grammar G {
  regex TOP { 'a ' <quoted> ' program' }
  regex letters { <[a..z]>+ }
  regex quoted {
     '"' <( <letters> )> '"'
  }
}
say G.parse('a "good" program');
〉

Put regexes together into grammars.
}

slide {
  right: Composing
  h2: Grammars
multicode 〈
grammar G {
  rule TOP { a <quoted> program }
  token letters { <[a..z]>+ }
  token quoted {
     '"' <( <letters> )> '"'
  }
}
say G.parse('a "good" program');
〉

Reminders --

Use `token` for regexes that don't need backtracking.

Use `role` for tokens with sigspace.
}

slide {
  right: Composing
  h2: Grammars

  Examples on modules.perl6.org and docs.perl6.org.

  Also <JSON-Tiny:https://github.com/moritz/json/blob/master/lib/JSON/Tiny/Grammar.pm>

  Or <Protobuf:https://github.com/bduggan/p6-protobuf/blob/master/protobuf.pm6> (EBNF).

  Have fun!
}


bigslide {

The End
}

footer.w3-display-bottommiddle {
  div#page: 1
}

}

script[type="text/javascript",src="index.js"]:

}
}

