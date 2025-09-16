fluidPage(
  # Ajouter une image dans le titre de l'application
  tags$head(
    tags$title("Application Allociné"),
    tags$style(HTML("
      .shiny-title {
        display: flex;
        align-items: center;
      }
      .shiny-title img {
        width: 300px; /* ajuster la taille de l'image */
        margin-right: 100px;
      }
    "))
  ),
  
  # Titre avec image
  div(class = "shiny-title",
      img(src = "logo_allocine.jpg"), # Remplacez par le nom de votre image dans le dossier www
      h1("Application Allociné")
  ),
  
  # Sidebar avec un selectInput pour genre et couleur
  sidebarLayout(
    sidebarPanel(
      "Barre LATERAL !!!!",
      selectInput("genre",
                  "Choix du Genre :",
                  choices = c("Tous les genres", unique(allo_cine$genre))),
      selectInput("couleur",
                  "Choisir la couleur :",
                  choices = c("salmon", "darkblue", "darkgreen")),
      checkboxInput("reprise",
                   "Inclure les film repris ?")
    ),
    
    # Affichage du graphique
    mainPanel(
      plotlyOutput("graph_nombre_film_annee")
    )
  )
)