-- 8.1 Type declarations

{-
1. declaring a new type is to introduce a new name for an existing type, using 
    the type mechanism of Haskell.
 -}           
        type String = [Char]
{-
2. the name of a new type must begin with a capital letter. Type declarations 
    can be nested, in the sense that one such type can be declared in terms of 
    another.
 -}
        type Pos = (Int,Int) 
        type Trans = Pos -> Pos
{-
3. type declarations cannot be recursive.

4. Type declarations can also be parameterised by other types.
 -}
        type Pair a = (a,a)
{-
5. type declarations with more than one parameter are possible too.
 -}
        type Assoc k v = [(k,v)]

        find :: Eq k => k -> Assoc k v -> v
        find k t = head [v | (k’,v) <- t, k == k’]


-- 8.2 Data declariations

{-
A completely new type, as opposed to a synonym for an existing type, can be 
    declared by specifying its values using the data mechanism of Haskell.
-}

        data Bool = False | True
{-
In such declarations, the symbol | is read as or, and the new values of the 
type are called constructors.

1. The names of new constructors must begin with a capital letter. Moreover, 
    the same constructor name cannot be used in more than one type.

2. The names given to new types and constructors have no inherent 
    meaning to the Haskell system.

3. Values of new types in Haskell can be used in precisely the same way as 
    those of built-in types. In particular, they can freely be passed as 
    arguments to functions, returned as results from functions, stored in 
    data structures, and used in patterns.
-}
        data Move = North | South | East | West

        move :: Move -> Pos -> Pos 
        move North (x,y) = (x,y+1) 
        move South (x,y) = (x,y-1) 
        move East (x,y) = (x+1,y)
        move West (x,y) = (x-1,y)

        moves :: [Move] -> Pos -> Pos
        moves [] p = p
        moves (m:ms) p = moves ms (move m p)

        rev :: Move -> Move 
        rev North = South 
        rev South = North 
        rev East = West 
        rev West = East
{-
4. The constructors in a data declaration can also have arguments
-}
        data Shape = Circle Float | Rect Float Float
{-
    the type Shape has values of the form Circle r, where r is a floating-point 
    number, and Rect x y, where x and y are floating-point numbers. These 
    constructors can then be used to define functions on shapes, such as to 
    produce a square of a given size, and to calculate the area of a shape:
-}
        square :: Float -> Shape 
        square n = Rect n n

        area :: Shape -> Float 
        area (Circle r) = pi * r^2 
        area (Rect x y) = x * y
{-
5. Data declarations themselves can also be parameterised.
-}
        data Maybe a = Nothing | Just a
{-
    a value of type Maybe a is either Nothing, or of the form Just x for some 
    value x of type a. We can think of values of type Maybe a as being values 
    of type a that may either fail or succeed, with Nothing representing 
    failure, and Just representing success.
-}

        safediv :: Int -> Int -> Maybe Int 
        safediv _ 0 = Nothing
        safediv m n = Just (m ‘div‘ n)

        safehead :: [a] -> Maybe a 
        safehead [] = Nothing 
        safehead xs = Just (head xs)


-- 8.3 Newtype declarations
{-
If a new type has a single constructor with a single argument, then it can 
    also be declared using the newtype mechanism.
-}
        newtype Nat = N Int
{-
    the single constructor N takes a single argument of type Int, and it is 
    then up to the programmer to ensure that this is always non-negative.
-}
        type Nat = Int 
        data Nat = N Int
{-
1. Using newtype rather than type means that Nat and Int are different types 
    rather than synonyms, and hence the type system of Haskell ensures that 
    they cannot accidentally be mixed up in our programs

2. using newtype rather than data brings an efficiency benefit, because newtype 
    constructors such as N do not incur any cost when programs are evaluated, 
    as they are automatically removed by the compiler once type checking is 
    completed.

In summary, using newtype helps improve type safety, without affecting 
    performance.

-}

