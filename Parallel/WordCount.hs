module WordCount where
--import System.Environment(getArgs, getProgName)
--import System.Exit(die)
import WordClean(wordClean)
import qualified Data.Map as M
import Data.List.Split( chunksOf )
import Control.Parallel ( pseq )
import Control.Parallel.Strategies
    ( parList, parBuffer, rdeepseq, using, NFData )

chunkSize :: Int
chunkSize = 100

bufferSize :: Int
bufferSize = 4

wordMapper :: [String] -> [(String, Int)]
wordMapper w = map (\x -> (x, 1)) w

parWordMapper :: [String] -> [(String, Int)]
parWordMapper w =  wordMapper w `using` parBuffer bufferSize rdeepseq

wordReducer :: (Ord k, Num a) => [(k, a)] -> [(k, a)]
wordReducer l =  M.toList $ M.fromListWith (+) l

parWordReducer :: (Ord k, Num a, NFData k, NFData a) => [(k, a)] -> [(k, a)]
parWordReducer l = wordReducer $ concat ((map wordReducer l') `using` parList rdeepseq)
                    where l' = chunksOf chunkSize l

{-
main :: IO ()
main = do 
    args <- getArgs
    case args of
        [filename] -> do
            content <- wordClean filename
            let input = words $ unwords $ lines content
            let mapOutput = parWordMapper input
            let reduceOutput = parWordReducer mapOutput
            let output = pseq mapOutput reduceOutput
            writeFile "WordCount.txt" (show output)
        _ -> do 
            pn <- getProgName
            die $ "Usage: " ++ pn ++ " <filename>"
-}