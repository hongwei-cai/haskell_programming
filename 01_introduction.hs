-- 1.1 Functions
{-
In Haskell, a function is a mapping that takes one or more arguments and 
produces a single result, and is defined using an equation that gives a name 
for the function, a name for each of its arguments, and a body that specifies 
how the result can be caculated in terms of the arguments.

the order in which functions are applied in a calculation does not affect the 
value of the final result, but it may affect the number of steps required, and 
whether the calculation process terminates.
-}


-- 1.2 Functional programming
{-
Functional programming can be viewed as a style of programming in which the 
basic method of computation is the application of functions to arguments.

programming languages such as Java in which the basic method of computation is 
changing stored values are called "inperative" languages, because programs in 
such languages are constrcted from imperative instructions that specify 
precisely how the computation should proceed.

Many imperative languages do not encourage programming in the functional style.
-}


-- 1.3 Features of Haskell

{-
   - Concise programs
   - Powerful type system
   - List comprehensions
   - Recursive functions
   - Higher-order functions
   - Effectful functions
   - Generic functions
   - Lazy evaluation
   - Equational reasoning

-}


-- 1.4 Historical background


-- 1.5 A taste of Haskell

-- Summing numbers
sum' [] = 0
sum' (n:ns) = n + sum' ns

-- Sorting values
qsort [] = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
        where
                smaller = [a | a <- xs, a<= x]
                larger = [b | b <- xs, b > x]

-- Sequencing actions
seqn [] = return []
seqn (act:acts) = do x <- act
                     xs <- seqn acts
                     return (x:xs)

{- Being able to define generic functions such as seqn that can be used with 
different kinds of effects is a key feature of Haskell. -}
