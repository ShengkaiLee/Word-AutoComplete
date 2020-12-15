module Suggestion_Sequential where
import Data.List ( isPrefixOf, sortBy )

suggestion_filer :: Eq a => [a] -> [([a], b)] -> [([a], b)]
suggestion_filer str l = filter (\(x,_)->str `isPrefixOf` x) l

suggestion_sort :: [(a, Int)] -> [(a, Int)]
suggestion_sort = sortBy (\(_,x) (_, y) -> compare x (y::Int))