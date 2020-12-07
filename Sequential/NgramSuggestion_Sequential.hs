module NgramSuggestion_Sequential where
import Data.List ( isPrefixOf, sortBy )

ngram_filer :: Eq a => [a] -> [([a], b)] -> [([a], b)]
ngram_filer str l = filter (\(x,_)->str `isPrefixOf` x) l

ngram_sort :: [(a, Int)] -> [(a, Int)]
ngram_sort = sortBy (\(_,x) (_, y) -> compare x (y::Int))