# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Application Allociné"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          "Barre LATERAL !!!!",
            selectInput("genre",
                        "Choix du Genre :",
                        choices = unique(allo_cine$genre)),
            selectInput("couleur",
                        "couleur !!!",
                        choices = c("salmon","darkblue","darkgreen"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("graph_nombre_film_annee")
        )
    )
)
