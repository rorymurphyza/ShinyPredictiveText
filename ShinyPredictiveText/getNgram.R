##We want to use this to format the ngrams we are going to use later

getNgram <- function(sampleSize = 5, phraseLength = 1, verbose = TRUE) 
{
  options(digits = 2)
  source('~/RWorkspace/Capstone Project/helpers.R')
  
  if (verbose)
    print(paste("Starting now. Looking for a sampleSize of", sampleSize, "and phrases of length", phraseLength));
  ptm = proc.time();
  
  sampleSize = sampleSize / 100;
  
  fileDirectory = "Data/final/en_US/en_US.";
  #Read blogs file
  blogsFile = file(paste(fileDirectory, "blogs.txt", sep = ""), "rb");
  blogs = readLines(blogsFile);
  close(blogsFile);
  if (verbose) 
  {
      print(paste("Blogs file read."));
  }
  #Read twitter file
  twitterFile = file(paste(fileDirectory, "twitter.txt", sep = ""), "rb");
  twitter = suppressWarnings(readLines(twitterFile));
  close(twitterFile);
  if (verbose)
  {
    print(paste("Twitter file read."));
  }
  #Read news file
  newsFile = file(paste(fileDirectory, "news.txt", sep = ""), "rb");
  news = readLines(newsFile);
  close(newsFile);
  if (verbose)
  {
    print(paste("News file read."));
  }
  
  #Sample each file
  if (verbose)
  {
    print(paste("Sampling at ", sampleSize*100, "%,",sep = ""))
  }
  set.seed(5421)
  blogs = sample(blogs, length(blogs) * sampleSize)
  news = sample(news, length(news) * sampleSize)
  twitter = sample(twitter, length(twitter) * sampleSize)
  
  #Combine sampled files into corpus
  corpus = c(blogs, news, twitter)
  rm(blogs, news, twitter, blogsFile, newsFile, twitterFile)
  
  #Display some stats on the corpus
  library(stringi)
  temp = as.character(corpus)
  words = stri_flatten(temp, collapse = " ")
  words = unlist(stri_extract_all_words(words, locale = "en"))
  if (verbose)
  {
    print(paste("Current corpus has", length(words), "words and", 
                length(unique(words)), "unique words."));
  }
  rm(temp, words);
  
  #Get the ngrams
  if (verbose)
  {
    print(paste("Starting the tokenization process"));
    print(paste("Tokenizing corpus to sentences"));
  }
  library(quanteda)
  sentences = tokenize(corpus, what = "sentence",
                       removeNumbers = TRUE, 
                       removePunct = TRUE, 
                       removeSymbols = TRUE, 
                       removeSeparators = TRUE, 
                       removeTwitter = TRUE, 
                       removeHyphens = TRUE);
  if (verbose)
  {
    print(paste("Sentences have been tokenized,", length(sentences), "found."))
  }
  rm(corpus)
  #TODO: Remove profanity
  sentences = toLower(sentences);
  sentences = unlist(sentences);
  #sentences <- unlist(lapply(sentences, function(x) paste('#s#', tolower(x), sep = "")))
  ngram = paralleliseTasks(makeTokens, sentences, phraseLength);
  if (verbose)
  {
    print("Ngrams have been tokenized.")
  }
  rm(sentences)
  dfm = paralleliseTasks(dfm, ngram)
  if (verbose)
  {
    print("dfm has been created.")
  }
  library(data.table)
  dt = data.table(ngram = features(dfm), 
                  count = colSums(dfm),
                  key = "ngram")
  
  #Save dt into csv file
  outputFile = paste("/Users/rorym/Documents/RWorkspace/Capstone Project/Data/",
                     "DataTable -", 
                     sampleSize * 100,
                     "-",
                     phraseLength,
                     ".csv")
  write.csv(dt, outputFile);
  if (verbose)
  {
    print(paste("Data file saved as", outputFile))
  }
}

#values = data.frame(sampleSize = c(20,20,20,20,40,40,40,40,50,50,50,50,60,60,60,60,75,75,75,75,100,100,100,100), ngramSize = c(1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4))
#sapply(1:32, function(x) {getNgram(sampleSize = values$sampleSize[x], phraseLength = values$ngramSize[x])})











