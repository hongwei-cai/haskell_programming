import Distribution.Compat.Lens (_1)
import qualified GHC.TypeLits as definitions


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

-- The symbol | is read as such that

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

-- True && b = b
-- False && _ = False

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

-- const :: a -> b -> a
-- const x _ = x

const :: a -> (b -> a)
const x = \_ -> x

{- Finally, lambda expressions can be used to avoid-}


