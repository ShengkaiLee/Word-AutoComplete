import Data.Char ( isSpace, isAlpha )
import System.IO ( openFile, hGetContents, IOMode(ReadMode) )

wordFilter :: [[Char]] -> [[Char]]
wordFilter lines =  map (filter (\x -> isAlpha x || isSpace x)) lines

wordClean :: FilePath -> IO String
wordClean input = do
    handle <- openFile input ReadMode
    contents <- fmap lines $ hGetContents handle
    let output = wordFilter contents
    return $ unlines output
    --writeFile "cleanOutput.txt" (unlines output)