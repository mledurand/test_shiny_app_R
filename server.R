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
    # output$graph_nombre_film_annee <- renderPlotly({
    #   
    #   ggplotly(
    #     
    #     allocine_plot() %>% 
    #       mutate(annee_de_sortie = year(date_sortie)) %>% 
    #       count(annee_de_sortie) %>% 
    #       ggplot() +
    #       geom_line(aes(x = annee_de_sortie, y = n), color = input$couleur) +  
    #       labs(
    #         title =paste0( "Evolution du nombre film par an : ",input$genre),
    #         y = "nbr de film") 
    #       
    #   )
    #   
    #   
    # })
    
  output$graph_nombre_film_annee <- renderGirafe({
    
    # Préparer les données
    df <- allocine_plot() %>% 
      mutate(annee_de_sortie = year(date_sortie)) %>% 
      count(annee_de_sortie)
    
    # Créer le plot
    plot <- ggplot(df, aes(x = annee_de_sortie, y = n)) +
      geom_line_interactive(aes(
        tooltip = paste("Nombre de films sortis en", annee_de_sortie, ":", n),
        group = 1
      ), color = input$couleur) +
      labs(
        title = paste("Evolution du nombre de films par an :", input$genre),
        y = "Nombre de films",
        subtitle = paste("Genre choisi:", input$genre)
      ) +
      theme_minimal()
    
    # Afficher le graphique avec interactivité
    girafe(ggobj = plot)
  })
  
  
    
    # output$table_evolution <- renderDT({
    # 
    #   df <-allocine_plot() %>% 
    #     mutate(annee_de_sortie = year(date_sortie)) %>% 
    #     group_by(annee_de_sortie) %>% 
    #     summarize(nombre = n())
    #   
    #   datatable(df, 
    #             extensions = c('Buttons', 'Responsive', 'FixedHeader', 'Scroller', 'KeyTable', 'ColReorder'),
    #             options = list(
    #               dom = 'Bfrtip',  # Boutons + filtre + pagination
    #               pageLength = 10,
    #               autoWidth = TRUE,
    #               scrollX = TRUE,  # Scroll horizontal si trop large
    #               scrollY = TRUE,  # Scroll vertical
    #               scroller = TRUE,
    #               fixedHeader = TRUE,
    #               colReorder = TRUE,
    #               keys = TRUE,
    #               responsive = TRUE,
    #               buttons = list('copy', 'csv', 'excel', 'pdf')  # Boutons d'export
    #             ),
    #             filter = 'top',  # Filtres au-dessus de chaque colonne
    #             selection = 'multiple',  # Sélection multiple des lignes
    #             rownames = FALSE)
    #   
    # })
  
  output$table_evolution <- renderUI({
    df <- allocine_plot() %>% 
      mutate(annee = year(date_sortie)) %>% 
      count(annee)
    
    df %>%
      kbl(col.names = c("Année", "Nombre de films"), 
          caption = "Évolution des films par année") %>%
      kable_styling(full_width = FALSE, bootstrap_options = c("striped", "hover", "condensed")) %>%
      HTML()
  })
  
  
  
    observeEvent(input$ok,{
      showNotification("affichage des données sur le choix :" ,input$genre)
    })

}
