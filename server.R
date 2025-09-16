# Define server logic required to draw a histogram
function(input, output, session) {
    
    output$graph_nombre_film_annee <- renderPlotly({
      ggplotly(
        allo_cine %>% 
          mutate(annee_de_sortie = year(date_sortie)) %>% 
          filter(genre == input$genre) %>% 
          count(annee_de_sortie) %>% 
          ggplot() +
          geom_line(aes(x = annee_de_sortie, y = n), color = input$couleur) +  
          ggtitle("Nombre de film par année") +
          labs(y = "nbr de film") +
          theme_bw()
      )
    })

}
