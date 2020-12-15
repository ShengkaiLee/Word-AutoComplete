module Suggestion_Parallel where
import Data.List ( isPrefixOf, sortBy )
import Data.List.Split ( chunksOf )
import Control.Parallel.Strategies
    ( parList, rdeepseq, using, NFData )

suggestion_filer :: Eq a => [a] -> [([a], b)] -> [([a], b)]
suggestion_filer str l = filter (\(x,_)->str `isPrefixOf` x) l

par_suggestion_filer :: (Eq a, NFData a, NFData b) => [a] -> [([a], b)] -> [([a], b)]
par_suggestion_filer str l = suggestion_filer str $ concat
                         ((map (suggestion_filer str) l') `using` parList rdeepseq)
                         where l' = chunksOf 9 l

suggestion_sort :: [(a, Int)] -> [(a, Int)]
suggestion_sort = sortBy (\(_,x) (_, y) -> compare y (x::Int))