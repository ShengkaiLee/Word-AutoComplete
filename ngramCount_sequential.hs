import Data.Map (fromListWith, toList)
import System.Environment(getArgs)
import WordClean(wordClean)



mapper :: Int -> [String] -> [(String, Int)]
mapper n str
    | n <= length str = (unwords ngram, 1::Int) : mapper n str'
    | otherwise = []
    where ngram = take n str
          str'  = drop (1::Int) str

reducer :: (Ord k, Num a) => [(k, a)] -> [(k, a)]
reducer l = toList $ fromListWith (\num1 num2 -> num1 + num2) l

{-
main :: IO ()
main = do
    [n, filename] <- getArgs
    content <- wordClean filename
    let input = words $ unwords $ lines content
    let output = reducer $ mapper (read n) input
    writeFile "sqe.txt" (show output)
-}