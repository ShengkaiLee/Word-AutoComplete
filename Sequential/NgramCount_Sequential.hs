module NgramCount_Sequential where
import Data.Map (fromListWith, toList)

mapper :: Int -> [String] -> [(String, Int)]
mapper n str
    | n <= length str = (unwords ngram, 1::Int) : mapper n str'
    | otherwise = []
    where ngram = take n str
          str'  = drop (1::Int) str

reducer :: (Ord k, Num a) => [(k, a)] -> [(k, a)]
reducer l = toList $ fromListWith (\num1 num2 -> num1 + num2) l
