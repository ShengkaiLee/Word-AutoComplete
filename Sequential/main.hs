import NgramCount_Sequential ( ngramMapper, ngramReducer)
import WordCount_Sequential ( wordMapper, wordReducer )
import WordClean_Sequential ( wordClean )
import Suggestion_Sequential (suggestion_sort, suggestion_filer ) 
import System.Environment ( getArgs )

enterLoop :: [([Char], Int)] -> IO b
enterLoop output = do
    putStrLn ""
    putStrLn "Please enter prefix of word(s):"
    str <- getLine
    putStrLn "Enter the number of top suggestions you want:"
    k <- getLine
    putStrLn "Here are the suggesions:"
    let results = take (read k::Int) $ suggestion_sort $ suggestion_filer str output
    mapM_ (\(a,_) -> putStrLn a) results
    enterLoop output

mapreduce ::Int -> [String] -> [(String, Int)]
mapreduce n input 
    | n==1  = wordReducer $ wordMapper input
    | otherwise = ngramReducer $ ngramMapper n input

main :: IO ()
main = do
    [filename] <- getArgs
    putStrLn "Enter the number of words you want suggestion for (1 for a single word):"
    n <- getLine
    putStrLn "Loading Dictionary ..."
    content <- wordClean filename
    let input = words $ unwords $ lines content
    let output = mapreduce (read n::Int) input 
    writeFile "../Output/seq_output.txt" (show output)
    putStrLn "Done loading!"
    enterLoop output
    
