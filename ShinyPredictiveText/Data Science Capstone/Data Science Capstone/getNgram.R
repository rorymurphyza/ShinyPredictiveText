##We want to use this to format the ngrams we are going to use later

getNgram <- function(sampleSize = 0.05, phraseLength = 1, verbose = TRUE) 
{
    source("~/RWorkspace/Capstone Project/Data Science Capstone/Data Science Capstone/getCurrentEnvironment.R");
        
    if (verbose)
        print(paste("Starting now. Looking for a sampleSize of", sampleSize, "and phrases of length", phraseLength));
    ptm = proc.time();

    fileDirectory = "~/RWorkspace/Capstone Project/Data/final/en_US/en_US.";
    blogsFile = file(paste(fileDirectory, "blogs.txt", sep = ""), "rb");
    blogs = readLines(blogsFile);
    close(blogsFile);
    if (verbose) {
        time = proc.time() - ptm;
        print(paste("Blogs file read. Elapsed time =", time[3], ". Total time =", time[1]))
    }
    


    
    #twitterFile = file(paste(fileDirectory, "twitter.txt", sep = ""), "rb");
    #twitter = suppressWarnings(readLines(twitterFile));
    #close(twitterFile);
    #newsFile = file(paste(fileDirectory, "news.txt", sep = ""), "rb");
    #news = readLines(newsFile);
    #close(newsFile);

    if (verbose) {
        print(paste("Source files have been collected. Current memory allocation is", getCurrentEnvironment()));
    }
}