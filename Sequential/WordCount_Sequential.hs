import System.Environment(getArgs, getProgName)
import System.Exit(die)
import WordClean(wordClean)
import qualified Data.Map as M


wordMapper :: [String] -> [(String, Int)]
wordMapper w = map (\x -> (x, 1)) w

wordReducer :: (Ord k, Num a) => [(k, a)] -> [(k, a)]
wordReducer l =  M.toList $ M.fromListWith (+) l

main :: IO ()
main = do 
    args <- getArgs
    case args of
        [filename] -> do
            content <- wordClean filename
            let input = words $ unwords $ lines content
            let output = wordReducer $ wordMapper input
            writeFile "sqe.txt" (show output)
        _ -> do 
            pn <- getProgName
            die $ "Usage: " ++ pn ++ " <filename>"
