import Prelude hiding (length)
import Data.Char

-- 5.1 Basic concepts
{-
In mathematics, the comprehension notation can be used to construct new sets 
from existing sets. For example, the comprehension {x^2 | x ∈ {1..5} produces 
the set {1,4,9,16,25} of all numbers x^2 such that x is an element of the 
set {1..5}. 

    > [x^2 | x <- [1..5]]
    [1,4,9,16,25]

The symbol | is read as such that, <- is read as is drawn from, and the 
expression x <- [1..5] is called a generator . 

A list comprehension can have more than one generator, with successive 
generators being separated by commas. 

    > [(x,y) | x <- [1,2,3], y <- [4,5]]
    [(1,4),(1,5),(2,4),(2,5),(3,4),(3,5)]

Changing the order of the two generators in this example produces the same 
set of pairs, but arranged in a different order:

    > [(x,y) | x <- [1,2,3], y <- [4,5]]
    [(1,4),(2,4),(3,4),(1,5),(2,5),(3,5)]

The x components of the pairs change more frequently than the y components. 
Later generators is more deeply nested, and hence changing the values of 
their variables more frequently than earlier generators.

    > [(x,y) | x <- [1..3], y <- [x..3]]
    [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]
-}

concat :: [[a]] -> [a]
concat xss = [x | xs <- xss, x <- xs]

{- The wildcard pattern _ is sometimes useful in generators to discard certain 
elements from a list. -}

firsts :: [(a,b)] -> [a]
firsts ps = [x | (x,_) <- ps]

length :: [a] -> Int
length xs = sum [1 | _ <- xs]

{- The generator _ <- xs simply serves as a counter to govern the production 
of the appropriate number of ones. -}

-- 5.2 Guards
{-
List comprehensions can also use logical expressions called guards to filter 
the values produced by earlier generators. If a guard is True, then the current 
values are retained; if it is False, then they are discarded.

-}

factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

{-
    > factors 15 
    [1,3,5,15]
    
    > factors 7
    [1,7]

An integer greater than one is prime if its only positive factors are one and 
the number itself. 
-}

prime :: Int -> Bool
prime n = factors n == [1..n]

{- 
    > prime 15
    False

    > prime 7
    True
-}

primes :: Int -> [Int]
primes n = [x | x <- [2..n], prime x]

{-
    > primes 40
    [2,3,5,7,11,13,17,19,23,29,31,37]
-}

find :: Eq a => a -> [(a,b)] -> [b]
find k t = [v | (k',v) <- t, k == k']

{-
    > find 'b' [('a',1),('b',2),('c',3),('d',4)]
    [2,4]
-}

-- 5.3 The zip function
{-
The library function zip produces a new list by pairing successive elements 
from two existing lists until either or both lists are exhausted.

    > zip ['a','b','c'] [1,2,3,4] 
    [('a',1),('b',2),('c',3)]
-}

pairs :: [a] -> [(a,a)]
pairs xs = zip xs (tail xs)

{-
    > pairs [1,2,3,4]
    [(1,2),(2,3),(3,4)]
-}

sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y | (x,y) <- pairs xs]

{-
    > sorted [1,2,3,4]
    True

    > sorted [1,3,2,4]
    False
-}

positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x',i) <- zip xs [0..], x == x']

{-
    > positions False [True, False, True, False]
    [1,3]
-}

-- 5.4 String comprehensions
{-
In fact they are not primitive, but are constructed as lists of characters. 
For example, the string "abc" :: String is just an abbreviation for the list 
of characters ['a','b','c'] :: [Char]. Because strings are lists, any 
polymorphic function on lists can also be used with strings. For example:


    > "abcde" !! 2 
    ’c’

    > take 3 "abcde"
    "abc"

    > length "abcde"
    5

    > zip "abc" [1,2,3,4]
    [(’a’,1),(’b’,2),(’c’,3)]
-}

