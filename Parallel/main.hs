import NgramCount ( par_mapper, par_reducer )
import WordClean ( wordClean )

import System.Environment ( getArgs )


main :: IO ()
main = do
    [n, filename] <- getArgs
    content <- wordClean filename
    let input = map words $ lines content
    let output = par_reducer $ par_mapper (read n) input
    writeFile "Ngram.txt" (show output)
