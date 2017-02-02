#ui.R

library(shiny)

ui =fluidPage(
  fluidRow(
            column(12, align = 'center', wellPanel(h1("Welcome to my word predictor")))
          ),
  mainPanel(width='100%',
            fluidRow(column(3, wellPanel(
                                         p("You will get a new word every time you press <Spacebar>."),
                                         p("It has been noted that the internet connection at Shiny will affect the performance of the app."))),
            fluidRow(column(6, wellPanel(textInput("textBox", label = '', width = '100%', placeholder="Start typing..."),
                                          verbatimTextOutput("outputSpot"),
                                          div(style="display:inline-block",uiOutput("my_button1")),
                                          div(style="display:inline-block",uiOutput("my_button2")),
                                          div(style="display:inline-block",uiOutput("my_button3"))
                                         )),
            fluidRow(column(3, wellPanel(h4("Please have a look here if you need more information"),
                                         #The radiobuttons to select footer contents. If possible, maybe we can style these to look more like buttons or even hyperlinks
                                         radioButtons("footerSelector", "", selected = character(0),
                                                      c('Predictor' = 'Predictor',
                                                        'Instructions' = 'Instructions')))))
                            )
                    )
            ),
  conditionalPanel(width = '100%', "input.footerSelector == 'Predictor'",
                   mainPanel(width = '100%',
                             fluidRow(column(1),
                                      fluidRow(column(10, 
                                                      wellPanel(h3("This predictor model works similarly to the Swift Key keyboard"),
                                                                p("This predictor uses Stupid Backoff"),
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
  
