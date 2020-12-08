import System.Environment(getArgs, getProgName)
import System.Exit(die)
import WordClean(wordClean)
--import MapReduce (mapReduce)
import qualified Data.Map as M
import Data.List.Split()
import Control.Parallel.Strategies
    ( parList, rdeepseq, using, NFData )


wordMapper :: [String] -> [(String, Int)]
wordMapper w = map (\x -> (x, 1)) w

parWordMapper :: [String] -> [(String, Int)]
parWordMapper w = wordMapper w `using` parList rdeepseq

wordReducer :: (Ord k, Num a) => [(k, a)] -> [(k, a)]
wordReducer l =  M.toList $ M.fromListWith (+) l

parWordReducer :: (Ord k, Num a, NFData k, NFData a) => [(k, a)] -> [(k, a)]
parWordReducer l = wordReducer l `using` parList rdeepseq


main :: IO ()
main = do 
    args <- getArgs
    case args of
        [filename] -> do
            content <- wordClean filename
            let input = words $ unwords $ lines content
            let output = parWordReducer $ parWordMapper input
            writeFile "sqe.txt" (show output)
        _ -> do 
            pn <- getProgName
            die $ "Usage: " ++ pn ++ " <filename>"