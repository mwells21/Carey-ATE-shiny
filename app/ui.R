#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shinydashboard)
library(DT)
library(shiny)
library(shinyWidgets)
library(rhandsontable)
library(shinyLP)
library(shinyBS)
library(shinybusy)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel(""),

    fluidRow(
        column(
            width = 8,
            offset = 2,
            jumbotron(
                header = 'Treatment Effect Estimator',
                content = "Comparing simple linear regression to causal forest methods",
                button = T,
                buttonLabel = "Run"
            ),
            bsModal("importModal", "Import Data", "tabBut", size = "large",
                    div(
                        fluidRow(
                            column(
                                12, align = "center",
                                fileInput("file1", "Choose CSV File",
                                          multiple = FALSE,
                                          accept = c("text/csv",
                                                     "text/comma-separated-values,text/plain",
                                                     ".csv")),
                                uiOutput("dependent"),
                                uiOutput("treatment"),
                                uiOutput("independents"),
                                actionButton(inputId = "btn_modal_import",label = "Next",width = "50%",class = "btn-primary"),
                                tags$head(tags$style("#importModal .modal-footer{ display:none}"))
                                
                            )
                        )
                    )),
            bsModal("tuneModal", "Tune Model",trigger = NULL,size = "large",
                    uiOutput("tuneModalUI"),
                    tags$head(tags$style("#tuneModal .modal-footer{ display:none}"))),
            bsModal("proModal", "Processing",trigger = NULL,size = "large",
                    uiOutput("proModalUI"),
                    tags$head(tags$style("#proModal .modal-footer{ display:none}")))
        )
        
    )
))
