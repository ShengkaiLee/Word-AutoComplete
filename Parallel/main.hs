import NgramCount ( parNgramMapper, parNgramReducer )
import WordCount ( parWordMapper, parWordReducer )
import WordClean ( wordClean )
import Suggestion_Parallel ( par_suggestion_filer, suggestion_sort, suggestion_filer ) 
import System.Environment ( getArgs )
import Control.Parallel ( pseq )

enterLoop :: [([Char], Int)] -> IO b
enterLoop output = do
    putStrLn ""
    putStrLn "Please enter prefix of word(s):"
    str <- getLine
    putStrLn "Enter the number of top suggestions you want:"
    k <- getLine
    putStrLn "Here are the suggesions:"
    let results = take (read k::Int) $ suggestion_sort $ par_suggestion_filer str output
    mapM_ (\(a,_) -> putStrLn a) results
    enterLoop output

processMapReduce :: Int -> String -> [(String, Int)]
processMapReduce n content
    | n==1  = parWordReducer $ parWordMapper $ words $ unwords $ lines content
    | otherwise = parNgramReducer $ parNgramMapper n $ map words $ lines content

main :: IO ()
main = do
    [filename] <- getArgs
    putStrLn "Enter the number of words you want suggestion for (1 for a single word):"
    n <- getLine
    putStrLn "Loading Dictionary ..."
    content <- wordClean filename
    let output = processMapReduce (read n::Int) content 
    writeFile "../Output/par_output.txt" (show output)
    putStrLn "Done loading!"
    enterLoop output
    --print $ head $ suggestion_sort $ par_suggestion_filer str output
    --print $ head $ suggestion_sort $ suggestion_filer str output