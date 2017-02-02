build <- function(...)
{
  fileDirectory = "Data/final/en_US/en_US."
  source('~/RWorkspace/Capstone Project/parallelisTasks.R')
  
  ##Read Files
  blogsFile = file(paste(fileDirectory, "blogs.txt", sep = ""), "rb")
  blogs = readLines(blogsFile)
  twitterFile = file(paste(fileDirectory, "twitter.txt", sep = ""), "rb")
  twitter = readLines(twitterFile)
  newsFile = file(paste(fileDirectory, "news.txt", sep =""), "rb")
  news = readLines(newsFile)
  rm(fileDirectory, blogsFile, twitterFile, newsFile)
  
  ##Take Samples
  sampleSize = 0.005
  set.seed(5421)
  blogs = sample(blogs, length(blogs) * sampleSize)
  news = sample(news, length(news) * sampleSize)
  twitter = sample(twitter, length(twitter) * sampleSize)
  
  
  ##TODO: remove profanity
  
  ##https://rpubs.com/erodriguez/nlpquanteda
  library(quanteda)
  corpus = c(blogs, news, twitter)
  rm(blogs, news, twitter)
  sentences = tokenize(corpus, what = "sentence", removeNumbers = TRUE, removePunct = TRUE, removeSymbols = TRUE, removeSeparators = TRUE, removeTwitter = TRUE, removeHyphens = TRUE)
  rm(corpus)
  sentences = toLower(sentences)
  ##REMOVE HERE
  sentences = unlist(sentences)
  
  makeTokens <- function(input, n = 1L)
  {
    tokenize(input, what = "word", removeNumbers = TRUE, removePunct = TRUE, removeSymbols = TRUE, removeSeparators = TRUE, removeTwitter = TRUE, removeHyphens = TRUE, ngrams = n, simplify = TRUE)  
  }
  
  ngram1 = paralleliseTasks(makeTokens, sentences, 1)
  ngram2 = paralleliseTasks(makeTokens, sentences, 2)
  ngram3 = paralleliseTasks(makeTokens, sentences, 3)
  ngram4 = paralleliseTasks(makeTokens, sentences, 4)
  rm(sentences)
  
  dfm1 = paralleliseTasks(dfm, ngram1)
  dfm2 = paralleliseTasks(dfm, ngram2)
  dfm3 = paralleliseTasks(dfm, ngram3)
  dfm4 = paralleliseTasks(dfm, ngram4)
  
  library(data.table)
  dt1 = data.table(ngram = features(dfm1), count = colSums(dfm1), key = "ngram")
  dt2 = data.table(ngram = features(dfm2), count = colSums(dfm2), key = "ngram")
  dt3 = data.table(ngram = features(dfm3), count = colSums(dfm3), key = "ngram")
  dt4 = data.table(ngram = features(dfm4), count = colSums(dfm4), key = "ngram")
  rm(ngram1, ngram2, ngram3, ngram4, dfm1, dfm2, dfm3, dfm4)
  
  ##sort largest to smallest
  dt1 = dt1[order(-count)]
  dt2 = dt2[order(-count)]
  dt3 = dt3[order(-count)]
  dt4 = dt4[order(-count)]
  
  phrase = dt3[1]$ngram
  temp <- head(dt4[grep(paste("^", phrase, "_?", sep = ""), dt4$ngram)], 10)
}