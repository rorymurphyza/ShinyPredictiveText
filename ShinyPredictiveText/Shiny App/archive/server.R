#server.R
library(shiny)
source("wordPredictor.R")

pred1 = NULL
pred2 = NULL
pred3 = NULL
#wordPredictor <- function(tmp)
#{
#  trailingChar = substr(tmp, nchar(tmp), nchar(tmp))
#  if (trailingChar == ' ')
#  {
#    print("Space detected")
#  }
#  pred1 = paste(rev(strsplit(tmp, split = "")[[1]]), collapse = "") 
#  pred2 = toupper(tmp)
#  pred3 = tolower(tmp)
#  
#  cbind(pred1, pred2, pred3)
#}

#This is the main function.
#Pass the sentence in here and get the outputs back, written in to their space correctly
receiveInput <- function(tmp)
{
  wordPredictor(tmp)
}

shinyServer(
  function(input, output)
  {
    v = reactiveValues(instructionCounter = 1L, showFooter = FALSE)
    
    output$outputSpot <- function()
    {
      back <- receiveInput(input$textBox)
      output$prediction1 <- renderText(back[2])
      output$prediction2 <- renderText(back[1])
      output$prediction3 <- renderText(back[3])
      input$textBox
    }
    output$getFooter <- reactive(
      {
        return(v$instructionCounter)
      })
    observeEvent(input$prediction1, 
                 {
                   print("pressed");
                 })
  }
)