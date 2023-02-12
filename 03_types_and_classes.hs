-- 3.1 Basic concepts
{- A type is a collection of related values.
    v :: T means v is a value in the type T
    v has type T

    e :: T means that evaluation of the expression e will produce a value of 
        type T.

    In Haskell, every expression must have a type, which is calculated prior 
    to evaluating the expression by a process called "type inference".

    If f is a function that maps arguments of type A to results of type B, and 
    e is an expression of type A, then the application f e has type B:
            f :: A -> B     e :: A
                then    f e :: B
        e.g.: not :: Bool -> Bool   False :: Bool
                not False :: Bool

    Because type inference precedes evaluation, Haskell programs are type safe, 
    in the sense that type errors can never occur during evaluation. In 
    practice, type inference detects a very large class of program errors, and 
    is one of the most useful features of Haskell.
    The downside of type safety is that some expressions that evaluate 
    successfully will be rejected on type grounds.
-}
    

-- 3.2 Basic types
{-
Bool -- logical values
Char -- single characters
String -- strings of characters
Int -- fixed precision integers
    -(2^63) to 2^63-1  evaluatingh 2^63 :: Int gives a negative number
    The use of :: in this example forces the result to be an Int rather than 
    some other numeric type.

Integer -- arbitrary-precision integers
Float -- single-precision floating-point numbers
    the number of digits permitted after the decimal point depends upon the 
    size of the number
Double -- double-precision floating-point numbers
-}

-- 3.3 List types
{-
A list is a sequence of elements of the same type, with the elements being 
enclosed in square parentheses and separated by commas. We write [T] for the 
type of all lists whose elements have type T.

list of length one, such as [False], ['a'], and [[]] are called "singleton" 
lists.

[[]] is a singleton list
[] is an empty list

   1. the type of a list conveys no information about its lenght
   2. there are no restrictions on the type of the elements of a list
   3. there is no restriction that a list must have a finite length.
-}


-- 3.4 Tuple types
{-
A tuple is a finite sequence of components of possibly different types, with 
the components being enclosed in round parentheses and separated by commas.
(False,True) :: (Bool,Bool)
(False,'a',True) :: (Bool,Char,Bool)
("Yes",True,'a') :: (String,Bool,Char)

The number of components in a tuple is called its "arity". The tuple () of 
arity zero is called the empty tuple, tuple of arity two are called pairs, 
tuples of arity three are called triples, and so on.
    1. the type of a tuple conveys its arity.
    2. there are no restrictions on the types of the components of a tuple
    3. tuples must have a finite arity, in order to ensure that tuple types 
    can always be inferred prior to evaluation.
-}


-- 3.5 Function types
{- A function is a mapping from arguments of one type to results of another 
type. We write T1 -> T2 for the type of all functions that map arguments of 
type T1 to results of type T2. 
    
    not :: Bool -> Bool
    even :: Int -> Bool

Because there are no restrictions on the types of the arguments and results of 
a function, the simple notion of a function with a single argument and a single 
result is already sufficient to handle the case of multiple arguments and 
results, by packaging multiple values using lists or tuples. 

    add :: (Int,Int) -> Int
    add (x,y) = x+y

    zeroto :: Int -> [Int]
    zeroto n = [0..n]
-}


-- 3.6 Curried functions
-- functions are free to return functions as results

add' :: Int -> (Int -> Int)
add' x y = x+y

mult :: Int -> (Int -> (Int -> Int))
mult x y z = x*y*z

{- 

- Functions such as add' and mult that take their arguments one at a time 
are called curried functions. 

- The function arrow -> in types is assumed to associate to the right. 
    Int -> Int -> Int -> Int
    means:
    Int -> (Int -> (Int -> Int))

- Function application, which is denoted silently using spacing, is assumed
to associate to the left. 
    mult x y z
    means:
    ((mult x) y) z
-}


-- 3.7 Polymorphic types
{-
Type variables must begin with a lower-case letter, and are usually simply 
named a, b, c, and so on. 

    length :: [a] -> Int

For any type a, the function length has type [a] -> Int. A type that contains
one or more type variables is called polymorphic("of many forms").

    fst :: (a,b) -> a
    head :: [a] -> a
    take :: Int -> [a] -> [a]
    zip :: [a] -> [b] -> [(a,b)]
    id :: a -> a

The type of a polymorphic function often gives a strong indication about the 
function's behaviour. For example, from the type [a] -> [b] -> [(a,b)] we can
conclude that zip pairs up elements from two lists, although the type on its 
own doesn't capture the precise manner in which this is done.
-}


