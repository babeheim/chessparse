

parse_pgn <- function(pgn_lines){
  element_type <- as.numeric(substr(pgn_lines, 1, 1)=="[")
  stops <- which(element_type=="0" & 
    element_type[c(2:length(element_type), 1)]=="1")
  starts <- c(1, stops[-length(stops)]+1)
  n_games <- length(starts)
  output <- list()
  if( n_games == 1 ){
    game_record <- pgn_lines
    meta <- list()
    moves <- character()
    for(i in 1:length(game_record)){
      # if is tag
      if(substr(game_record[i], 1, 1)=="["){
        tag <- extract_tag(game_record[i])
        meta <- c(meta, tag)
      }
      # if is game moves
      if(substr(game_record[i], 1, 1) %in% c(letters, LETTERS, 0:9)){
        moves <- paste(moves, game_record[i])
      }
    }

    moves <- strsplit(moves, " [1-9]\\. | [1-9][0-9]\\. ")[[1]][-1]
    moves <- unlist(strsplit(moves, " "))
  
    output <- meta
    output$hash_id <- substr(sha1(moves), 1, 13) # lucky number!
    output$moves <- moves
  }
  if( n_games > 1 ){

    output <- sapply_pb(1:n_games, function(z) parse_pgn(pgn_lines[starts[z]:stops[z]]))

  }
  return(output)
}

