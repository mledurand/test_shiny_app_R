fluidPage(
  #themeSelector(), # ou bslib
   theme = shinytheme("journal"),
  # Ajouter une image dans le titre de l'application
  tags$head(
    tags$title("Application Allociné"),
    tags$style(HTML("
      .shiny-title {
        display: flex;
        align-items: center;
      }
      .shiny-title img {
        width: 3000px; /* ajuster la taille de l'image */
        margin-right: 0px;
        height: 150px
      }
    "))
  ),
  
  # Titre avec image
  div(class = "shiny-title",
      img(src = "logo_allocine.jpg") # Remplacez par le nom de votre image dans le dossier www
  ),
  navbarPage("Application allocine",
             tabPanel("principal" ,#page principal
             
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
      tabsetPanel(  
        tabPanel("graphique",
                 plotlyOutput("graph_nombre_film_annee")),
        tabPanel("Tableau",
                 DTOutput("table_evolution"))
        )

    )
  )
  ),
  tabPanel("A propos",
           "ceci est un texte qui est censé etre à propos",strong("Allocine"))
  )
)