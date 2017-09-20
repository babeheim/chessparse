
rm(list=ls())

library(jsonlite)
library(stringi) # essential

source('./R/read_pgn.R')

file <- "./raw_data/test.pgn"
pgn_lines <- readLines(file)
element_type <- as.numeric(substr(pgn_lines, 1, 1)=="[")
stops <- which(element_type=="0" & 
  element_type[c(2:length(element_type), 1)]=="1")
starts <- c(1, stops[-length(stops)]+1)
n_games <- length(starts)

for(i in 1:n_games){
  game_lines <- pgn_lines[starts[i]:stops[i]]
  x <- parse_pgn(game_lines)
  if(i %% 100 == 0) print(i)
}


file <- "./raw_data/test.pgn"
d <- read_pgn(file)
dj <- toJSON(d)
writeLines(dj)
d <- read_json('./test.json', simplifyVector=TRUE)
d <- df_list_to_dataframe(d)




big_files <- list.files('./raw_data', pattern="ChessData", full.names=TRUE)

for(j in 1:length(big_files)){

  file <- big_files[j]
  pgn_lines <- readLines(file)
  element_type <- as.numeric(substr(pgn_lines, 1, 1)=="[")
  stops <- which(element_type=="0" & 
    element_type[c(2:length(element_type), 1)]=="1")
  starts <- c(1, stops[-length(stops)]+1)
  n_games <- length(starts)

  for(i in 1:n_games){
    game_lines <- pgn_lines[starts[i]:stops[i]]
    x <- parse_pgn(game_lines)
    if(i %% 100 == 0) print(i)
  }
  print(big_files[j])

}



big_files <- list.files('./raw_data', pattern="ChessData", full.names=TRUE)

for(j in 1:length(big_files)){

  file <- big_files[j]
  d <- read_pgn(file)
  # writeLines(toJSON(d, pretty=TRUE))
  # d <- read_json('./test.json', simplifyVector=TRUE)

}