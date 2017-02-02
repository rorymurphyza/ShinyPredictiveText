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
receiveInput <- function(tmp, update=FALSE)
{
  if (update)
  {
    back <- wordPredictor(tmp)
  }
  print("server updating back")
  print(back)
  assign("back", back, .GlobalEnv)
  print(back)
  back
}

server = function(input, output, session){
  print("starting server")
  back <- receiveInput(NULL, TRUE)
  my_clicks <- reactiveValues(data1 = NULL)
  
  output$outputSpot <- function()
  {print("updating outputSpot")
    back <- receiveInput(input$textBox, TRUE)
    output$my_button1 <- renderUI({actionButton("action1", label = back[2])})
    output$my_button2 <- renderUI({actionButton("action2", label = back[1])})
    output$my_button3 <- renderUI({actionButton("action3", label = back[3])})
    print(back)
    input$textBox
  }
  
  observeEvent(input$action1, {
    back <- receiveInput(input$textBox, FALSE)
    assign("back", back, .GlobalEnv)
    updateTextInput(session, "textBox", value = paste(input$textBox, back[2], " ", sep = ""))
    my_clicks$data1 <- input$sample1
  })
  
  observeEvent(input$action2, {
    back <- receiveInput(input$textBox, FALSE)
    assign("back", back, .GlobalEnv)
    updateTextInput(session, "textBox", value = paste(input$textBox, back[1], " ", sep = ""))
    my_clicks$data1 <- input$sample2
  })
  
  observeEvent(input$action3, {
    back <- receiveInput(input$textBox, FALSE)
    assign("back", back, .GlobalEnv)
    updateTextInput(session, "textBox", value = paste(input$textBox, back[3], " ", sep = ""))
    my_clicks$data1 <- input$sample3
  })  
  
  output$text1 <- renderText({ print("returning default")
    if (is.null(my_clicks$data1)) return("default")
    my_clicks$data1
  })
  
  #set up the default values for when the app first runs
  #these are essentially the most common words to start a sentence with
  output$my_button1 <- renderUI({print("setting default for action1")
    if (is.null(my_clicks$data1)) 
    {
      suppressWarnings(receiveInput(NULL, TRUE))
      output$my_button1 <- renderUI({actionButton("action1", label = back[2])})
      NULL
    }
      })
  
  output$my_button2 <- renderUI({print("setting default for action2")
    if (is.null(my_clicks$data1))
    {
      output$my_button2 <- renderUI({actionButton("action2", label = back[1])})
      NULL
    }
  })
  
  output$my_button3 <- renderUI({print("setting default for action3")
    if (is.null(my_clicks$data1))
    {
      output$my_button3 <- renderUI({actionButton("action3", label = back[3])})
      NULL
    }
  })
}









