#INPUT: The string that needs a prediction
#OUTPUT: A vector of the 3 predicted words to be displayed on the screen, in order of probability

wordPredictor <- function(input)
{
  require(dplyr)
  readFiles()
  pred1 = " "
  pred2 = " "
  pred3 = " "
  
  #we are sent a null sentence. we want to predict three most common 1-grams
  if (is.null(input))
  {
    #set the predictions according to the file we read
    pred1 = startGrams$ngram[1]
    pred2 = startGrams$ngram[2]
    pred3 = startGrams$ngram[3]
    
    back <- cbind(pred1, pred2, pred3)
    assign("back", back, .GlobalEnv)
    return(back)
  }
  
  #trailingChar is used to check if a space has been detected.
  #at this point, we only want to check for predictions when space is hit
  trailingChar = substr(input, nchar(input), nchar(input))
  if (trailingChar == ' ')
  {
    print("Space detected")
    input = substr(input, 0, nchar(input)-1)
    words = getWords(input)
    print(paste(length(words), "words found"))
    
    ngramList <- ngrammer(words)
    temp <- prediction(words, ngramList)
    
    #these are the words that are going to be sent back to the display
    pred1 = temp$output[1] 
    pred2 = temp$output[2]
    pred3 = temp$output[3]
    
    back <- cbind(pred1, pred2, pred3)
    assign("back", back, .GlobalEnv)
    return(back)
  }
  else
  {
    return(back)
  }
}

prediction <- function(input, ngramList)
{
  #slice on last word
  print("prediction hit")
  print(paste(dim(ngramList)[1], "ngrams in total"))
  ngramList = ngramList %>% filter(col1 == input[length(input)])
  print(paste(dim(ngramList)[1], "after slicing"))
  if (dim(ngramList)[1] < 3)
  {
    return(fillInWords(ngramList))
  }
  
  #if (count(filter(ngramList, n == (length(input) - 1))) > 3) #we have more than 3 higher grams available, let's subset now on n-1
  #{
  #  ngramList = ngramList %>% filter(col2 == input[length(input) - 1])
  #  if (count(filter(ngramList, n == (length(input) - 2))) > 3)
  #  {
  #    ngramList = ngramList %>% filter(col3 == input[length(input) - 2])
  #  }
  #}
  
  print("working out probs")
  ngramList$prob = 0
  for (i in 1:dim(ngramList)[1])
  {
    if (ngramList$n[i] == 6)
      ngramList$prob[i] = ngramList$count[i] / sum(ngrams6$count)
    else if (ngramList$n[i] == 5)
      ngramList$prob[i] = ngramList$count[i] / sum(ngrams5$count)
    else if (ngramList$n[i] == 4)
      ngramList$prob[i] = ngramList$count[i] / sum(ngrams4$count)
    else if (ngramList$n[i] == 3)
      ngramList$prob[i] = ngramList$count[i] / sum(ngrams3$count)
    else if (ngramList$n[i] == 2)
      ngramList$prob[i] = ngramList$count[i] / sum(ngrams2$count)
    else if (ngramList$n[i] == 1)
      ngramList$prob[i] = ngramList$count[i] / sum(ngrams1$count)
  }
  
  print("working out sbo")
  ngramList$sbo = 0
  topOrder = max(ngramList$n)
  for (i in 1:dim(ngramList)[1])
    ngramList$sbo[i] = round(ngramList$prob[i] * 0.4^(topOrder - ngramList$n[i]), digits = 8)
  
  ngramList = ngramList %>% select(output, sbo)
  uniques = unique(ngramList$output)
  count = 0L
  while (length(unique(ngramList$output)) != dim(ngramList)[1])
  {
    if (count > 100)
    {
      break
    }
    
    count = count + 1
    s = sum(ngramList$sbo[ngramList$output == uniques[count]])
    w = uniques[count]
    
    ngramList = ngramList %>% filter(output != w)
    ngramList = rbind(c(w,s), ngramList)
    ngramList$sbo = as.numeric(ngramList$sbo)
  }
  
  print(paste("slicing again"))
  ngramList = ngramList %>% arrange(desc(sbo)) %>% slice(1:3)
  print(paste(dim(ngramList)[1], "after slicing again"))
  if (dim(ngramList)[1] >= 3)
    return(ngramList)
  else
  {
    return(fillInWords(ngramList))
  }
}

fillInWords <- function(ngramList)
{
  wordsNeeded = 3 - dim(ngramList)[1]
  if (wordsNeeded == 1)
  {
    ngramList <- ngramList %>% bind_rows(ngrams1[1,])
  }
  else if (wordsNeeded == 2)
  {
    ngramList <- ngramList %>% bind_rows(ngrams1[1,])
    ngramList <- ngramList %>% bind_rows(ngrams1[2,])
  }
  else
  {
    ngramList <- ngramList %>% bind_rows(ngrams1[1,])
    ngramList <- ngramList %>% bind_rows(ngrams1[2,])
    ngramList <- ngramList %>% bind_rows(ngrams1[3,])
  }
  return(ngramList)
}


