
rm(list=ls())

library(jsonlite)

library(devtools)
devtools::load_all()

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




d <- read_pgn("./raw_data/test.pgn")
dj <- toJSON(d)
writeLines(dj, "test.json")
d <- read_json('./test.json', simplifyVector=TRUE)





d <- read_pgn("./raw_data/ChessData (1).pgn")
dj <- toJSON(d)
writeLines(dj, "test.json")
d <- read_json('./test.json', simplifyVector=TRUE)

move_tab <- matrix(NA, nrow=length(d$moves), ncol=10)

for(i in 1:length(d$moves)) if(!is.null(d$moves[[i]][1:10])) move_tab[i,] <- d$moves[[i]][1:10]
colnames(move_tab) <- c("m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10")

d <- d[-which(names(d)=="moves")] # how to fix?
d <- df_list_to_dataframe(d)

d <- cbind(d, move_tab)





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