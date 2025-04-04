{-  Functor

    Type class
        - class Functor (f :: * -> *) where
              fmap :: (a -> b) -> f a -> f b
              (<$) :: a -> f b -> f a
              {-# MINIMAL fmap #-}
    
    Da bi tip pripadao klasi Functor mora implementirati fmap funkciju
    
    Bilo koji tip preko kojeg ima smisla mapiranje moze biti Functor
        - Bilo koji tip koji ima parametar tipa u type konstruktoru
    
    Ne navodi se parametar konkretnog tipa
    
    Ako type konstruktor prima 2 parametra tipa mora se parcijalno primeniti
    
    Pravila
        - fmap id = id
        - fmap (f . g) = fmap f . fmap g

    Primeri
        - instance Functor [] where  
              fmap = map
        
        - instance Functor Maybe where
              fmap f (Just x) = Just (f x)
              fmap f Nothing = Nothing
        
        - instance Functor (Either a) where
              fmap f (Right x) = Right (f x)
              fmap f (Left x) = Left x
        
        - instance Functor IO where
              fmap f action = do
                  result <- action
                  return (f result)

-}

plus2 :: Int -> Int
plus2 = (+2)

mDiv :: Int -> Int -> Maybe Int
mDiv _ 0 = Nothing
mDiv x y = Just (div x y)

operacija :: Int -> Int -> Maybe Int
operacija x y = fmap plus2 (mDiv x y)

data Nesto a = Samo String a | Nista deriving Show

instance Functor Nesto where
    fmap _ Nista = Nista
    fmap f (Samo str x) = Samo (str ++ "!") (f x)

data Piksel a = Color a a a | GScale a deriving Show

instance Functor Piksel where
    fmap f (GScale x) = GScale (f x)
    fmap f (Color r g b) = Color (f r) (f g) (f b)

rpn :: String -> Int
rpn = head . foldl helper [] . words
    where helper (x:y:ys) "+" = (x + y) : ys
          helper (x:y:ys) "-" = (y - x) : ys
          helper xs str = read str : xs

main1 = do rez <- fmap (show . rpn) getLine
           putStrLn rez

{-  Applicative functor

    Type class
        - nalazi se u modulu Control.Applicative
        
        - class Functor f => Applicative (f :: * -> *) where
              pure :: a -> f a
              (<*>) :: f (a -> b) -> f a -> f b
              (*>) :: f a -> f b -> f b
              (<*) :: f a -> f b -> f a
              {-# MINIMAL pure, (<*>) #-}
    
    Ideja je da se funkcija u kontekstu primenjuje na podatak u kontekstu
    
    Ne navodi se parametar konkretnog tipa
    
    Ako type konstruktor prima 2 parametra tipa mora se parcijalno primeniti
    
    U modulu Control.Applicative se nalazi funkcija "<$>"
        - (<$>) :: (Functor f) => (a -> b) -> f a -> f b
    
    U modulu Control.Applicative se nalazi funkcija "liftA2"
        - liftA2 :: (Applicative f) => (a -> b -> c) -> f a -> f b -> f c
    
    Pravila
        - pure f <*> x = fmap f x
        - pure id <*> v = v
        - pure (.) <*> u <*> v <*> w = u <*> (v <*> w)
        - pure f <*> pure x = pure (f x)
        - u <*> pure y = pure ($ y) <*> u
    
    Primer
        - instance Applicative Maybe where
              pure = Just
              Nothing <*> _ = Nothing
              (Just f) <*> something = fmap f something
        
        - instance Applicative [] where
              pure x = [x]
              fs <*> xs = [f x | f <- fs, x <- xs]
        
        - instance Applicative IO where
              pure = return
              a <*> b = do
                  f <- a
                  x <- b
                  return (f x)

-}

main = do rez <- show . rpn <$> getLine
          putStrLn rez

instance Applicative Piksel where
    pure x = GScale x
    (GScale f) <*> (GScale x) = GScale (f x)
    (Color fr fg fb) <*> (Color r g b) = Color (fr r) (fg g) (fb b)

{-  Monoid

    Type class
        - nalazi se u modulu Data.Monoid
        
        - class Semigroup a => Monoid m where
              mempty :: m
              mappend :: m -> m -> m
              mconcat :: [m] -> m
              {-# MINIMAL mempty #-}
        
        - class Semigroup a where
              (<>) :: a -> a -> a
    
    Promena u novijim verzijama compilera
        - Da bi tip bio instanca Monoid-a mora prvo biti instanca Semigroup-a
        - (<>) == mappend
    
    Monoidi mogu biti tipovi koji imaju definisanu asocijativnu operaciju i
    jednicni element za tu operaciju
    
    Operacija ne mora biti komutativna
    
    Samo konkretni tipovi mogu biti instance
    
    Pravila
        - mempty `mappend` x = x
        - x `mappend` mempty = x
        - (x `mappend` y) `mappend` z = x `mappend` (y `mappend` z)
    
    Primer
        - instance Monoid a => Monoid (Maybe a) where
              mempty = Nothing
              Nothing `mappend` m = m
              m `mappend` Nothing = m
              Just m1 `mappend` Just m2 = Just (m1 `mappend` m2)
        
        - instance Monoid [a] where
              mempty = []
              mappend = (++)

-}


