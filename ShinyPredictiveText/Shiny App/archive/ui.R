#ui.R

library(shiny)

shinyUI(
  fluidPage(
    #this updates all the time. we should call a function that only calculates when a seperate space key is received
    tags$script('$(document).on("keydown", function (e)
                { 
                  Shiny.onInputChange("outputSpot", e.which);
                  Shiny.onInputChange("prediction1", e.which);

                });'),
    tags$script('$(document).on("keydown", function (f)
                { 
                  Shiny.onInputChange("prediction1", f.which);

                });'),
    
    #Header panel/row start
    fluidRow(
      column(12, align = 'center', 
        wellPanel(h1("Header"))
            )
      ),
    #Header panel/row end
    
    #Body panel/row start
    mainPanel(width = '100%',
      #Body column 1 start
      fluidRow(
        column(4, 
          wellPanel(h2("Welcome to my word predictor"),
                    p("There should be multiple models here to choose from, let's see how it goes.")
                    )
          ),
      #Body column 1 end
      #Body column 2 start
      fluidRow(column(4, 
          wellPanel(
                    #Text input box. TODO: get this to wrap nicely if needed
                    textInput('textBox', '',width = '100%', placeholder = "Start typing..."),
                    verbatimTextOutput("outputSpot"),
                    mainPanel(width = '100%',
                    fluidRow(column(4, verbatimTextOutput("prediction1")),
                    fluidRow(column(4, verbatimTextOutput("prediction2")),
                    fluidRow(column(4, verbatimTextOutput("prediction3")))))
                    ))
          ),
      #Body column 2 end
      #Body column 3 start
      fluidRow(column(4, 
          wellPanel(h4("Please have a look here if you need more information"),
                    #The radiobuttons to select footer contents. If possible, maybe we can style these to look more like buttons or even hyperlinks
                    radioButtons("footerSelector", "", selected = character(0),
                    c('Predictor' = 'Predictor',
                      'Instructions' = 'Instructions'))
                    )
              )
          )
      #Body column 3 end
      )
    #Body panel/row end
    )),
    #Conditional footer panels
    #Draws conditions from radio buttons for the moment
    conditionalPanel(width = '100%', "input.footerSelector == 'Predictor'",
      mainPanel(width = '100%',
        fluidRow(column(1),
        fluidRow(column(10, 
          wellPanel(h3("This predictor model works similarly to the Swift Key keyboard"),
                    p("Simply type using your keyboard or the on-screen keyboard and we will try predict the next word you are looking for."),
                    p("Please keep in mind that we will only look for a new word when you press the <Spacebar> key.")
                    )
                )
              ),
        fluidRow(column(1))))
    ),
    conditionalPanel(width = '100%', "input.footerSelector == 'Instructions'",
      mainPanel(width = '100%',
                fluidRow(column(1),
                fluidRow(column(10,
                                wellPanel(h3("Instructions"),
                                          p("Simply type into the keyboard, like you would on a smartphone."),
                                          p("As with the normal Swift Keyboard, the predicted next word is in the centre box, with the next most likely on the left and the least likely on the right-hand side")
                                          )
                                ),
                fluidRow(column(1))
                        )
                        )
                )  
                    )
    )
)