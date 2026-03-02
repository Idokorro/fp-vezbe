{-  Tipovi

    Type signature
        - addThree :: Int -> Int -> Int -> Int
    Type annotation
        - x = 3 :: Int
    
    Type variable
        - polimorfne funkcije
        - head :: [a] -> a
        - fst :: (a, b) -> a
        - map :: (a -> b) -> [a] -> [b]

-}

{-  Klase tipova (Typeclass)

    Najpribliznije interfejsima kod OOP
    
    Class constraint
        - (==) :: (Eq a) => a -> a -> Bool
    
    Primeri
        - Eq - jednakost
        - Ord - poredjenje
        - Show - mogu da se predstave kao string
        - Read - mogu da se procitaju iz stringa
        - Enum - nabrojivi
        - Num - numericki
        - Integral - celobrojni
        - Floating - realni brojevi
    
    Ne postoji polimorfizam kao u OOP
        - postoji tipski polimorfizam

-}

{-  Funkcije

    Pattern matching
        - vise tela funkcije
        - poziva se ona ciji pattern odgovara prosledjenim podacima
        - "_" se koristi za podatak koji nam nije vazan
        - as patterns "xs@(x:y:ys)" - cuva referencu do cele liste

-}

test :: (Eq a, Num a) => a -> String
test 7 = "Sedam"
test _ = "Nije sedam"

fact :: Int -> Int
fact 0 = 1
fact n = n * fact (n - 1)

addVec :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVec x y = (fst x + fst y, snd x + snd y)

addVec' :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVec' (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

len' :: [a] -> Int
len' [] = 0
len' (_:xs) = 1 + len' xs

sum' :: Num a => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

tell :: (Show a) => [a] -> String
tell [] = "Prazna lista."
tell (x:[]) = "Jedan element: " ++ show x
-- tell (x:xs) = "Vise elemenata: " ++ show x ++ ", " ++ show xs
-- tell ls@(x:y:[]) = "Vise elemenata: " ++ show x ++ ", " ++ show y ++ ", " ++ show ys
