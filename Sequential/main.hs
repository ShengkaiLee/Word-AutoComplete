import NgramCount_Sequential ( mapper, reducer )
import WordClean_Sequential ( wordClean )

import System.Environment ( getArgs )


main :: IO ()
main = do
    [n, filename] <- getArgs
    content <- wordClean filename
    let input = words $ unwords $ lines content
    let output = reducer $ mapper (read n) input
    writeFile "sqe.txt" (show output)