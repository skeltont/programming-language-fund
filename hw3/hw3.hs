{-
  TEAM MEMBERS:
    - Shane Barrantes
    - Ty Skelton
    - Griffin Gonsalves
-}

{-
    #1. A rank-based type system for the stack language
    goals:
      - extend language (INC, SWAP, POP)
      - add ranking types (Rank, CmdRank)
      - add ranking functions (rankP, rankC, rank)
      - add type checking semantics (semStatTC)

    a) done below.
    b) sem's type and definition can now be simplified from using Maybe Stack
          and case switches because we do all of our type checking in semStatTC.
          This allows cleaner definitions over a stack we have proven has a valid
          rank so no statement results in an underflow.
-}

module HW3 where

type Prog     = [Cmd]
type Stack    = [Int]
type D        = Stack -> Stack
type Rank     = Int
type CmdRank  = (Int, Int)

data Cmd    = LD Int
            | ADD
            | MULT
            | DUP
            | INC
            | SWAP
            | POP Int
            deriving (Eq, Show)

rankP :: Prog -> Maybe Rank
rankP [] = Just 0
rankP p  = rank p 0

rank :: Prog -> Rank -> Maybe Rank
rank [] r    = Just r
rank (c:p) r = let (n,m) = rankC c
               in if n <= r then rank p (r - n + m)
                            else Nothing

rankC :: Cmd -> CmdRank
rankC (LD _)  = (0, 1)
rankC (ADD)   = (2, 1)
rankC (MULT)  = (2, 1)
rankC (DUP)   = (1, 2)
rankC (INC)   = (1, 1)
rankC (SWAP)  = (2, 2)
rankC (POP n) = (n, 0)

semStatTC :: Prog -> Maybe Stack
semStatTC p | (rankP p) >= Just 0 = Just (sem p [])
            | otherwise           = Nothing

sem :: Prog -> D
sem [] xs = xs
sem (c:cs) xs = sem cs (semCmd c xs)

semCmd :: Cmd -> D
semCmd (LD n)  xs        = n:xs
semCmd (ADD)   (x:x':xs) = (x+x'):xs
semCmd (MULT)  (x:x':xs) = (x*x'):xs
semCmd (DUP)   (x:xs)    = x:x:xs
semCmd (INC)   (x:xs)    = (x+1):xs
semCmd (SWAP)  (x:x':xs) = x':x:xs
semCmd (POP n) (xs)      | n > 0     = semCmd (POP (n-1)) (tail xs)
                         | otherwise = xs
{-
    testing #1:
    - semStatTC [LD 1, DUP, INC, SWAP] == Just [1,2]
    - semStatTC [LD 3, LD 4, MULT, INC, LD 4, DUP, DUP, POP 2, SWAP] == Just [13,4]
-}
-- ----------------------------------------------------------------
{-
   #2. Shape Language
   goals:
     - define a type checker of shape as it's resulting width/height.
     - define a type checker of shape as only rectangles.

   a) shown below (bbox definition).
   b) shown below (rect definition).
-}

data Shape = X
           | TD Shape Shape
           | LR Shape Shape
           deriving Show
type BBox = (Int, Int)


bbox :: Shape -> BBox
bbox (X) = (1,1)
bbox (TD b b') = (maximum [w,w'], h+h')
                 where (w, h)   = bbox b
                       (w', h') = bbox b'
bbox (LR b b') = (w+w', maximum[h,h'])
                 where (w, h)   = bbox b
                       (w', h') = bbox b'

rect :: Shape -> Maybe BBox
rect (X) = Just (1,1)
rect (TD b b') | w == w'   = Just (bbox (TD b b'))
               | otherwise =  Nothing
               where (w,_)  = bbox b
                     (w',_) = bbox b'
rect (LR b b') | h == h'   = Just (bbox (LR b b'))
               | otherwise =  Nothing
               where (_,h)  = bbox b
                     (_,h') = bbox b'

{-
    testing #2:
    - rect (TD X X) == Just (1,2)
    - rect (LR (TD X X) (TD X X))  == Just (2,2)
    - *HW3> rect (LR (LR (TD X X) (TD X X)) X) == Nothing
-}
-- ----------------------------------------------------------------
{-
  TODO: #3
  goals:

  a)
  b)
  c)
  d)
-}
