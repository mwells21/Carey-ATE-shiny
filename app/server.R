#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    
    #---- Files -----
    filedata <- reactive({
        infile <- input$file1
        if (is.null(infile)){
            return(NULL)      
        }
        read.csv(infile$datapath)
    })
    
    
    #---- Modals ----
    
    importModal = function(failed = F){
        modalDialog(
            h2("Hello World"),
            footer = tagList(
                modalButton("Cancel"),
                actionButton("ok", "OK")
            )
            
        )
    }
    

    #---- Events ---- 
    observeEvent(input$btn_modal_import,{
        toggleModal(session, "importModal",toggle = "close")
        toggleModal(session, "tuneModal",toggle = "open")
    })
    
    observeEvent(input$btn_modal_tune,{
        toggleModal(session, "tuneModal",toggle = "close")
        toggleModal(session, "proModal",toggle = "open")
    })
    
    
    #---- Render Modal UI ----
    output$dependent  = renderUI({
        df <- filedata()
        if (is.null(df)) return(NULL)
        items=names(df)
        names(items)=items
        selectInput("dependent","Select ONE variable as dependent variable",items)
    })
    
    output$independents <- renderUI({
        df <- filedata()
        if (is.null(df)) return(NULL)
        items=names(df)
        names(items)=items
        selectInput("independents","Select ONE or MANY independent variables",items,multiple=TRUE)
    })
    
    output$tuneModalUI = renderUI({
        actionButton(inputId = "btn_modal_tune",label = "test2")
    })
    output$proModalUI = renderUI({
        h2("DONE")
    })
    
})
