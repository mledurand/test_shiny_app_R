# Package tidyverse----
library(dplyr) # traitement des données
library(readr) # chargement des fichier ( date automatique )
library(readxl) # pour du xl
library(ggplot2)
library(forcats)
# date ----
data <- readr::read_csv2("data/data_allocine.csv")

# apercu ----
summary(data)

str(data)

dplyr::glimpse(data) # meilleurs aperçu par rapport à str()

head(data,10) # 10 premières lignes

# nature de l'objet ----
class(data) # tbl = tiblle = dataframe améliorer

# compter le nbr de film par nationalité
count(data, nationalite) # fonction tidyverse

table(data$nationalite) 

# supprimé la variable récompense ----
data_allocine <- select(data, -recompenses)

# filtre des lignes via une conditions ----
data_allocine_filter <- data_allocine %>% filter(type_film == "Long-métrage")
count(data_allocine_filter,type_film)

# renommer titre en titre_film ----
data_allocine_rename <- data_allocine %>% rename(titre_filme = titre)

# ranger dans l'ordre ----
data_allocine_trie <- data_allocine %>% arrange(note_presse,desc(note_spectateurs))


# pipe pour enchainement, lister les 3 films italien les plus long  ----
data_allocine_italien <- data_allocine %>%
  filter(nationalite == "italien") %>% 
  arrange(desc(duree)) %>% 
  head(3)

# exercice ----
# lister les films francais ayant une note presse superieur à 4 tié dans l'ordre croissant et afficher uniquement leur titre et note 
film <- data_allocine %>% 
  filter(nationalite == "français", note_presse >= 4) %>% 
  select(titre, note_presse) %>% 
  arrange(desc(note_presse))
write_excel_csv2(film,"liste_film_francais.csv")


# jointure ----
correspondance <- readxl::read_excel("data/correspondances_allocine.xlsx")

allo_cine <- data_allocine_filter %>% 
  left_join(correspondance, by = c("nationalite"="nationalité"))

# nbr de film d'europe de l'ouest qui sont des drama ----
allo_cine %>% 
  filter(genre == "Drame") %>%
  count(region) %>% 
  arrange(desc(n)) %>% 
  filter(!is.na(region))

# calcule d'aggregation ----
# calculer la moyenne note presse et moyenne spectateur et le nbr de films

data_allocine %>% 
  summarize(
    moyenne_presse = mean(note_presse,na.rm = TRUE),
    moyennes_spectateurs =mean(note_spectateurs,na.rm = TRUE),
    nb_film = n()
  )
# group_by , (group_by seul ne fait rien à melanger avec summarise) ----
# group by region avec les memes calcule
allo_cine %>%
  group_by(region) %>% 
  summarize(
    moyenne_presse = mean(note_presse,na.rm = TRUE),
    moyennes_spectateurs =mean(note_spectateurs,na.rm = TRUE),
    nb_film = n()
  )

# calculer sur les films d'europe de l'ouest, la duree moyenn et le nbr de films par genre sur les 5 genre ayant le plus de films

allo_cine %>% 
  filter(region == "Europe de l'ouest") %>% 
  group_by(genre) %>% 
  summarise(
    duree_moyennes = mean(duree,na.rm = TRUE),
    nb_films = n()        
  ) %>% 
  arrange(desc(nb_films)) %>% 
  head(5)

# mutate, creer une colonne total qui est la somme de presse et spectateur ----

allocine <- allo_cine %>% 
  mutate(total = (note_presse+note_spectateurs) / 2)

summarise(allocine,moyen = mean(total,na.rm= TRUE))

good <- allo_cine %>% 
  mutate(tr_note = if_else(condition = note_presse < 5 ,true ="Mauvais film"  ,
                           false = if_else(note_presse < 7.5,"Bof film","Bon film")  )
  )
# le case_when est mieux dans les cas complex >2

# graphique avec ggplot2 ----
# nbr de film par région, represente par des barres
allo_cine %>%
  filter(!is.na(region)) %>% 
  count(region) %>% 
  mutate(region = fct_reorder(region, -n)) %>%  # reordonne les régions selon n
  ggplot() +
  geom_col(aes(x = region, y = n, fill = region)) +
  geom_text(aes(x = region, y = n, label = n), 
            vjust = -0.5) +  # positionne le texte juste au-dessus des barres
  ggtitle("Nombre de film par région") +
  labs(y = "nbr de film")

# Format Date ----
library(lubridate)
# mutate (date =  ymd( date))

# graph chronologique

allo_cine %>% 
  mutate(annee_de_sortie = year(date_sortie)) %>% 
  count(annee_de_sortie) %>% 
  ggplot() +
  geom_line(aes(x = annee_de_sortie, y = n), color = "salmon") +  
  ggtitle("Nombre de film par année") +
  labs(y = "nbr de film") +
  theme_bw()

# exercice 
# represente par des barre ordoonée, les notes globales medianes par genre de film uniquement genre > 100 films

allo_cine %>% 
  mutate(note = note_presse + note_spectateurs) %>% 
  group_by(genre) %>% 
  summarise(
    mediane_note = median(note,na.rm = TRUE),
    nb_film = n()
  ) %>% 
  filter(nb_film >=100) %>% 
  mutate(genre = fct_reorder(genre, -mediane_note)) %>%  # reordonne les régions selon n
  ggplot() +
  geom_col(aes(x = genre, y = mediane_note, fill = mediane_note)) +
  geom_text(aes(x = genre, y = mediane_note, label = mediane_note), 
            vjust = -0.5) +  # positionne le texte juste au-dessus des barres
  ggtitle("Nombre de film par genre") +
  labs(y = "nbr de film",
       subtitle = "genre avec plus de 100 films")

# Shiny ----


