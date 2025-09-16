# Define server logic required to draw a histogram
function(input, output, session) {
    
  
  allocine_plot <- eventReactive(input$go, {
    if(input$genre != "Tous les genres"){
      
      allocine_plot <- allo_cine %>% 
        filter(genre == input$genre)
    }
    else {
      allocine_plot <- allo_cine
    }
    if(input$reprise == FALSE){
      allocine_plot <- allocine_plot %>% 
        filter(reprise != TRUE)
    }
    return(allocine_plot)
    
  })
    output$graph_nombre_film_annee <- renderPlotly({
      
      ggplotly(
        
        allocine_plot() %>% 
          mutate(annee_de_sortie = year(date_sortie)) %>% 
          count(annee_de_sortie) %>% 
          ggplot() +
          geom_line(aes(x = annee_de_sortie, y = n), color = input$couleur) +  
          labs(
            title =paste0( "Evolution du nombre film par an : ",input$genre),
            y = "nbr de film") +
          theme_bw()
      )
      
      
    })
    
    output$table_evolution <- renderDT({

      df <-allocine_plot() %>% 
        mutate(annee_de_sortie = year(date_sortie)) %>% 
        count(annee_de_sortie)
      
      datatable(df, 
                extensions = c('Buttons', 'Responsive', 'FixedHeader', 'Scroller', 'KeyTable', 'ColReorder'),
                options = list(
                  dom = 'Bfrtip',  # Boutons + filtre + pagination
                  pageLength = 10,
                  autoWidth = TRUE,
                  scrollX = TRUE,  # Scroll horizontal si trop large
                  scrollY = TRUE,  # Scroll vertical
                  scroller = TRUE,
                  fixedHeader = TRUE,
                  colReorder = TRUE,
                  keys = TRUE,
                  responsive = TRUE,
                  buttons = list('copy', 'csv', 'excel', 'pdf')  # Boutons d'export
                ),
                filter = 'top',  # Filtres au-dessus de chaque colonne
                selection = 'multiple',  # Sélection multiple des lignes
                rownames = FALSE)
      
    })

}