-- 8.4 Recursive types
{-
New types declared using the data and newtype mechanisms can also be recursive.
-}
        data Nat = Zero | Succ Nat
{-
    a value of type Nat is either Zero, or of the form Succ n for some value 
    n of type Nat.
-}
        nat2int :: Nat -> Int
        nat2int Zero = 0
        nat2int (Succ n) = 1 + nat2int n
        int2nat :: Int -> Nat
        int2nat 0 = Zero
        int2nat n = Succ (int2nat (n-1))

        add :: Nat -> Nat -> Nat
        add m n = int2nat (nat2int m + nat2int n)

        add :: Nat -> Nat -> Nat
        add Zero n = n
        add (Succ m) n = Succ (add m n)
{-
    This definition formalises the idea that two natural numbers can be added 
    by copying Succ constructors from the first number until they are exhausted.
-}
        data List a = Nil | Cons a (List a)

{-
    a value of type List a is either Nil, representing the empty list, or of 
    the form Cons x xs for some values x :: a and xs :: List a, representing 
    a non-empty list.
-}
        len :: List a -> Int
        len Nil = 0
        len (Cons _ xs) = 1 + len xs


        data Tree a = Leaf a | Node (Tree a) a (Tree a)

        t :: Tree Int
        t = Node (Node (Leaf 1) 3 (Leaf 4)) 5
                (Node (Leaf 6) 7 (Leaf 9))
        
        occurs :: Eq a => a -> Tree a -> Bool
        occurs x (Leaf y) = x == y
        occurs x (Node l y r) = x == y || occurs x l || occurs x r

{- A value occurs in a leaf if it matches the value at the leaf, and occurs in 
    a node if it either matches the value at the node, occurs in the left 
    subtree, or occurs in the right subtree.
-}
        flatten :: Tree a -> [a]
        flatten (Leaf x)        = [x]
        flatten (Node l x r)    = flatten l ++ [x] ++ flatten r


        occurs :: Ord a => a -> Tree a -> Bool
        occurs x (Leaf y)                   = x == y
        occurs x (Node l y r) | x == y      = True
                            | x < y       = occurs x l
                            | otherwise   = occurs x r


        data Tree a = Leaf a | Node (Tree a) (Tree a)
        data Tree a = Leaf | Node (Tree a) a (Tree a)
        data Tree a b = Leaf a | Node (Tree a b) b (Tree a b)
        data Tree a = Node a [Tree a]


-- 8.5 Class and instance declarations
{- In Haskell, a new class can be declared using the class mechanism. -}

        class Eq a where
        (==), (/=) :: a -> a -> Bool
        x /= y = not (x == y)

{-for a type a to be an instance of the class Eq, it must support equality and 
    inequality operators of the specified types.-}

        instance Eq Bool where
            False == False = True 
            True  == True  = True 
            _     == _     = False

{-Only types that are declared using the data and newtype mechanisms can be 
    made into instances of classes. Note also that default definitions can be 
    overridden in instance declarations if desired.-}

{-Classes can also be extended to form new classes. -}

class Eq a => Ord a where 
    (<), (<=), (>), (>=) :: a -> a -> Bool
    min, max             :: a -> a -> a

    min x y | x <= y    = x 
            | otherwise = y

    max x y | x <= y    = y 
            | otherwise = x

{-for a type to be an instance of Ord it must be an instance of Eq, and support 
    six additional operators. Because default definitions have already been 
    included for min and max, declaring an equality type (such as Bool) as an 
    ordered type only requires defining the four comparison operators:-}


        instance Ord Bool where 
            False < True = True
            _     < _    = False

            b <= c = (b < c) || (b == c) 
            b > c = c < b
            b >= c = c <= b

{- When new types are declared, it is usually appropriate to make them into 
    instances of a number of built-in classes. Haskell provides a simple 
    facility for automatically making new types into instances of the classes 
    Eq, Ord, Show, and Read, in the form of the deriving mechanism. -}


        data Bool = False | True
                deriving (Eq, Ord, Show, Read)


{- The use of :: in the last example is required to resolve the type of the 
    result, which in this case cannot be inferred from the context in which the 
    function is used.

In the case of constructors with arguments, the types of these arguments must 
    also be instances of any derived classes. -}


        data Shape = Circle Float | Rect Float Float 
        data Maybe a = Nothing | Just a

