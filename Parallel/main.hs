import NgramCount ( par_mapper, par_reducer )
import WordClean ( wordClean )
import Suggestion_Parallel ( par_suggestion_filer, suggestion_sort, suggestion_filer ) 
import System.Environment ( getArgs )


main :: IO ()
main = do
    [n, filename, str] <- getArgs
    content <- wordClean filename
    let input = map words $ lines content
    let output = par_reducer $ par_mapper (read n) input
    print $ head $ suggestion_sort $ par_suggestion_filer str output
    --print $ head $ suggestion_sort $ suggestion_filer str output