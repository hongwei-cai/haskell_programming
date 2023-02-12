-- 2.1 Glasgow Haskell Compiler
{- Glasgow Haskell Compiler, a state-of-the-art, open source implementation of Haskell. The system has two main components: a batch compiler called GHC, and an interactive interpreter called GHCi. -}


-- 2.2 Installing and starting
-- http.//www.haskell.org


-- 2.3 Standard prelude
{-
        head
        tail
        take
        drop
        length
        sum
        product
        ++
        reverse
-}

-- 2.4 Function application
{-
function application has higher priority than all other operators in the language.

    Mathematics     Haskell
    f(x)            f x
    f(x,y)          f x y
    f(g(x))         f (g x)
    f(x,g(y)        f x (g y)
    f(x)g(y)        f x * g y
-}

-- 2.5 Haskell scripts

factorial n = product [1..n]

average ns = sum ns `div` length ns

{-
    Command             Meaning
    :load name          load script name
    :reload             reload current script
    :set editor name    set editor to name
    :edit name          edit script name
    :edit               edit current script
    :type expr          show type of expr
    :?                  show all commands
    :quit               quit GHCi

-- Naming requirements

    myFun
    fun1
    arg_2
    x'

-- keywords

    case    class   data    default     deriving
    do      else    foreign if      import      in
    infix   infixl  infixr  instance    let
    module  newtype of      then    type    where


-- By convention, list arguments in Haskell usually have the suffix 's' on their name to indicate that they may contain multiple values.

    - a list of numbers might be named "ns".
    - a list of arbitrary values might be named "xs".
    - a list of lists of characters might be named "css".

-}


-- The layout rule

a = b + c
    where
        b = 1
        c = 2
d = a * 2


{-
a = b + c
    where
        {b = 1;
        c = 2};
d = a * 2

a = b + c where {b = 1; c = 2}; d = a * 2


-- Tabs
-- Haskell assumes that tab stops are 8 characters wide.
    
-- Commants

    - Ordinary comments begin with the symbol -- and extend to the end of the current line
    - Nested comments begin and end with the symbol {- and -}. 
-}
