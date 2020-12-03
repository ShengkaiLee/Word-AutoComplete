import Data.Char ( isSpace, isAlpha, toLower )
import System.IO ( openFile, hGetContents, IOMode(ReadMode) )
import Control.Parallel.Strategies ( parBuffer, rdeepseq, using )

wordFilter :: [[Char]] -> [[Char]]
wordFilter lines =  map ((map toLower) . filter (\x -> isAlpha x || isSpace x)) lines `using` parBuffer 4 rdeepseq

wordClean :: FilePath -> IO String
wordClean input = do
    handle <- openFile input ReadMode
    contents <- fmap lines $ hGetContents handle
    let output = wordFilter contents
    return $ unlines output
    --writeFile "cleanOutput.txt" (unlines output)

{-
main :: IO ()
main = do
    [filename] <- getArgs
    output <- wordClean filename
    writeFile "parallel_1_output.txt" output
-}