ngrammer <- function(input)
{
  #select which ngram to use
  if (length(input) == 5)
  {
    print("6grams to be used")
    return(bind_rows(ngrams6, ngrams5, ngrams4, ngrams3, ngrams2, ngrams1))
  }
  else if (length(input) == 4)
  {
    print("5grams to be used")
    return(bind_rows(ngrams5, ngrams4, ngrams3, ngrams2, ngrams1))
  }
  else if (length(input) == 3)
  {
    print("4grams to be used")
    return(bind_rows(ngrams4, ngrams3, ngrams2, ngrams1))
  }
  else if (length(input) == 2)
  {
    print("3grams to be used")
    return(bind_rows(ngrams3, ngrams2, ngrams1))
  }
  else
  {
    print("2grams to be used")
    return(bind_rows(ngrams2, ngrams1))
  }
}

#return the words in the string as an array
getWords <- function(input)
{
  words = strsplit(input, " ")[[1]] 
}

#read the data files into structures for us to use
readFiles <- function()
{
  print("readFiles")
  if (!(exists("startGrams")))  #check if startGrams is valid in environment
  {
    #no startGrams, we can assume we want to read
    print("no startGrams found, read all files")
    
    print("reading startGrams")
    #use the specialist file for the most common sentence starting words
    startGrams <- read.csv("data/startGrams.csv", header = TRUE)
    startGrams$ngram <- as.character(startGrams$ngram)
    #start of sentence, so make the first letter a capital
    startGrams$ngram = lapply(startGrams$ngram, function(x) {paste(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)), sep = "")})
    assign("startGrams", startGrams, .GlobalEnv)
    print("startGrams read successfully")
    
    print("reading 1-grams")
    ngrams1 = read.csv("data/1grams.csv", header = TRUE)
    ngrams1$count = as.numeric(ngrams1$count)
    ngrams1$output = as.character(ngrams1$output)
    ngrams1 <- ngrams1 %>% select(output, count)
    ngrams1$n = 1
    assign("ngrams1", ngrams1, .GlobalEnv)
    print("ngrams1 read successfully")
    
    print("reading 2-grams")
    ngrams2 = read.csv("data/2grams.csv", header = TRUE)
    ngrams2$count = as.numeric(ngrams2$count)
    ngrams2$output = as.character(ngrams2$output)
    ngrams2$col1 = as.character(ngrams2$col1)
    ngrams2 <- ngrams2 %>% select(col1, output, count)
    ngrams2$n = 2
    assign("ngrams2", ngrams2, .GlobalEnv)
    print("ngrams2 read successfully")
    
    print("reading 3-grams")
    ngrams3 = read.csv("data/3grams.csv", header = TRUE)
    ngrams3$count = as.numeric(ngrams3$count)
    ngrams3$output = as.character(ngrams3$output)
    ngrams3$col1 = as.character(ngrams3$col1)
    ngrams3$col2 = as.character(ngrams3$col2)
    ngrams3 <- ngrams3 %>% select(col2, col1, output, count)
    ngrams3$n = 3
    assign("ngrams3", ngrams3, .GlobalEnv)
    print("ngrams3 read successfully")
    
    print("reading 4-grams")
    ngrams4 = read.csv("data/4grams.csv", header = TRUE)
    ngrams4$count = as.numeric(ngrams4$count)
    ngrams4$output = as.character(ngrams4$output)
    ngrams4$col1 = as.character(ngrams4$col1)
    ngrams4$col2 = as.character(ngrams4$col2)
    ngrams4$col3 = as.character(ngrams4$col3)
    ngrams4 <- ngrams4 %>% select(col3, col2, col1, output, count)
    ngrams4$n = 4
    assign("ngrams4", ngrams4, .GlobalEnv)
    print("ngrams4 read successfully")
    
    print("reading 5-grams")
    ngrams5 = read.csv("data/5grams.csv", header = TRUE)
    ngrams5$count = as.numeric(ngrams5$count)
    ngrams5$output = as.character(ngrams5$output)
    ngrams5$col1 = as.character(ngrams5$col1)
    ngrams5$col2 = as.character(ngrams5$col2)
    ngrams5$col3 = as.character(ngrams5$col3)
    ngrams5$col4 = as.character(ngrams5$col4)
    ngrams5 <- ngrams5 %>% select(col4, col3, col2, col1, output, count)
    ngrams5$n = 5
    assign("ngrams5", ngrams5, .GlobalEnv)
    print("ngrams5 read successfully")
    
    print("reading 6-grams")
    ngrams6 = read.csv("data/6grams.csv", header = TRUE)
    ngrams6$count = as.numeric(ngrams6$count)
    ngrams6$output = as.character(ngrams6$output)
    ngrams6$col1 = as.character(ngrams6$col1)
    ngrams6$col2 = as.character(ngrams6$col2)
    ngrams6$col3 = as.character(ngrams6$col3)
    ngrams6$col4 = as.character(ngrams6$col4)
    ngrams6$col5 = as.character(ngrams6$col5)
    ngrams6 <- ngrams6 %>% select(col5, col4, col3, col2, col1, output, count)
    ngrams6$n = 6
    assign("ngrams6", ngrams6, .GlobalEnv)
    print("ngrams6 read successfully")
  }
  else
  {
    print("environment is already populated")
  }
  print("done readFiles")
}

