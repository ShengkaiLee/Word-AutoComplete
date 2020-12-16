module NgramCount_Sequential where
import Data.Map (fromListWith, toList)

ngramMapper :: Int -> [String] -> [(String, Int)]
ngramMapper n str
    | n <= length str = (unwords ngram, 1::Int) : ngramMapper n str'
    | otherwise = []
    where ngram = take n str
          str'  = drop (1::Int) str

ngramReducer :: (Ord k, Num a) => [(k, a)] -> [(k, a)]
ngramReducer l = toList $ fromListWith (\num1 num2 -> num1 + num2) l
