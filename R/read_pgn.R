


nullToNA <- function(x) {
    x[sapply(x, is.null)] <- NA
    return(x)
}

df_list_to_dataframe <- function( input_list ){
    for(i in 1:ncol(input_list)){
        if(class(input_list[,i])=="list"){
            empty <- which(lapply(input_list[,i], class)=="list")
            if(length(empty)>0) input_list[empty,i] <- NA
            input_list[,i] <- unlist(nullToNA(input_list[,i]))
        }
    }
    input_list
}


extract_tag <- function(pgn_tag){

  # pgn_tag <- iconv(pgn_tag, "latin1", "ASCII", sub="") # strip out non-ASCII entirely
  pgn_tag <- stringi::stri_trans_general(pgn_tag, "latin-ascii") # convert non-ASCII to closest ascii

  leading_space <- as.numeric(regexpr(" ", pgn_tag))
  key <- substr(pgn_tag, 2, leading_space-1)
  value <- substr(pgn_tag, leading_space+1, nchar(pgn_tag)-1)
  
  value <- gsub("\"", "", value)
  value <- gsub(" $", "", value)
  pair <- as.list(value)
  names(pair) <- key
  return(pair)
}

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
    for(i in 1:n_games){
      each_game <- pgn_lines[starts[i]:stops[i]]
      output[[i]] <- parse_pgn(each_game)
    }
  }
  return(output)
}


read_pgn <- function(file){
  raw <- readLines(file)
  output <- parse_pgn(raw)
  return(output)
}


# sapply_pb <- function(X, FUN, ...){
#   env <- environment()
#   pb_Total <- length(X)
#   counter <- 0
#   pb <- txtProgressBar(min = 0, max = pb_Total, style = 3)

#   wrapper <- function(...){
#     curVal <- get("counter", envir = env)
#     assign("counter", curVal +1 ,envir=env)
#     setTxtProgressBar(get("pb", envir=env), curVal +1)
#     FUN(...)
#   }
#   res <- sapply(X, wrapper, ...)
#   close(pb)
#   res
# }

# testit <- function(x = sort(runif(20)), ...)
#      {
#          pb <- txtProgressBar(...)
#          for(i in c(0, x, 1)) {Sys.sleep(0.5); setTxtProgressBar(pb, i)}
#          Sys.sleep(1)
#          close(pb)
#      }
#      testit()
#      testit(runif(10))
#      testit(style = 3)
     
