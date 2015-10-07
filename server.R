library(shiny)
library(choroplethrZip)
library(R6)
library(choroplethr)
library(RgoogleMaps)
library(ggmap)

get_choropleth_object = function(maptype, color)
{
  R6Class("MyZipChoropleth",
    inherit = ZipChoropleth,
    public = list(
      
      get_reference_map = function()
      {
        # note: center is (long, lat) but MaxZoom is (lat, long)
        
        center = c(mean(self$choropleth.df$long), 
                   mean(self$choropleth.df$lat))
        
        max_zoom = MaxZoom(range(self$choropleth.df$lat), 
                           range(self$choropleth.df$long))
        
        get_map(location = center,
                zoom     = max_zoom,
                maptype  = maptype,
                color    = color)  
      }
    )
  )
}


data(df_zip_demographics)
df_zip_demographics$value = df_zip_demographics$per_capita_income
nyc_fips = c(36005, 36047, 36061, 36081, 36085)

shinyServer(function(input, output) {

  output$map = renderImage({

    if (input$reference_map)
    {
      filename = paste0(input$maptype, 
                        "-",
                        input$color,
                        "-",
                        input$reference_map,
                        ".png")
    } else {
      filename = "no-reference-map.png"
    }
    
    if (file.exists(filename))
    {
      list(src         = filename,
           contentType = 'image/png',
           width       = 640,
           height      = 480,
           alt         = filename)
    } else {
      c = get_choropleth_object(input$maptype, input$color)
      c = c$new(df_zip_demographics)
      c$set_zoom_zip(state_zoom = NULL, county_zoom = nyc_fips, msa_zoom = NULL, zip_zoom = NULL) 
      c$set_num_colors(4)
      c$title = "2013 New York City ZIP Code Tabulated Areas (ZCTAs)"
      c$legend = "Per Capita Income"
      
      png(filename, width=640, height=480)
      if (input$reference_map) {
        print(c$render_with_reference_map())
      } else {
        print(c$render())
      }
      dev.off()
      
      list(src         = filename,
           contentType = 'image/png',
           width       = 640,
           height      = 480,
           alt         = filename)
    }
  }, deleteFile = FALSE)
})
