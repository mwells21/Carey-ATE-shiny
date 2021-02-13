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
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Casual Forest", theme = shinytheme("flatly"),
                   tabPanel("About"),
                   tabPanel("Analyze",
                              fluidPage(
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
                                                  uiOutput("importModalUI"),
                                                  tags$head(tags$style("#importModal .modal-footer{ display:none}"))),
                                          bsModal("tuneModal", "Tune Model",trigger = NULL,size = "large",
                                                  uiOutput("tuneModalUI"),
                                                  tags$head(tags$style("#tuneModal .modal-footer{ display:none}"))),
                                          bsModal("proModal", "Results",trigger = NULL,size = "large",
                                                  uiOutput("proModalUI"),
                                                  tags$head(tags$style("#proModal .modal-footer{ display:none}")))
                                      )
                                      
                                  )
                              )  
                            )

    # Application title

))
