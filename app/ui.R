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

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Treatment Effect Estimator"),

    fluidRow(
        column(
            width = 8,
            offset = 2,
            h2("Hello World")
        )
        
    )
))
