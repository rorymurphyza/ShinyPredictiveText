## read data into workspace
## this should be automated at some point, but not now

## read twitter
twitterFile <- file("Data/final/en_US/en_US.twitter.txt", "rb")
twitter  <- readLines(twitterFile)

## read blogs
blogsFile <- file("Data/final/en_US/en_US.blogs.txt", "rb")
blogs <- readLines(blogsFile)

## read news
newsFile <- file("Data/final/en_US/en_US.news.txt", "rb")
news <- readLines(newsFile)