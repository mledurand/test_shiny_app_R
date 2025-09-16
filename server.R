# Define server logic required to draw a histogram
function(input, output, session) {
    
    output$graph_nombre_film_annee <- renderPlotly({
      
      if(input$genre != "Tous les genres"){
        
        allocine_plot <- allo_cine %>% 
          filter(genre == input$genre)
      }
      else {
        allocine_plot <- allo_cine
      }
      
      ggplotly(
        
        allocine_plot %>% 
          mutate(annee_de_sortie = year(date_sortie)) %>% 
          count(annee_de_sortie) %>% 
          ggplot() +
          geom_line(aes(x = annee_de_sortie, y = n), color = input$couleur) +  
          labs(
            title = "Evolution du nombre film par an",
            subtitle = paste0("Genre choisi :",input$genre),
            y = "nbr de film") +
          theme_bw()
      )
      
      
    })

}
