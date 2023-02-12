-- 4.1 New From Old
-- Decide if an integer is even:
even :: Integral a => a -> Bool
even n = n `mod` 2 == 0

-- Split a list at the nth element:
splitAt :: Int -> [a] -> ([a],[a])
splitAt n xs = (take n xs, drop n xs)

-- Reciprocation:
recip :: Fractional a => a -> a
recip n = 1/n


-- 4.2 Conditional Expressions
abs :: Int -> Int
abs n = if n >= 0 then n else -n

signum :: Int -> Int
signum n = if n < 0 then -1 else
        if n == 0 then 0 else 1


-- 4.3 Guarded equations
abs_g n | n >= 0        = n
        | otherwise     = -n

{- The symbol | is read as such that 
-- the guard otherwise is defined in the standard prelude simply by 
   otherwise = True -}

signum_g n | n < 0      = -1
           | n == 0     = 0
           | otherwise  = 1


-- 4.4 Pattern matching
not :: Bool -> Bool
not False = True
not True = False

(&&) :: Bool -> Bool -> Bool
True && True = True
_ && _ = False

        {- True && b = b
           False && _ = False -}

{-Haskell does not permit the same name to be used for more than one 
argument in a single equation.
        -- invalid
                b && b = b
                _ && _ = False
        -- valid
                b && c | b == c         = b
                        | otherwise      = False
-}


-- Tuple patterns
{- A tuple of patterns is itself a pattern, which matches any tuple of the
same arity whose componenets all match the corresponding patterns in order
-}

fst :: (a,b) -> a
fst (x,_) = x

snd :: (a,b) -> b
snd (_, y) = y


-- List patterns
{- A list of patterns is itself a pattern, which matches any list of the same 
length whose elements all match the corresponding patterns in order. 

        test :: [Char] -> Bool
        test ['a',_,_] = True
        test _         = False

operator : called cons that constructs a new list by prepending a new element 
to the start of an existing list.
        [1,2,3] is an abbreviation for 1:(2:(3:[]))

-}

head :: [a] -> a
head (x:_) = x

tail :: [a] -> [a]
tail (_:xs) = xs


-- 4.5 Lambda Expressions
{- lambda expressions, which comprise a pattern for each of the arguments, 
a body that specifies how the result can be calculated in terms of the 
arguments, but do not give a name for the function itself. Lambda expressions 
are nameless functions.
        The nameless function that takes a single number x as its argument, and
        produces the result x + x.
                \x -> x + x

The symbol \ represents the Greek letter lambda, written as λ. -}

{- First of all, they can be used to formalise the meaning of curried function
definitions. -}

-- add :: Int -> Int -> Int
-- add x y = x + y

add :: Int -> (Int -> Int)
add = \x -> (\y -> x + y)

{- add is a function that takes an integer x and returns a function, which
in turn takes another integer y and returns that result x + y. -}

{- Secondly, lambda expressions are also useful when defining functions that
return functions as results by their very nature, rather than as a consequence
of currying. -}

{- The library function const that returns a constant function that always 
produces a given value
        -- const :: a -> b -> a
        -- const x _ = x
-}

const :: a -> (b -> a)
const x = \_ -> x

{- Finally, lambda expressions can be used to avoid having to name a function 
that is only referenced once in a program. 
        -- odds :: Int -> [Int]
        -- odds n = map f [0..n-1]
                    where f x = x*2 + 1
-}

odds :: Int -> [Int]
odds n = map (\x -> x*2 + 1) [0..n-1]


-- 4.6 Operator sections
{-
Functions such as + that are written between their two arguments are called 
operators.

Any operator can be converted into a curried function that is written before 
its arguments by enclosing the name of the operator in parentheses, 
as in (+) 1 2.

This convention also allows one of the arguments to be included in the 
parentheses if desired, as in (1+) 2 and (+2) 1. 

In general if # is an operator, then expressions of the form (#), (x #), and 
(# y) for arguments x and y are called sections. 
        (#) = \x -> (\y -> x # y)
        (x #) = \y -> x # y
        (# y) = \x -> x # y

Sections have three primary applications. 
    First of all, they can be used to construct a number of simple but useful 
    functions in a particularly compact way.
        (+) is the addition function \x -> (\y -> x+y)
        (1+) is the successor function \y -> 1+y
        (1/) is the reciprocation function \y -> 1/y
        (*2) is the doubling function \x -> x*2
        (/2) is the halving function \x -> x/2

    Secondly, sections are necessary when stating the type of operators, 
    because an operator itself is not a valid expression in Haskell. 
        (+) :: Int -> Int -> Int

    Finally, sections are also necessary when using operators as arguments to 
    other functions. 
        sum :: [Int] -> Int
        sum = foldl (+) 0

-}
