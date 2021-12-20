#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# https://www.youtube.com/watch?v=eIpiL6y1oQQ&t=3649s&ab_channel=RockEDUScienceOutreach
library(shiny)
library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(RColorBrewer)
library(sf)
library(tigris)

#Loading data
df_NYT <- readRDS(file = "gpe_shiny_NYT.rds")
df_guardian <- readRDS(file = "GPE_shiny_guardian.rds")
df_contrast <- readRDS("GPE_shiny_contrast.rds")


# Define UI for application
ui <- fluidPage(
  
    #Application title
    titlePanel("The world's involvement in the Taliban-conflict"),
    
    #Sidebar with a date output
    sidebarLayout(
      
        sidebarPanel(
            tags$a(href="https://github.com/ah140797/taliban_newspapers", "Data Repository", target = "_blank"),
            h5("These maps illustrate the worlds involvement in the Taliban-conflict using New York Times and The Guardian as sources.
            The colors of the countries indicate the number of hits pr article in the year selected for the given country"),
            h5("You can switch between the tabs to select either New York Times, The Guardian and the Contrast"),
            h5("The panel Contrast shows the difference in the number of hits pr. article for a given country between
            New York Times and The Guardian. Positive values (green) indicate that the country has more hits pr. article in New York Times
            as compared to The Guardian and vice versa."),
            h5("Note that mentions of cities, regions etc. does not appear in the maps"),
            
        sliderInput(inputId = "date",
                    label = "Select a year",
                    min = 1996,
                    max = 2021,
                    value = 1996,
                    step = 1
                 )
        ),
    mainPanel(
        tabsetPanel(
            tabPanel("New York Times", leafletOutput("NYT")),
            tabPanel("The Guardian", leafletOutput("guardian")),
            tabPanel("Contrast", leafletOutput("contrast"))
        )
    )
    )
  )


#define server logic
server <- function(input, output) {
    
    #------------------------New York Times-------------------------------------
    year_NYT <- reactive({
        w <- df_NYT %>% filter(year == input$date)
        return(w)
    })
    
    output$NYT <- renderLeaflet({
        # Create a color palette with handmade bins. NB. play around with bin numbers
        mybins <- c(0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.1, 0.2, max(df_NYT$penalized_count))
        mypalette <- colorBin(palette="YlOrRd", domain=df_NYT$penalized_count, bins=mybins)
        
        # Prepare the text for tooltips:
        mytext <- paste(
            "Country: ", year_NYT()$country,"<br/>", 
            "Number of hits per article: ", year_NYT()$penalized_count_round, sep="") %>%
            lapply(htmltools::HTML)
        
        # Final Map
        leaflet(year_NYT()) %>% 
            addTiles()  %>% 
            setView(lat=10, lng=0 , zoom=1.5) %>%
            addPolygons( 
                fillColor = ~mypalette(year_NYT()$penalized_count), 
                stroke=TRUE, 
                fillOpacity = 0.9, 
                color="white", 
                weight=0.3,
                label = mytext,
                highlightOptions = highlightOptions(weight = 2,
                                                    fillOpacity = 1,
                                                    color = "black",
                                                    opacity = 1,
                                                    bringToFront = TRUE),
                labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), 
                                            textsize = "13px", 
                                            direction = "auto")) %>% 
            
            addLegend(pal=mypalette,
                      values=~penalized_count,
                      opacity=0.9, title = "Number of hits pr. article",
                      position = "bottomright")
        
    })
    
    
    #--------------------------------The Guardian-------------------------------
    year_guardian <- reactive({
      w <- df_guardian %>% filter(year == input$date)
      return(w)
    })
    
    output$guardian <- renderLeaflet({
      # Create a color palette with handmade bins. NB. play around with bin numbers
      mybins <- c(0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.1, 0.2, max(df_guardian$penalized_count))
      mypalette <- colorBin(palette="YlOrRd", domain=df_guardian$penalized_count, bins=mybins)
      
      # Prepare the text for tooltips:
      mytext <- paste(
        "Country: ", year_guardian()$country,"<br/>", 
        "Number of hits per article: ", year_guardian()$penalized_count_round, sep="") %>%
        lapply(htmltools::HTML)
      
      # Final Map
      leaflet(year_guardian()) %>% 
        addTiles()  %>% 
        setView(lat=10, lng=0 , zoom=1.5) %>%
        addPolygons( 
          fillColor = ~mypalette(year_guardian()$penalized_count), 
          stroke=TRUE, 
          fillOpacity = 0.9, 
          color="white", 
          weight=0.3,
          label = mytext,
          highlightOptions = highlightOptions(weight = 2,
                                              fillOpacity = 1,
                                              color = "black",
                                              opacity = 1,
                                              bringToFront = TRUE),
          labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), 
                                      textsize = "13px", 
                                      direction = "auto")) %>% 
        
        addLegend(pal=mypalette,
                  values=~penalized_count,
                  opacity=0.9, title = "Number of hits pr. article",
                  position = "bottomright")
      
    }) 
    
    #--------------------------------Contrast-------------------------------
    year_contrast <- reactive({
      w <- df_contrast %>% filter(year == input$date)
      return(w)
    })
    
    output$contrast <- renderLeaflet({
      # Create a color palette with handmade bins. NB. play around with bin numbers
      mybins <- c(min(df_contrast$contrast), -0.05, -0.0375, -0.025, -0.0125, 0, 0.0125, 0.025, 0.0375, 0.05, max(df_contrast$contrast))
      mypalette <- colorBin(palette="PRGn", domain=df_contrast$contrast, bins=mybins)
      
      # Prepare the text for tooltips:
      mytext <- paste(
        "Country: ", year_contrast()$country,"<br/>", 
        "Contrast: ", year_contrast()$contrast_round, sep="") %>%
        lapply(htmltools::HTML)
      
      # Final Map
      leaflet(year_contrast()) %>% 
        addTiles()  %>% 
        setView(lat=10, lng=0 , zoom=1.5) %>%
        addPolygons( 
          fillColor = ~mypalette(year_contrast()$contrast), 
          stroke=TRUE, 
          fillOpacity = 0.9, 
          color="white", 
          weight=0.3,
          label = mytext,
          highlightOptions = highlightOptions(weight = 2,
                                              fillOpacity = 1,
                                              color = "black",
                                              opacity = 1,
                                              bringToFront = TRUE),
          labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), 
                                      textsize = "13px", 
                                      direction = "auto")) %>% 
        
        addLegend(pal=mypalette,
                  values=~contrast,
                  opacity=0.9, title = "Contrast",
                  position = "bottomright")
      
    }) 


}


#run the application
shinyApp(ui = ui, server = server)



