-- 3.8 Overloaded types
{-
The arithmetic operator + calculates the sum of any two numbers of the same 
numeric type.

The idea that + can be applied to numbers of any numeric type is made precise 
in its type by the inclusion of a class constraint. 

Class constraints are written in the form C a, where C is the name of a class
of a class and a is a type variable. 

    (+) :: Num a => a -> a -> a

For any type a that is an instance of the class Num of numeric types, the 
function (+) has type a -> a -> a.

A type that contains one or more class constraints is called overloaded, 
as is an expression with such a type. Hence, Num a => a -> a -> a is an 
overloaded type and (+) is an overloaded function. 
-}


-- 3.9 Basic classes
{-
A class is a collection of types that support certain overloaded operations 
called methods.

-- Eq - equality types
This class contains types whose values can be compared for equality and 
inequality using the following two methods:
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool

All the basic types Bool, Char, String, Int, Integer, Float and Double are 
instances of the Eq class, as are list and tuple types, provided that their 
element and component types are instances. 

Note that function types are not in general instances of the Eq class, because 
it is not feasible in general to compare two functions for equality. 

-- Ord - ordered types
This class contains types that are instances of the equality class Eq, but in 
addition whose values are totally (linearly) ordered, and as such can be 
compared and processed using the following six methods:
    (<) :: a -> a -> Bool
    (<=) :: a -> a -> Bool
    (>) :: a -> a -> Bool
    (>=) :: a -> a -> Bool
    min :: a -> a -> Bool
    max :: a -> a -> Bool

All the basic types Bool, Char, String, Int, Integer, Float and Double are 
instances of the Ord class, as are list and tuple types, provided that their 
element and component types are instances. 
    > False < True
    True

    > min 'a' 'b'
    'a'

    > "elegant" < "elephant"
    True

    > ('a',2) < ('b',1)
    True

    > ('a',2) < ('a',1)
    False

Note that strings, lists and tuples are ordered lexicographically. 
-}

-- Show -showable types
{-
This class contains types whose values can be converted into strings of 
characters using the following method:

    show :: a -> String

All the basic types Bool, Char, String, Int, Integer, Float and Double are 
instances of the Show class, as are list and tuple types, provided that their 
element and component types are instances. 

    > show False
    "False"

    > show 'a'
    "'a'"

    > show 123
    "123"

    > show [1,2,3]
    "[1,2,3]"

    > show ('a',False)
    "('a',False)"
-}

-- Read - readable types
{-
This class is dual to Show, and contains types whose values can be converted 
from strings of characters using the following method: 

    read :: String -> a

All the basic types Bool, Char, String, Int, Integer, Float and Double are 
instances of the Read class, as are list and tuple types, provided that their 
element and component types are instances. 

    > read "False" :: Bool
    False

    > read "'a'" :: Char
    'a'

    > read "123" :: Int
    123

    > read "[1,2,3]" :: [Int]
    [1,2,3]

    > read "('a',False)" :: (Char,Bool)
    ('a',False)

The use of :: in these examples resolves the type of the result, which would 
otherwise not be able to be inferred by GHCi.

Note that the result of read is undefined if its argument is not syntactically 
valid. 
-}

-- Num - numeric types
{-
This class contains types whose values are numeric, and as such can be 
processed using the following six method: 

    (+) :: a -> a -> a
    (-) :: a -> a -> a
    (*) :: a -> a -> a
    negate :: a -> a        -- returns the negation of a number
    abs :: a -> a           -- returns the absolute value
    signum :: a -> a        -- returns the sign

The basic types Int, Integer, Float, and Double are instances of the Num class.

    > negate 3.0
    -3.0

    > abs (-3)
    3

    > signum (-3)
    -1

Negative numbers must be parenthesised when used as arguments to functions, to 
ensure the correct interpretation of the minus sign. 
-}

-- Integral - integral types
{-

This class contains types that are instances of the numeric class Num, but in 
addition whose values are integers, and as such support the methods of integer 
division and integer remainder:

    div :: a -> a -> a
    mod :: a -> a -> a

In practice, these two methods are often written between their two arguments 
by enclosing their names in single back quotes. The basic types Int and Integer 
are instances of the Integral class. 

    > 7 `div` 2
    3

    > 7 `mod` 2
    1

For efficiency reasons, a number of prelude functions that involve both lists 
and integers (such as take and drop) are restricted to the type Int of 
finite-precision integers, rather than being applicable to any instance of the 
Integral class. If required, however, such generic versions of these functions 
are provided as part of an additional library file called Data.List. 
-}

-- Fractional - fractional types
{-
This class contains types that are instances of the numeric class Num, but in 
addition whose values are non-integral, and as such support the methods of 
fractional division and fractional reciprocation:

    (/) :: a -> a -> a
    recip :: a -> a

The basic types Float and Double are instances. For example:

    > 7.0 / 2.0
    3.5

    > recip 2.0
    0.5

-}
