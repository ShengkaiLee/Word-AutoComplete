module NgramCount where
import Data.Map (fromListWith, toList)
--import System.Environment(getArgs)
--import WordClean(wordClean)
import Data.List.Split ( chunksOf )
import Control.Parallel.Strategies
    ( parList, rdeepseq, using, NFData )
    
    

mapper :: Int -> [String] -> [(String, Int)]
mapper n str
    | n <= length str = (unwords ngram, 1::Int) : mapper n str'
    | otherwise = []
    where ngram = take n str
          str'  = drop (1::Int) str

par_mapper :: Int -> [[String]] -> [(String, Int)]
par_mapper n l = concat (map (mapper n) l) `using` parList rdeepseq

reducer :: (Ord k, Num a) => [(k, a)] -> [(k, a)]
reducer l = toList $ fromListWith (\num1 num2 -> num1 + num2) l

par_reducer :: (Ord k, Num a, NFData k, NFData a) => [(k, a)] -> [(k, a)]
par_reducer l = reducer $ concat 
                ((map reducer l') `using` parList rdeepseq)
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