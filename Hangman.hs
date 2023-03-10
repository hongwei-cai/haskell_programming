import System.IO -- Required for the hSetEcho primitive

hangman :: IO ()
hangman = do putStrLn "Think of a word: "
             word <- sgetLine
             putStrLn "Try to guess it:"
             play word

{-

The action sgetLine reads a line of text from the
keyboard, echoing each character as a dash to keep
the word secret:

-}

sgetLine :: IO String
sgetLine = do x <- getCh
              if x == '\n' then
                 do putChar x
                    return []
              else
                 do putChar '-'
                    xs <- sgetLine
                    return (x:xs)

{-

The action getCh reads a single character from the
keyboard, without echoing it to the screen:

-}

getCh :: IO Char
getCh = do hSetEcho stdin False
           x <- getChar
           hSetEcho stdin True
           return x

{-

The function play is the main loop, which requests
and processes the guesses until the game ends.

-}

play :: String -> IO ()
play word =
   do putStr "? "
      guess <- getLine
      if guess == word then
         putStrLn "You got it!"
      else
         do putStrLn (match word guess)
            play word

{-

The function match indicates which characters in
one string occur in a second string:

For example, where match word guess :

> match "haskell" "pascal"
"-as--ll"

Note “haskell” matches l twice in “pascal”:

-}

match :: String -> String -> String
match xs ys =
   [if x `elem` ys then x else '-' | x <- xs]

{-

Example:

> hangman 

Think of a word: 
----

Try to guess it:
? asd
--s-

? gas
--s-

? was
--s-

? ter
te-t

? test
You got it!

-}