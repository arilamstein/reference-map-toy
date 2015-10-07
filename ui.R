library(shiny)
library(choroplethrZip)

# taken from ggmap -> ?get_map
reference_map_types = c("terrain", "terrain-background", "satellite",
                        "roadmap", "hybrid", "toner", "watercolor", 
                        "terrain-labels", "terrain-lines", "toner-2010", 
                        "toner-2011", "toner-background", "toner-hybrid",
                        "toner-labels", "toner-lines", "toner-lite")

data(df_zip_demographics)
demographics = colnames(df_zip_demographics)[2:ncol(df_zip_demographics)]

shinyUI(fluidPage(

  titlePanel("Choroplethr Reference Map Toy"),
  div(HTML("By <a href='http://www.arilamstein.com'>Ari Lamstein</a>.<br/>
           Want to create apps like this? Take my free course <a href='http://www.arilamstein.com/free-course'>Learn to Map Census Data in R</a>.")),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId  = "maptype",
                  label    = "Reference Map Type",
                  choices  = reference_map_types,
                  selected = "hybrid"),
      
      radioButtons(inputId = "color",
                  label    = "Color:",
                  choices  = c("color", "bw"),
                  selected = "bw"),
      
      checkboxInput(input = "reference_map",
                    label = "Include Reference Map",
                    value = TRUE)
    ),
    
    mainPanel(
      imageOutput("map", width="640px", height="480px")
    )
  )
))
