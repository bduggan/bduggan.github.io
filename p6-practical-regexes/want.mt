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
    * not composable
    * inconsistent -- too many special cases
    * encourage writability
  }

  Perl 6 regexes
  ul {
    * not as terse
    * composable -- building blocks for parsing (grammars)
    * consistent
    * encourage readability
  }

}

slidem=div.slide,w3-xlarge,w3-display-middle,w3-margin {

  big {
    center: Outline
    ul.w3-ul,w3-border {
      * * Character Classes *
      * Groups
      * Quantifiers
      * Capturing
      * Composing
    }
  }
}

slide {
label=div.w3-right,w3-small,w3-text-grey: Character classes
h2: Question:
Which of the following prints `True`?  (in Perl 6)

multicode 〈
say so 'b' =~ / [a-z] /

say so 'b' ~~ / <[a-z]> /

say so 'b' ~~ / <[a..z]> /
〉

}

slide {
label: Character classes
h2: Explanation

multicode 〈
say so 'b' ~~ / <[a..z 0..9 A..Z _]> /

say so 'b' ~~ / <[a b c]> /

say so 'b' ~~ / <[a b & = . -]> /
〉

}


bigslide {
The End
}

footer.w3-display-bottommiddle {
  div#page: 1
}

script[type="text/javascript",src="index.js"]:
script[type="text/javascript",src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js"]:

}}}

