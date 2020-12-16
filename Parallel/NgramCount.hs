module NgramCount where
import Data.Map (fromListWith, toList)
--import System.Environment(getArgs)
--import WordClean(wordClean)
import Data.List.Split ( chunksOf )
import Control.Parallel.Strategies
    ( parList, rdeepseq, using, NFData )
    
    

ngramMapper :: Int -> [String] -> [(String, Int)]
ngramMapper n str
    | n <= length str = (unwords ngram, 1::Int) : ngramMapper n str'
    | otherwise = []
    where ngram = take n str
          str'  = drop (1::Int) str

parNgramMapper :: Int -> [[String]] -> [(String, Int)]
parNgramMapper n l = concat (map (ngramMapper n) l) `using` parList rdeepseq

ngramReducer :: (Ord k, Num a) => [(k, a)] -> [(k, a)]
ngramReducer l = toList $ fromListWith (\num1 num2 -> num1 + num2) l

parNgramReducer :: (Ord k, Num a, NFData k, NFData a) => [(k, a)] -> [(k, a)]
parNgramReducer l = ngramReducer $ concat 
                ((map ngramReducer l') `using` parList rdeepseq)
                where l' = chunksOf 9 l

{-
main :: IO ()
main = do
    [n, filename] <- getArgs
    content <- wordClean filename
    let input = map words $ lines content
    let output = par_reducer $ par_mapper (read n) input
    writeFile "par.txt" (show output)
-}