lowers :: String -> Int
lowers xs = length [x | x <- xs, x >= 'a' && x <= 'z']
count :: Char -> String -> Int
count x xs = length [x' | x' <- xs, x == x']


{-
    > lowers "Haskell"
    6

    > count ’s’ "Mississippi" 
    4
-}

-- 5.5 The Caesar cipher
{-
To encode a string, Caessar simply replaced each letter in the string by the 
letter three places further down in the alphabet, wrapping around at the end 
of the alphabet.

        "haskell is fun"
        would be encoded as
        "kdvnhoo lv ixq"



-}
let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

{-
The library functions ord :: Char -> Int and chr :: Int -> Char convert 
between characters and their Unicode numbers. For example:

    > let2int ’a’ 
    0

    > int2let 0
    ’a’
-}

shift :: Int -> Char -> Char
shift n c | isLower c = int2let ((let2int c + n) `mod` 26)
          | otherwise = c

{-
The library function isLower :: Char -> Bool decides if a character is a 
lower-case letter. 
Note that this function accepts both positive and negative shift factors, 
and that only lower-case letters are changed. For example:

    > shift 3 'a'
    'd'
    
    > shift 3 'z'
    'c'
    
    > shift (-3) 'c'
    'z'
    
    > shift 3 ' '
    ''

Using shift within a list comprehension, it is now easy to define a function 
that encodes a string using a given shift factor:
-}

encode :: Int -> String -> String
encode n xs = [shift n x | x <- xs]

{-
A separate function to decode a string is not required, because this can be 
achieved by simply using a negative shift factor. For example:
    > encode 3 "haskell is fun" "kdvnhoo lv ixq"
    > encode (-3) "kdvnhoo lv ixq" "haskell is fun"
-}

-- Frequency tables


{-
The key to cracking the Caesar cipher is the observation that some letters are 
used more frequently than others in English text. By analysing a large volume 
of such text, one can derive the following table of approximate percentage 
frequencies of the twenty-six letters of alphabet:
-}

table :: [Float]
table = [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
        0.2, 0.8, 4.0, 2.4, 6.7, 7.5, 1.9, 0.1, 6.0, 
        6.3, 9.0, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

{-
For example, the letter ’e’ occurs most often, with a frequency of 12.7%, 
while ’q’ and ’z’ occur least often, with a frequency of just 0.1%. It is 
also useful to produce frequency tables for individual strings. To this end, 
we first define a function that calculates the percentage of one integer 
with respect to another, returning the result as a floating-point number:
-}

percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

{-
(The library function fromIntegral :: Int -> Float converts an integer into 
a floating-point number.) For example:

    > percent 5 15 33.333336

Using percent within a list comprehension, together with the functions lowers 
and count from the previous section, we can now define a function that returns 
a frequency table for any given string:
-}

freqs :: String -> [Float]
freqs xs = [percent (count x xs) n | x <- ['a'..'z']]
            where n = lowers xs

{-
For example:
    > freqs "abbcccddddeeeee"
    [6.666667, 13.333334, 20.0, 26.666668, ..., 0.0]

That is, the letter ’a’ occurs with a frequency of approximately 6.6%, the 
letter ’b’ with a frequency of 13.3%, and so on. The use of the local 
definition n = lowers xs within freqs ensures that the number of lower-case 
letters in the argument string is calculated once, rather than each of the 
twenty-six times that this number is used within the list comprehension.
-}

-- Cracking the cipher
{-
A standard method for comparing a list of observed frequencies os with a list 
of expected frequencies es is the chi-square statistic, defined by the 
following summation in which n denotes the length of the two lists, and xsi 
denotes the ith element of a list xs counting from zero:

The details of the chi-square statistic need not concern us here, only the fact 
that the smaller the value it produces the better the match between the two 
frequency lists. Using the library function zip and a list comprehension, it is 
easy to translate the above formula into a function definition:
-}

chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o-e)^2)/e | (o,e) <- zip os es]

{-
In turn, we define a function that rotates the elements of a list n places to 
the left, wrapping around at the start of the list, and assuming that the 
integer argument n is between zero and the length of the list:
-}

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

{-

For example:

    > rotate 3 [1,2,3,4,5] 
    [4,5,1,2,3]
Now suppose that we are given an encoded string, but not the shift factor that 
was used to encode it, and wish to determine this number in order that we can 
decode the string. This can usually be achieved by producing the frequency 
table of the encoded string, calculating the chi-square statistic for each 
possible rotation of this table with respect to the table of expected 
frequencies, and using the position of the minimum chi-square value as the 
shift factor. For example, if we let table’ “ freqs "kdvnhoo lv ixq", then

    [chisqr (rotate n table’) table | n <- [0..25]]

gives the result

    [1408.8524, 640.0218, 612.3969, 202.42024, ..., 626.4024]
in which the minimum value, 202.42024, appears at position three in this list. 
Hence, we conclude that three is the most likely shift factor that was used to 
encode the string. Using the function positions from earlier in this chapter, 
this procedure can be implemented as follows:
-}


crack :: String -> String 
crack xs = encode (-factor) xs
    where
        factor = head (positions (minimum chitab) chitab)
        chitab = [chisqr (rotate n table') table | n <- [0..25]] 
        table' = freqs xs

{-
For example:
    > crack "kdvnhoo lv ixq" 
    "haskell is fun"
    > crack "vscd mywzboroxcsyxc kbo ecopev" 
    "list comprehensions are useful"

More generally, the crack function can decode most strings produced using the 
Caesar cipher. Note, however, that it may not be successful if the string is 
    short or has an unusual distribution of letters. For example:

    > crack (encode 3 "haskell") 
    "piasmtt"
    > crack (encode 3 "boxing wizards jump quickly") 
    "wjsdib rduvmyn ephk lpdxfgt"
-}
