
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
  pgn_tag <- gsub("[\x01-\x1F]", "", pgn_tag) # takes care of non-printing ASCII
  leading_space <- as.numeric(regexpr(" ", pgn_tag))
  key <- substr(pgn_tag, 2, leading_space-1)
  value <- substr(pgn_tag, leading_space+1, nchar(pgn_tag)-1)
  value <- gsub("\"", "", value)
  value <- gsub(" $", "", value)
  pair <- as.list(value)
  names(pair) <- key
  return(pair)
}


read_pgn <- function(file){
  raw <- readLines(file)
  output <- parse_pgn(raw)
  return(output)
}

sapply_pb <- function(X, FUN, ...){
  env <- environment()
  pb_Total <- length(X)
  counter <- 0
  pb <- txtProgressBar(min = 0, max = pb_Total, style = 3)

  wrapper <- function(...){
  curVal <- get("counter", envir = env)
  assign("counter", curVal +1 ,envir=env)
  setTxtProgressBar(get("pb", envir=env), curVal +1)
  FUN(...)
  }
  res <- sapply(X, wrapper, ...)
  close(pb)
  res
}
